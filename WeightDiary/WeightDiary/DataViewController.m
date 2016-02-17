//
//  DataViewController.m
//  WeightDiary
//
//  Created by 罗思成 on 16/2/10.
//
//

#import "DataViewController.h"
#import "UIColor+HexString.h"
#import "Config.h"
#import "AddRecordViewController.h"
#import "InputViewController.h"

@interface DataViewController ()

@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    double delta = [Config firstRecord] - [Config latestRecord];
    if (delta < 0.1) {
        self.weightDrop = @"0.0";
    } else {
        self.weightDrop = [NSString stringWithFormat:@"%.1lf", delta];
    }
    
    self.historyData = [[[Config latestRecordWithCount:8] reverseObjectEnumerator] allObjects];
    NSLog(@"%@", self.historyData);
    
    [self setupAddButton];
    [self setupSetUserButton];
    [self setupTargetChart];
    [self setupDataLabel];
    [self setupHistoryChart];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.targetChart) {
        [self.targetChart strokeChart];
    }
    
    if (self.view) {
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            for (UIView *subView in self.view.subviews) {
                if (subView != self.targetChart && subView != self.historyChart) {
                    subView.alpha = 0;
                    subView.alpha = 1;
                }
            }
        } completion:nil];
        [self.historyChart reloadGraph];
    }
}

#pragma - Setup Chart View

- (void)setupTargetChart {
    // setup position and size for label and chart
    CGFloat targetChartTop = 40;
    CGFloat targetChartLeft = 80;
    CGFloat targetChartWidth = CGRectGetWidth(self.view.bounds) - targetChartLeft * 2;
    
    CGFloat dropHeight = 60;
    CGFloat dropTop = targetChartTop + targetChartWidth / 2 - dropHeight / 2;
    CGFloat dropLeft = targetChartLeft + 40;
    CGFloat dropWidth = CGRectGetWidth(self.view.bounds) - dropLeft * 2;
    
    CGFloat dropTipHeight = 30;
    CGFloat dropTipTop = dropTop - dropTipHeight;
    CGFloat dropTipLeft = targetChartLeft + 40;
    CGFloat dropTipWidth = CGRectGetWidth(self.view.bounds) - dropTipLeft * 2;
    
    
    double total = 0, current = 0;
    if ([Config firstRecord] > 0) {
        total = fabs([Config firstRecord] - [Config userTargetValue]);
        current = [self.weightDrop doubleValue];
    }
    
    // setup target chart
    self.targetChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(targetChartLeft, targetChartTop, targetChartWidth, targetChartWidth) total:[NSNumber numberWithDouble:total] current:[NSNumber numberWithDouble:current] clockwise:YES shadow:YES shadowColor:[UIColor colorWithHexString:@"#d3e2e7"] displayCountingLabel:NO overrideLineWidth:@2];
    self.targetChart.backgroundColor = [UIColor clearColor];
    self.targetChart.strokeColor = [UIColor colorWithHexString:@"#47b5e5"];
    [self.view addSubview:self.targetChart];
    
    // setup drop tip
    UILabel *dropTip = [[UILabel alloc] initWithFrame:CGRectMake(dropTipLeft, dropTipTop, dropTipWidth, dropTipHeight)];
    dropTip.text = @"已经减了";
    dropTip.textColor = [UIColor colorWithHexString:@"#858e9b"];
    dropTip.font = [UIFont systemFontOfSize:16];
    dropTip.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:dropTip];
    
    // setup drop label
    UILabel *drop = [[UILabel alloc] initWithFrame:CGRectMake(dropLeft, dropTop, dropWidth, dropHeight)];
    
    NSString *dropString = [NSString stringWithFormat:@"  %@kg", self.weightDrop];
    NSMutableAttributedString *dropText = [[NSMutableAttributedString alloc] initWithString:dropString];
    [dropText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:25] range:NSMakeRange(0, 2)];
    [dropText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:50] range:NSMakeRange(2, 3)];
    [dropText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:25] range:NSMakeRange(5, 2)];
    drop.attributedText = dropText;
    
    drop.textColor = [UIColor colorWithHexString:@"#404d5f"];
    drop.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:drop];
}

