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

@property (strong, nonatomic) PNCircleChart *targetChart;
//@property (strong, nonatomic) PNBarChart *historyChart;
@property (strong, nonatomic) BEMSimpleLineGraphView *historyChart;

@end
