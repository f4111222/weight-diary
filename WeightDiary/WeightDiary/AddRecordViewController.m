//
//  AddRecordViewController.m
//  WeightDiary
//
//  Created by 罗思成 on 16/2/16.
//
//

#import "AddRecordViewController.h"
#import "UIColor+HexString.h"
#import "Config.h"

@interface AddRecordViewController ()

@end

@implementation AddRecordViewController

#pragma - View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupDateInput];
    [self setupWeightInput];
    [self setupSubmitButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - Setup View

- (void)setupDismissButton {
    UIButton *dismiss = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 32, 32)];
    [dismiss setBackgroundImage:[UIImage imageNamed:@"left@3x.png"] forState:UIControlStateNormal];
    [dismiss addTarget:self action:@selector(actionDismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismiss];
}

- (void)actionDismiss {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)setupDateInput {
    // setup position and size
    CGFloat dateTipLeft = 40;
    CGFloat dateTipTop = 100;
    CGFloat dateTipWidth = 40;
    CGFloat dateTipHeight = 30;
    
    CGFloat editDateWidth = 20;
    CGFloat editDateHeight = 20;
    CGFloat editDateTop = dateTipTop + 5;
    CGFloat editDateLeft = CGRectGetWidth(self.view.frame) - dateTipLeft - editDateWidth;
    
    CGFloat dateWidth = 150;
    CGFloat dateHeight = 30;
    CGFloat dateTop = dateTipTop;
    CGFloat dateLeft = CGRectGetWidth(self.view.frame) - dateTipLeft - dateWidth - editDateWidth;
    
    UILabel *dateTip = [[UILabel alloc] initWithFrame:CGRectMake(dateTipLeft, dateTipTop, dateTipWidth, dateTipHeight)];
    dateTip.text = @"日期";
    dateTip.font = [UIFont systemFontOfSize:20];
    dateTip.textColor = [UIColor colorWithHexString:@"#858e9b"];
    [self.view addSubview:dateTip];
    
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(dateTipLeft, dateTipTop + dateTipHeight + 5, CGRectGetWidth(self.view.frame) - dateTipLeft * 2, 2)];
    [line1 setBackgroundColor:[UIColor colorWithHexString:@"#f2f4f3"]];
    [self.view addSubview:line1];
    
    self.date = [[UILabel alloc] initWithFrame:CGRectMake(dateLeft, dateTop, dateWidth, dateHeight)];
    //    self.gender.text = @"男";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.date.text = [dateFormatter stringFromDate:[NSDate date]];
    self.date.font = [UIFont boldSystemFontOfSize:20];
    self.date.textColor = [UIColor colorWithHexString:@"#404d5f"];
    self.date.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.date];
    
    UIButton *editDate = [[UIButton alloc] initWithFrame:CGRectMake(editDateLeft, editDateTop, editDateWidth, editDateHeight)];
    [editDate setImage:[UIImage imageNamed:@"right@3x.png"] forState:UIControlStateNormal];
    [editDate setImage:[UIImage imageNamed:@"right@3x.png"] forState:UIControlStateHighlighted];
    [editDate addTarget:self action:@selector(actionSelectDate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editDate];
}

- (void)actionSelectDate {
    self.datePicker = [[SCAlertPicker alloc] initWithButtonTitle:@"确定" datePickerMode:UIDatePickerModeDate delegate:self];
    [self.datePicker show];
}

- (void)setupWeightInput {
    // setup position and size
    CGFloat weightTipLeft = 40;
    CGFloat weightTipTop = self.date.frame.origin.y + 30 + 20;
    CGFloat weightTipWidth = 40;
    CGFloat weightTipHeight = 30;
    
    CGFloat editWeightWidth = 20;
    CGFloat editWeightHeight = 20;
    CGFloat editWeightTop = weightTipTop + 5;
    CGFloat editWeightLeft = CGRectGetWidth(self.view.frame) - weightTipLeft - editWeightWidth;
    
    CGFloat weightWidth = 150;
    CGFloat weightHeight = 30;
    CGFloat weightTop = weightTipTop;
    CGFloat weightLeft = CGRectGetWidth(self.view.frame) - weightTipLeft - weightWidth - editWeightWidth;
    
    UILabel *weightTip = [[UILabel alloc] initWithFrame:CGRectMake(weightTipLeft, weightTipTop, weightTipWidth, weightTipHeight)];
    weightTip.text = @"体重";
    weightTip.font = [UIFont systemFontOfSize:20];
    weightTip.textColor = [UIColor colorWithHexString:@"#858e9b"];
    [self.view addSubview:weightTip];
    
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(weightTipLeft, weightTipTop + weightTipHeight + 5, CGRectGetWidth(self.view.frame) - weightTipLeft * 2, 2)];
    [line1 setBackgroundColor:[UIColor colorWithHexString:@"#f2f4f3"]];
    [self.view addSubview:line1];
    
    self.weight = [[UILabel alloc] initWithFrame:CGRectMake(weightLeft, weightTop, weightWidth, weightHeight)];

    double currentWeight = [Config latestRecord];
    if (currentWeight < 0) {
        currentWeight = 60;
    }
    
    self.weight.text = [NSString stringWithFormat:@"%.1lf kg", currentWeight];
    self.weight.font = [UIFont boldSystemFontOfSize:20];
    self.weight.textColor = [UIColor colorWithHexString:@"#404d5f"];
    self.weight.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.weight];
    
    UIButton *editWeight = [[UIButton alloc] initWithFrame:CGRectMake(editWeightLeft, editWeightTop, editWeightWidth, editWeightHeight)];
    [editWeight setImage:[UIImage imageNamed:@"right@3x.png"] forState:UIControlStateNormal];
    [editWeight setImage:[UIImage imageNamed:@"right@3x.png"] forState:UIControlStateHighlighted];
    [editWeight addTarget:self action:@selector(actionSelectWeight) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editWeight];
}