- (void)setupHistoryChart {
    CGFloat historyChartTop = 40 + CGRectGetWidth(self.view.bounds) - 80 * 2 + 20 + 90 * 2 + 1;
    CGFloat historyChartHeight = CGRectGetHeight(self.view.bounds) - 60 - historyChartTop;
    
    self.historyChart = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, historyChartTop, SCREEN_WIDTH - 50, historyChartHeight)];
    self.historyChart.delegate = self;
    self.historyChart.dataSource = self;
    self.historyChart.enableBezierCurve = YES;
    self.historyChart.colorTop = [UIColor whiteColor];
    self.historyChart.colorBottom = [UIColor colorWithHexString:@"#cfedfe"];
    self.historyChart.widthLine = 2;
    self.historyChart.colorLine = [UIColor colorWithHexString:@"#7acbf9"];
    self.historyChart.enableXAxisLabel = YES;
    self.historyChart.enableTouchReport = YES;
    self.historyChart.sizePoint = 10;
    self.historyChart.colorPoint = [UIColor colorWithHexString:@"#7a899b"];
    self.historyChart.alwaysDisplayDots = YES;
    self.historyChart.colorXaxisLabel = [UIColor clearColor];
    self.historyChart.enablePopUpReport = YES;
    self.historyChart.colorBackgroundPopUplabel = [UIColor colorWithHexString:@"#cfedfe"];
    self.historyChart.formatStringForValues = @"%.1f";
    
    [self.view addSubview:self.historyChart];
}

#pragma - Setup data label

- (void)setupDataLabel {
    // setup position and size
    CGFloat sectionHeight = 90;
    CGFloat lineTop = 40 + CGRectGetWidth(self.view.bounds) - 80 * 2 + 20;
    CGFloat secondLineTop = 40 + CGRectGetWidth(self.view.bounds) - 80 * 2 + sectionHeight + 20 ;
    
    CGFloat beginWeightTipHeight = 30;
    CGFloat beginWeightTipTop = lineTop + 10;
    CGFloat beginWeightTipLeft = 30;
    CGFloat beginWeightTipWidth = CGRectGetWidth(self.view.bounds) / 2 - 20 * 2;
    
    CGFloat beginWeightHeight = 40;
    CGFloat beginWeightTop = beginWeightTipTop + beginWeightTipHeight - 5;
    CGFloat beginWeightLeft = beginWeightTipLeft - 2;
    CGFloat beginWeightWidth = CGRectGetWidth(self.view.bounds) / 2 - 20 * 2;
    
    CGFloat targetWeightTipHeight = 30;
    CGFloat targetWeightTipTop = lineTop + 10;
    CGFloat targetWeightTipLeft = CGRectGetWidth(self.view.bounds) / 2 + 30;
    CGFloat targetWeightTipWidth = CGRectGetWidth(self.view.bounds) / 2 - 20 * 2;
    
    CGFloat targetWeightHeight = 40;
    CGFloat targetWeightTop = targetWeightTipTop + targetWeightTipHeight - 5;
    CGFloat targetWeightLeft = targetWeightTipLeft - 2;
    CGFloat targetWeightWidth = CGRectGetWidth(self.view.bounds) / 2 - 20 * 2;
    
    CGFloat currentWeightTipHeight = 30;
    CGFloat currentWeightTipTop = secondLineTop + 10;
    CGFloat currentWeightTipLeft = 30;
    CGFloat currentWeightTipWidth = CGRectGetWidth(self.view.bounds) / 2 - 20 * 2;
    
    CGFloat currentWeightHeight = 40;
    CGFloat currentWeightTop = currentWeightTipTop + currentWeightTipHeight - 5;
    CGFloat currentWeightLeft = currentWeightTipLeft - 2;
    CGFloat currentWeightWidth = CGRectGetWidth(self.view.bounds) / 2 - 20 * 2;
    
    CGFloat bmiTipHeight = 30;
    CGFloat bmiTipTop = secondLineTop + 10;
    CGFloat bmiTipLeft = CGRectGetWidth(self.view.bounds) / 2 + 30;
    CGFloat bmiTipWidth = CGRectGetWidth(self.view.bounds) / 2 - 20 * 2;
    
    CGFloat bmiHeight = 40;
    CGFloat bmiTop = bmiTipTop + bmiTipHeight - 5;
    CGFloat bmiLeft = bmiTipLeft - 2;
    CGFloat bmiWidth = CGRectGetWidth(self.view.bounds) / 2 - 20 * 2;
    
    // setup borders
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, lineTop, CGRectGetWidth(self.view.bounds), 1)];
    [line1 setBackgroundColor:[UIColor colorWithHexString:@"#e6e8ea"]];
    [self.view addSubview:line1];
    
    UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, lineTop + sectionHeight, CGRectGetWidth(self.view.bounds), 1)];
    [line2 setBackgroundColor:[UIColor colorWithHexString:@"#e6e8ea"]];
    [self.view addSubview:line2];
    
    UIImageView *line3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, lineTop + sectionHeight * 2, CGRectGetWidth(self.view.bounds), 1)];
    [line3 setBackgroundColor:[UIColor colorWithHexString:@"#e6e8ea"]];
    [self.view addSubview:line3];
    
    UIImageView *line4 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) / 2 - 0.5, lineTop, 1, sectionHeight * 2)];
    [line4 setBackgroundColor:[UIColor colorWithHexString:@"#e6e8ea"]];
    [self.view addSubview:line4];
    
    
    double firstWeight = [Config firstRecord];
    if (firstWeight > 0) {
        // setup label for begin weight tip
        UILabel *beginWeightTip = [[UILabel alloc] initWithFrame:CGRectMake(beginWeightTipLeft, beginWeightTipTop, beginWeightTipWidth, beginWeightTipHeight)];
        beginWeightTip.text = @"初始体重 (kg)";
        beginWeightTip.textColor = [UIColor colorWithHexString:@"#858e9b"];
        beginWeightTip.font = [UIFont systemFontOfSize:14];
        beginWeightTip.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:beginWeightTip];
        
        // setup label for begin weight
        UILabel *beginWeight = [[UILabel alloc] initWithFrame:CGRectMake(beginWeightLeft, beginWeightTop, beginWeightWidth, beginWeightHeight)];
