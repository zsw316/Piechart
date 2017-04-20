//
//  LPPieChartItem.h
//  LearningPlatform
//
//  Created by Shaowei Zhang on 19/2/2017.
//  Copyright © 2017 SWZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PieChartItem : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) CGFloat startPercentage;
@property (nonatomic, assign) CGFloat endPercentage;
@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat endAngle;

@end