- (void)actionSelectWeight {
    NSString *weightValue = [self.weight.text stringByReplacingOccurrencesOfString:@" kg" withString:@""];
    NSRange point = [weightValue rangeOfString:@"."];
    NSString *weightValueNum = [weightValue substringToIndex:point.location];
    NSString *weightValueFraction = [weightValue substringFromIndex:point.location + point.length];
    NSMutableArray *pickerIndex = [[NSMutableArray alloc] initWithArray:@[@30, @0]];
    
    NSMutableArray *weightNum = [[NSMutableArray alloc] initWithCapacity:(200 - 30 + 1)];
    for (int num = 30; num <= 200; num++) {
        [weightNum addObject:[NSString stringWithFormat:@"%d", num]];
        if (num == [weightValueNum intValue]) {
            pickerIndex[0] = [NSNumber numberWithInt:num - 30];
        }
    }
    NSMutableArray *weightFraction = [[NSMutableArray alloc] initWithCapacity:10];
    for (int num = 0; num < 10; num++) {
        [weightFraction addObject:[NSString stringWithFormat:@".%d kg", num]];
        if (num == [weightValueFraction intValue]) {
            pickerIndex[1] = [NSNumber numberWithInt:num];
        }
    }
    
    self.weightPicker = [[SCAlertPicker alloc] initWithButtonTitle:@"确定" pickerData:@[weightNum, weightFraction] pickerIndex:pickerIndex delegate:self];
    [self.weightPicker show];
}

- (void)setupSubmitButton {
    CGFloat submitLeft = 40;
    CGFloat submitTop = self.weight.frame.origin.y + 40 + 30;
    CGFloat submitWidth = CGRectGetWidth(self.view.frame) - submitLeft * 2;
    CGFloat submitHeight = 40;
    
    UIButton *submit = [[UIButton alloc] initWithFrame:CGRectMake(submitLeft, submitTop, submitWidth, submitHeight)];
    [submit setTitle:@"确定" forState:UIControlStateNormal];
    [submit setBackgroundImage:[Config imageFromColor:[UIColor colorWithHexString:@"#428bca"]] forState:UIControlStateNormal];
    [submit setBackgroundImage:[Config imageFromColor:[UIColor colorWithHexString:@"#7f428bca"]] forState:UIControlStateHighlighted];
    submit.layer.cornerRadius = 3;
    submit.clipsToBounds = YES;
    [submit addTarget:self action:@selector(actionSubmit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submit];
}

- (void)actionSubmit {
    double weightValue = [[self.weight.text stringByReplacingOccurrencesOfString:@" kg" withString:@""] doubleValue];
    [Config addRecord:weightValue date:self.date.text];
    [self actionDismiss];
}

#pragma - Touch to dissmiss

- (void)actionTap:(UITapGestureRecognizer *)tap {
    CGPoint location = [tap locationInView:self.view];
    
    if (location.x > 40 && location.x < CGRectGetWidth(self.view.frame) - 40
        && location.y > 100 && location.y < 300) {
        return;
    } else {
        [self actionDismiss];
    }
}

#pragma - SCAlertPickerDelegate

- (void)SCAlertPicker:(SCAlertPicker *)alertPicker ClickWithDate:(NSDate *)date {
    if (alertPicker == self.datePicker) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        self.date.text = [dateFormatter stringFromDate:date];
    }
}

- (void)SCAlertPicker:(SCAlertPicker *)alertPicker ClickWithValues:(NSArray *)values {
    if (alertPicker == self.weightPicker) {
        if ([values count] >= 2) {
            NSString *weightString = [NSString stringWithFormat:@"%@%@", values[0], values[1]];
            self.weight.text = weightString;
        }
    }
}

@end
