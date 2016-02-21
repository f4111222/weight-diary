//
//  InputViewController.h
//  WeightDiary
//
//  Created by 罗思成 on 16/2/12.
//
//

#import <UIKit/UIKit.h>
#import "SCAlertPicker.h"

@interface InputViewController : UIViewController <SCAlertPickerDelegte>

@property (strong, nonatomic) UILabel *gender;
@property (strong, nonatomic) UILabel *height;
@property (strong, nonatomic) UILabel *target;
@property (strong, nonatomic) UILabel *suggestion;

@property (strong, nonatomic) SCAlertPicker *genderPicker;
@property (strong, nonatomic) SCAlertPicker *heightPicker;
@property (strong, nonatomic) SCAlertPicker *targetPicker;

@property (nonatomic) BOOL allowTouchDismiss;

@end
