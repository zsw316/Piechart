//
//  LPPieChartController.m
//  LearningPlatform
//
//  Created by Shaowei Zhang on 19/2/2017.
//  Copyright © 2017 SWZ. All rights reserved.
//

#import "PieChartController.h"
#import "PieChartView.h"
#import "PieChartItem.h"

@interface PieChartController ()
{
    UILabel *_titleLabel;
    UILabel *_developerLabel;
    UITextField *_developerTextField;
    
    UILabel *_testerLabel;
    UITextField *_testerTestField;
    UILabel *_pmLabel;
    UITextField *_pmTextField;
    UILabel *_opsLabel;
    UITextField *_opsTextField;
    PieChartView *_pieChart;
    
    BOOL _isEditing;
}
@end

@implementation PieChartController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Pie Chart";
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonClicked)];
    self.navigationItem.rightBarButtonItem = editButton;
    _isEditing = NO;
    
    [self createSubviews];
    
    CGFloat pieChartRadius = 150;
    CGFloat pieChartX = CGRectGetWidth(self.view.bounds) / 2.0 - pieChartRadius;
    CGFloat pieChartY = 150;
    CGFloat pieChartWidth = pieChartRadius*2 + 20;
    CGFloat pieChartHeight = pieChartRadius*2 + 20;
    
    _pieChart = [[PieChartView alloc] initWithFrame:CGRectMake(pieChartX, pieChartY, pieChartWidth, pieChartHeight)];
    _pieChart.radius = pieChartRadius;
    _pieChart.innerRadius = 33;
    _pieChart.clickedRadius = pieChartRadius + 10;
    _pieChart.itemArray = [self buildPieChartItemArray];
    _pieChart.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_pieChart];
}

