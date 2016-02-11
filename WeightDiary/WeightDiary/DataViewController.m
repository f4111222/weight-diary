//
//  DataViewController.m
//  WeightDiary
//
//  Created by 罗思成 on 16/2/10.
//
//

#import "DataViewController.h"
#import "UIColor+HexString.h"

@interface DataViewController ()

@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTargetChart];
    [self setupHistoryChart];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.targetChart) {
        [self.targetChart strokeChart];
    }
}

#pragma - Setup Chart View

- (void)setupTargetChart {
    self.targetChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(50, 50, CGRectGetWidth(self.view.bounds) - 50 * 2, CGRectGetWidth(self.view.bounds) - 50 * 2) total:@100 current:@90 clockwise:YES shadow:YES shadowColor:[UIColor whiteColor] displayCountingLabel:NO overrideLineWidth:@2];
    self.targetChart.backgroundColor = [UIColor clearColor];
    [self.targetChart setStrokeColor:PNBlue];
    [self.view addSubview:self.targetChart];
}

- (void)setupHistoryChart {
    self.historyChart = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - 210, SCREEN_WIDTH, 150)];
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
    self.historyChart.colorXaxisLabel = [UIColor colorWithHexString:@"#7a899b"];
    
    [self.view addSubview:self.historyChart];
    
    UILabel *weight87 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 4 - 20, CGRectGetHeight(self.view.bounds) - 90, 40, 30)];
    weight87.text = @"87kg";
    weight87.textColor = [UIColor colorWithHexString:@"#7a899b"];
    weight87.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:weight87];
}

#pragma - BEMSimpleLineGraphDataSource

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    if (graph == self.historyChart) {
        return 5;
    } else {
        return 0;
    }
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    NSArray *data = @[@89, @87, @86, @85, @86];
    return [data[index] doubleValue];
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    NSArray *data = @[@89, @87, @86, @85, @86];
    return [data[index] stringValue];
}

- (NSInteger)numberOfXAxisLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
