//
//  LPPieChartView.h
//  LearningPlatform
//
//  Created by Shaowei Zhang on 19/2/2017.
//  Copyright © 2017 SWZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PieChartItem;

@interface PieChartView : UIView

@property (nonatomic, strong) NSArray<PieChartItem *> *itemArray;

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat innerRadius;
@property (nonatomic, assign) CGFloat clickedRadius;
@property (nonatomic, assign) CGFloat sliceSpace;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic) BOOL dataHasChanged;


@end
