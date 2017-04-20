//
//  LPPieChartView.m
//  LearningPlatform
//
//  Created by Shaowei Zhang on 19/2/2017.
//  Copyright © 2017 SWZ. All rights reserved.
//

#import "PieChartView.h"
#import "PieChartItem.h"

@implementation PieChartView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _radius = 100;
        _innerRadius = 33;
        _clickedRadius = 110;
        _sliceSpace = 0;
        
        _selectedIndex = -1;
        _dataHasChanged = NO;
    }
    
    return self;
}

- (void)setItemArray:(NSArray<PieChartItem *> *)itemArray {
    
    // Calculate SUM value
    CGFloat sumValue = 0.0;
    for (PieChartItem *item in itemArray) {
        sumValue += item.value;
    }
    
    if (sumValue <= 0) {
        NSLog(@"itemArray is not valid: sum is zero");
        _itemArray = nil;
        return;
    }
    
    _itemArray = itemArray;
    _dataHasChanged = YES;
    
    //Calculate startPercentage, endPercentage, startAngle, endAngle for each item
    CGFloat rotationAngle = 270;
    CGFloat angle = 0.0;
    NSInteger index = 0;
    CGFloat startPercentage = 0;

    for (PieChartItem * item in _itemArray) {
        CGFloat value = item.value;
        item.startPercentage = startPercentage;
        item.endPercentage = item.startPercentage + item.value / sumValue;

        CGFloat sliceAngle = 360.0 * (value / sumValue);
        
        if (fabs(value) > 0.000001) {
            
            item.startAngle = rotationAngle + (angle + _sliceSpace / 2.0);
            CGFloat sweepAngle = (sliceAngle - _sliceSpace / 2.0);
            if (sweepAngle < 0.0) {
                sweepAngle = 0.0;
            }
            
            item.endAngle = item.startAngle + sweepAngle;
        }
        
        index ++;
        angle += sliceAngle;
        startPercentage = item.endPercentage;
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [self drawItems:_itemArray];
}

- (void)drawItems:(NSArray<PieChartItem *> *)itemArray {
    if (!itemArray || [itemArray count] == 0) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat radius = self.radius;
    CGFloat innerRadius = self.innerRadius;
    CGFloat centerRadius = innerRadius + (radius - innerRadius)/2.0;
    CGFloat centerX = CGRectGetMidX(self.bounds);
    CGFloat centerY = CGRectGetMidY(self.bounds);
    CGFloat deg2Rad = (M_PI / 180.0);
    
    NSInteger index = 0;
    if (_dataHasChanged && self.subviews.count>0) {
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
    }
    
    for (PieChartItem * item in itemArray) {
        CGFloat startAngle = item.startAngle;
        CGFloat endAngle = item.endAngle;
        CGFloat centerAngle = endAngle>startAngle ? (startAngle + (endAngle - startAngle) / 2.0) : (startAngle + (endAngle - startAngle + 360) / 2.0);
        CGFloat value = item.value;
      
        if (fabs(value) > 0.000001) {
            CGFloat outRadius = radius;
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, nil, centerX, centerY);
            CGPathAddArc(path, nil, centerX, centerY, outRadius, startAngle * deg2Rad, endAngle * deg2Rad, false);
            CGPathCloseSubpath(path);
            
            if (innerRadius > 0.0) {
                CGPathMoveToPoint(path, nil, centerX, centerY);
                CGPathAddArc(path, nil, centerX, centerY, innerRadius, startAngle * deg2Rad, endAngle * deg2Rad, false);
                CGPathCloseSubpath(path);
            }
            
            CGContextBeginPath(context);
            CGContextAddPath(context, path);
            CGContextSetFillColorWithColor(context, item.color.CGColor);
            CGContextEOFillPath(context);
            
            if (index == self.selectedIndex) {
                CGMutablePathRef path = CGPathCreateMutable();
                CGPathMoveToPoint(path, nil, centerX, centerY);
                CGPathAddArc(path, nil, centerX, centerY, _clickedRadius, startAngle * deg2Rad, endAngle * deg2Rad, false);
                CGPathCloseSubpath(path);
                
                if (innerRadius > 0.0) {
                    CGPathMoveToPoint(path, nil, centerX, centerY);
                    CGPathAddArc(path, nil, centerX, centerY, innerRadius, startAngle * deg2Rad, endAngle * deg2Rad, false);
                    CGPathCloseSubpath(path);
                }
                
                CGContextBeginPath(context);
                CGContextAddPath(context, path);
                CGContextSetFillColorWithColor(context, [item.color colorWithAlphaComponent:0.5].CGColor);
                CGContextEOFillPath(context);
            }
            
            if (_dataHasChanged) {
                
                // add a UILable in the center of this item
                CGPoint labelCenter = [self calcCircleCoordinateWithCenter:CGPointMake(centerX, centerY) andWithAngle:centerAngle andWithRadius:centerRadius];
                CGFloat labelWidth = 50;
                CGFloat labelHeight = 22;
                CGFloat labelX = labelCenter.x - labelWidth/2.0;
                CGFloat labelY = labelCenter.y - labelHeight/2.0;
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelWidth, labelHeight)];
                label.textColor = [UIColor whiteColor];
                label.font = [UIFont systemFontOfSize:14.f];
                label.textAlignment = NSTextAlignmentCenter;
                label.text = [NSString stringWithFormat:@"%.2f%%", (item.endPercentage-item.startPercentage)*100.f];
                [self addSubview:label];
            }
        }
        
        index ++;
    }
    
    _dataHasChanged = NO;
}

- (CGPoint)calcCircleCoordinateWithCenter:(CGPoint)center andWithAngle:(CGFloat)angle andWithRadius:(CGFloat)radius {
    
    return CGPointMake(center.x + radius*cosf(angle*M_PI/180), center.y + radius*sinf(angle*M_PI/180));
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInView:self];
        [self didTouchAt:touchLocation];
    }
}

- (void)didTouchAt:(CGPoint)touchLocation {
    if (self.selectedIndex != -1) {
        self.selectedIndex = -1;
        [self setNeedsDisplay];
        return;
    }
    
    CGFloat centerX = CGRectGetMidX(self.bounds);
    CGFloat centerY = CGRectGetMidY(self.bounds);
    CGPoint circleCenter = CGPointMake(centerX, centerY);
    CGFloat distanceFromCenter = sqrtf(powf((touchLocation.y - circleCenter.y),2) + powf((touchLocation.x - circleCenter.x),2));
    
    if (distanceFromCenter < _innerRadius) {
        self.selectedIndex = -1;
    } else {
        CGFloat percentage = [self findPercentageOfAngleInCircle:circleCenter fromPoint:touchLocation];
        
        for (NSInteger index = 0; index < [_itemArray count]; index ++) {
            CGFloat endPercentage = [_itemArray[index] endPercentage];
            if (percentage <= endPercentage) {
                self.selectedIndex = index;
                break;
            }
        }
    }
    
    [self setNeedsDisplay];
}

- (CGFloat)findPercentageOfAngleInCircle:(CGPoint)center fromPoint:(CGPoint)reference {
    CGFloat angleOfLine = atanf((reference.y - center.y) / (reference.x - center.x));
    CGFloat percentage = (angleOfLine + M_PI/2)/(2 * M_PI);
    return (reference.x - center.x) > 0 ? percentage : percentage + .5;
}

@end