//        NSString *beginWeightString = [NSString stringWithFormat:@"%.1lfkg", firstWeight];
//        NSMutableAttributedString *beginWeightText = [[NSMutableAttributedString alloc] initWithString:beginWeightString];
//        NSRange kgRange = [beginWeightString rangeOfString:@"kg"];
//        [beginWeightText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:38] range:NSMakeRange(0, kgRange.location)];
//        [beginWeightText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:kgRange];
//        beginWeight.attributedText = beginWeightText;
        beginWeight.text = [NSString stringWithFormat:@"%.1lf", firstWeight];
        beginWeight.font = [UIFont systemFontOfSize:38];
        beginWeight.textColor = [UIColor colorWithHexString:@"#404d5f"];
        beginWeight.textAlignment = NSTextAlignmentLeft;
        
        [self.view addSubview:beginWeight];
    }
    
    double target = [Config userTargetValue];
    if (target > 0) {
        // setup label for target weight tip
        UILabel *targetWeightTip = [[UILabel alloc] initWithFrame:CGRectMake(targetWeightTipLeft, targetWeightTipTop, targetWeightTipWidth, targetWeightTipHeight)];
        targetWeightTip.text = @"目标体重 (kg)";
        targetWeightTip.textColor = [UIColor colorWithHexString:@"#858e9b"];
        targetWeightTip.font = [UIFont systemFontOfSize:14];
        targetWeightTip.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:targetWeightTip];
        
        // setup label for begin weight
        UILabel *targetWeight = [[UILabel alloc] initWithFrame:CGRectMake(targetWeightLeft, targetWeightTop, targetWeightWidth, targetWeightHeight)];
