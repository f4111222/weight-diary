//
//  SCAlertPicker.h
//  WeightDiary
//
//  Created by 罗思成 on 16/2/12.
//
//

#import <UIKit/UIKit.h>

@protocol SCAlertPickerDelegte;

@interface SCAlertPicker : UIView <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) id<SCAlertPickerDelegte> delegate;
@property (strong, nonatomic) UIPickerView *picker;
@property (strong, nonatomic) NSMutableArray *valueIndex;
@property (strong, nonatomic) NSArray *pickerData;
@property (strong, nonatomic) UIButton *submitButton;
@property (strong, nonatomic) UIWindow *alertWindow;

- (instancetype)initWithButtonTitle:(NSString *)buttonTitle
                         pickerData:(NSArray *)pickerData
                        pickerIndex:(NSArray *)pickerIndex
                           delegate:(id<SCAlertPickerDelegte>)delegate;

- (void)show;

@end

@protocol SCAlertPickerDelegte <NSObject>

- (void)SCAlertPicker:(SCAlertPicker *)alertPicker ClickWithValues:(NSArray *)values;

@end