//
//  AddRecordViewController.h
//  WeightDiary
//
//  Created by 罗思成 on 16/2/16.
//
//

#import <UIKit/UIKit.h>
#import "SCAlertPicker.h"

@interface AddRecordViewController : UIViewController <SCAlertPickerDelegte>

@property (strong, nonatomic) UILabel *date;
@property (strong, nonatomic) UILabel *weight;

@property (strong, nonatomic) SCAlertPicker *datePicker;
@property (strong, nonatomic) SCAlertPicker *weightPicker;

@end