//        NSString *targetWeightString = [NSString stringWithFormat:@"%.1lfkg", target];
//        NSMutableAttributedString *targetWeightText = [[NSMutableAttributedString alloc] initWithString:targetWeightString];
//        NSRange kgRange = [targetWeightString rangeOfString:@"kg"];
//        [targetWeightText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:38] range:NSMakeRange(0, kgRange.location)];
//        [targetWeightText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:kgRange];
        targetWeight.text = [NSString stringWithFormat:@"%.1lf", target];
        targetWeight.font = [UIFont systemFontOfSize:38];
        targetWeight.textColor = [UIColor colorWithHexString:@"#404d5f"];
        targetWeight.textAlignment = NSTextAlignmentLeft;
        
        [self.view addSubview:targetWeight];
    }
    
    double currentWeightValue = [Config latestRecord];
    if (currentWeightValue > 0) {
        // setup label for current weight tip
        UILabel *currentWeightTip = [[UILabel alloc] initWithFrame:CGRectMake(currentWeightTipLeft, currentWeightTipTop, currentWeightTipWidth, currentWeightTipHeight)];
        currentWeightTip.text = @"当前体重 (kg)";
        currentWeightTip.textColor = [UIColor colorWithHexString:@"#858e9b"];
        currentWeightTip.font = [UIFont systemFontOfSize:14];
        currentWeightTip.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:currentWeightTip];
        
        // setup label for current weight
        UILabel *currentWeight = [[UILabel alloc] initWithFrame:CGRectMake(currentWeightLeft, currentWeightTop, currentWeightWidth, currentWeightHeight)];
        
        NSString *currentWeightString = [NSString stringWithFormat:@"%.1lfkg", currentWeightValue];
        NSMutableAttributedString *currentWeightText = [[NSMutableAttributedString alloc] initWithString:currentWeightString];
        NSRange kgRange = [currentWeightString rangeOfString:@"kg"];
        [currentWeightText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:38] range:NSMakeRange(0, kgRange.location)];
        [currentWeightText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:kgRange];
//        currentWeight.attributedText = currentWeightText;
        currentWeight.text = [NSString stringWithFormat:@"%.1lf", currentWeightValue];
        currentWeight.font = [UIFont systemFontOfSize:38];
        currentWeight.textColor = [UIColor colorWithHexString:@"#404d5f"];
        currentWeight.textAlignment = NSTextAlignmentLeft;
        
        [self.view addSubview:currentWeight];
    }
    
    if (target > 0) {
        // setup label for bmi tip
        UILabel *bmiTip = [[UILabel alloc] initWithFrame:CGRectMake(bmiTipLeft, bmiTipTop, bmiTipWidth, bmiTipHeight)];
        bmiTip.text = @"BMI";
        bmiTip.textColor = [UIColor colorWithHexString:@"#858e9b"];
        bmiTip.font = [UIFont systemFontOfSize:14];
        bmiTip.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:bmiTip];
        
        double bmiValue = [Config getBMIWithHeight:[Config userHeight] weight:[NSString stringWithFormat:@"%.1lf", [Config latestRecord]]];
        // setup label for begin weight
        UILabel *bmi = [[UILabel alloc] initWithFrame:CGRectMake(bmiLeft, bmiTop, bmiWidth, bmiHeight)];
        bmi.text = [NSString stringWithFormat:@"%.1lf", bmiValue];
        bmi.textColor = [UIColor colorWithHexString:@"#404d5f"];
        bmi.textAlignment = NSTextAlignmentLeft;
        bmi.font = [UIFont systemFontOfSize:38];
        [self.view addSubview:bmi];
    }
}

#pragma - Setup Add Button

- (void)setupAddButton {
    UIButton *add = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) - 20 - 20, 30, 30, 30)];
    [add setBackgroundImage:[UIImage imageNamed:@"add@3x.png"] forState:UIControlStateNormal];
    [add addTarget:self action:@selector(actionAdd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:add];
}

- (void)actionAdd {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromBottom;
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    
    AddRecordViewController *addRecord = [[AddRecordViewController alloc] init];
    [self presentViewController:addRecord animated:NO completion:nil];
}

#pragma - Setup SetUser Button

- (void)setupSetUserButton {
    UIButton *setUser = [[UIButton alloc] initWithFrame:CGRectMake(20, 30, 30, 30)];
    [setUser setBackgroundImage:[UIImage imageNamed:@"setUser@3x.png"] forState:UIControlStateNormal];
    [setUser addTarget:self action:@selector(actionSetUser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setUser];
}

- (void)actionSetUser {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromBottom;
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    
    InputViewController *inputView = [[InputViewController alloc] init];
    [self presentViewController:inputView animated:NO completion:nil];
}

#pragma - BEMSimpleLineGraphDataSource

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return [self.historyData count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [self.historyData[index][1] doubleValue];
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    return @"";
}

- (NSInteger)numberOfXAxisLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 5;
}

- (NSString *)popUpSuffixForlineGraph:(BEMSimpleLineGraphView *)graph {
    return @" kg";
}

#pragma - present new view

- (void)test {
    CATransition* transition = [CATransition animation];
    transition.duration = 1;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromBottom;
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    UIViewController *test = [[UIViewController alloc] init];
    test.view.backgroundColor = [UIColor redColor];
    [self presentViewController:test animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