- (void)createSubviews {
//    CGFloat labelWidth = 200;
//    CGFloat labelX = (CGRectGetWidth(self.view.frame) - labelWidth) / 2.0;
//    CGFloat labelY = 22;
//    CGFloat labelHeight = 22;
//    
//    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelWidth, labelHeight)];
//    _titleLabel.textColor = [UIColor whiteColor];
//    _titleLabel.font = [UIFont systemFontOfSize:18.0f];
//    _titleLabel.textAlignment = NSTextAlignmentCenter;
//    _titleLabel.text = @"Personnel Distribution";
//    [self.view addSubview:_titleLabel];
    
    _developerLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 52, 100, 30)];
    _developerLabel.textColor = [UIColor whiteColor];
    _developerLabel.backgroundColor = [UIColor colorWithRed:77.0 / 255.0 green:216.0 / 255.0 blue:122.0 / 255.0 alpha:1.0f];
    _developerLabel.font = [UIFont systemFontOfSize:14.f];
    _developerLabel.textAlignment = NSTextAlignmentCenter;
    _developerLabel.text = @"Developers";
    [self.view addSubview:_developerLabel];
    
    _developerTextField = [[UITextField alloc] initWithFrame:CGRectMake( 130, 52, 50, 30)];
    _developerTextField.borderStyle = UITextBorderStyleNone;
    _developerTextField.backgroundColor = [UIColor clearColor];
    _developerTextField.textColor = [UIColor blackColor];
    _developerTextField.font = [UIFont systemFontOfSize:14.f];
    _developerTextField.textAlignment = NSTextAlignmentCenter;
    _developerTextField.text = @"10";
    _developerTextField.enabled = NO;
    [self.view addSubview:_developerTextField];
    
    _testerLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 52, 100, 30)];
    _testerLabel.textColor = [UIColor whiteColor];
    _testerLabel.backgroundColor = [UIColor redColor];
    _testerLabel.font = [UIFont systemFontOfSize:14.f];
    _testerLabel.textAlignment = NSTextAlignmentCenter;
    _testerLabel.text = @"Testers";
    [self.view addSubview:_testerLabel];
    
    _testerTestField = [[UITextField alloc] initWithFrame:CGRectMake( 308, 52, 50, 30)];
    _testerTestField.borderStyle = UITextBorderStyleNone;
    _testerTestField.backgroundColor = [UIColor clearColor];
    _testerTestField.textColor = [UIColor blackColor];
    _testerTestField.font = [UIFont systemFontOfSize:14.f];
    _testerTestField.textAlignment = NSTextAlignmentCenter;
    _testerTestField.text = @"50";
    _testerTestField.enabled = NO;
    [self.view addSubview:_testerTestField];
    
    _pmLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 90, 100, 30)];
    _pmLabel.textColor = [UIColor whiteColor];
    _pmLabel.backgroundColor = [UIColor blueColor];
    _pmLabel.font = [UIFont systemFontOfSize:14.f];
    _pmLabel.textAlignment = NSTextAlignmentCenter;
    _pmLabel.text = @"PMs";
    [self.view addSubview:_pmLabel];
    
    _pmTextField = [[UITextField alloc] initWithFrame:CGRectMake( 130, 90, 50, 30)];
    _pmTextField.borderStyle = UITextBorderStyleNone;
    _pmTextField.backgroundColor = [UIColor clearColor];
    _pmTextField.textColor = [UIColor blackColor];
    _pmTextField.font = [UIFont systemFontOfSize:14.f];
    _pmTextField.textAlignment = NSTextAlignmentCenter;
    _pmTextField.text = @"30";
    _pmTextField.enabled = NO;
    [self.view addSubview:_pmTextField];
    
    _opsLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 90, 100, 30)];
    _opsLabel.textColor = [UIColor whiteColor];
    _opsLabel.backgroundColor = [UIColor purpleColor];
    _opsLabel.font = [UIFont systemFontOfSize:14.f];
    _opsLabel.textAlignment = NSTextAlignmentCenter;
    _opsLabel.text = @"Ops";
    [self.view addSubview:_opsLabel];
    
    _opsTextField = [[UITextField alloc] initWithFrame:CGRectMake( 308, 90, 50, 30)];
    _opsTextField.borderStyle = UITextBorderStyleNone;
    _opsTextField.backgroundColor = [UIColor clearColor];
    _opsTextField.textColor = [UIColor blackColor];
    _opsTextField.font = [UIFont systemFontOfSize:14.f];
    _opsTextField.textAlignment = NSTextAlignmentCenter;
    _opsTextField.text = @"40";
    _opsTextField.enabled = NO;
    [self.view addSubview:_opsTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)editButtonClicked {
    
    if (!_isEditing) {
        self.navigationItem.rightBarButtonItem.title = @"Done";
        _developerTextField.enabled = YES;
        _developerTextField.backgroundColor = [UIColor whiteColor];
        [_developerTextField becomeFirstResponder];
        
        _testerTestField.enabled = YES;
        _testerTestField.backgroundColor = [UIColor whiteColor];
        
        _pmTextField.enabled = YES;
        _pmTextField.backgroundColor = [UIColor whiteColor];
        
        _opsTextField.enabled = YES;
        _opsTextField.backgroundColor = [UIColor whiteColor];
        
    } else {
        CGFloat _developerNum = [_developerTextField.text floatValue];
        CGFloat _testerNum = [_testerTestField.text floatValue];
        CGFloat _pmNum = [_pmTextField.text floatValue];
        CGFloat _opsNum = [_opsTextField.text floatValue];
        
        if (_developerNum<1 || _developerNum>100 || _testerNum<0 || _testerNum>100 || _pmNum<0 || _pmNum>100 || _opsNum<0 || _opsNum>100) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Invalid input" message:@"The value must be between 0 and 100" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
            return;
        }
        
        self.navigationItem.rightBarButtonItem.title = @"Edit";
        _developerTextField.enabled = NO;
        _developerTextField.backgroundColor = [UIColor clearColor];
        _testerTestField.enabled = NO;
        _testerTestField.backgroundColor = [UIColor clearColor];
        _pmTextField.enabled = NO;
        _pmTextField.backgroundColor = [UIColor clearColor];
        _opsTextField.enabled = NO;
        _opsTextField.backgroundColor = [UIColor clearColor];
        
        _pieChart.itemArray = [self buildPieChartItemArray];
        [_pieChart setNeedsDisplay];
    }
    
    _isEditing = !_isEditing;
}

- (void)viewDidLayoutSubviews {
    
}

#pragma mark - 构造测试数据
- (NSArray<PieChartItem *> *)buildPieChartItemArray {
    NSMutableArray *itemArray = [[NSMutableArray alloc] init];
    
    {
        PieChartItem *item = [[PieChartItem alloc] init];
        item.name = _developerLabel.text;
        item.value = [_developerTextField.text floatValue];
        item.color = _developerLabel.backgroundColor;
        [itemArray addObject:item];
    }
    
    {
        PieChartItem *item = [[PieChartItem alloc] init];
        item.name = _testerLabel.text;
        item.value = [_testerTestField.text floatValue];
        item.color = _testerLabel.backgroundColor;
        [itemArray addObject:item];
    }
    
    {
        PieChartItem *item = [[PieChartItem alloc] init];
        item.name = _pmLabel.text;
        item.value = [_pmTextField.text floatValue];
        item.color = _pmLabel.backgroundColor;
        [itemArray addObject:item];
    }
    
    {
        PieChartItem *item = [[PieChartItem alloc] init];
        item.name = _opsLabel.text;
        item.value = [_opsTextField.text floatValue];
        item.color = _opsLabel.backgroundColor;
        [itemArray addObject:item];
    }
    
    return itemArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
