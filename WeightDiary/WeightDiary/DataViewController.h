//
//  DataViewController.h
//  WeightDiary
//
//  Created by 罗思成 on 16/2/10.
//
//

#import <UIKit/UIKit.h>

// chart view
#import "PNChart.h"
#import "BEMSimpleLineGraphView.h"

@interface DataViewController : UITabBarController <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@property (strong, nonatomic) NSArray *historyData;

@property (strong, nonatomic) PNCircleChart *targetChart;
@property (strong, nonatomic) BEMSimpleLineGraphView *historyChart;

// drop label, display weights already drop
@property (strong, nonatomic) UILabel *drop;

// labels for displaying data
@property (strong, nonatomic) UILabel *beginWeight;
@property (strong, nonatomic) UILabel *targetWeight;
@property (strong, nonatomic) UILabel *currentWeight;
@property (strong, nonatomic) UILabel *bmi;

@end
