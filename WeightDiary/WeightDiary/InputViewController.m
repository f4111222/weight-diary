//
//  InputViewController.m
//  WeightDiary
//
//  Created by 罗思成 on 16/2/12.
//
//

#import "InputViewController.h"
#import "UIColor+HexString.h"

#import "Config.h"

@interface InputViewController ()

@end

@implementation InputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self setupLogo];
    [self setupGenderInput];
    [self setupHeightInput];
    [self setupTargetInput];
    [self setupSuggestion];
    [self setupSubmitButton];
    
    [self addObserver:self forKeyPath:@"height.text" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
    
    if (self.allowTouchDismiss) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
        [self.view addGestureRecognizer:tap];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeObserver:self forKeyPath:@"height.text"];
}

#pragma - Setup label and textfield for Input

- (void)setupLogo {
    CGFloat logoWidth = 100;
    CGFloat logoHeight = 100;
    CGFloat logoLeft = CGRectGetWidth(self.view.frame) / 2 - logoWidth / 2;
    CGFloat logoTop = 50;
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(logoLeft, logoTop, logoWidth, logoHeight)];
    [logo setImage:[UIImage imageNamed:@"logo@3x.png"]];
    [self.view addSubview:logo];
}

- (void)setupGenderInput {
    // setup position and size
    CGFloat genderTipLeft = 40;
    CGFloat genderTipTop = 100;
    CGFloat genderTipWidth = 40;
    CGFloat genderTipHeight = 30;
    
    CGFloat editGenderWidth = 20;
    CGFloat editGenderHeight = 20;
    CGFloat editGenderTop = genderTipTop + 5;
    CGFloat editGenderLeft = CGRectGetWidth(self.view.frame) - genderTipLeft - editGenderWidth;
    
    CGFloat genderWidth = 40;
    CGFloat genderHeight = 30;
    CGFloat genderTop = genderTipTop;
    CGFloat genderLeft = CGRectGetWidth(self.view.frame) - genderTipLeft - genderWidth - editGenderWidth;
    
    UILabel *genderTip = [[UILabel alloc] initWithFrame:CGRectMake(genderTipLeft, genderTipTop, genderTipWidth, genderTipHeight)];
    genderTip.text = @"性别";
    genderTip.font = [UIFont systemFontOfSize:20];
    genderTip.textColor = [UIColor colorWithHexString:@"#858e9b"];
    [self.view addSubview:genderTip];
    
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(genderTipLeft, genderTipTop + genderTipHeight + 5, CGRectGetWidth(self.view.frame) - genderTipLeft * 2, 2)];
    [line1 setBackgroundColor:[UIColor colorWithHexString:@"#f2f4f3"]];
    [self.view addSubview:line1];
    
    self.gender = [[UILabel alloc] initWithFrame:CGRectMake(genderLeft, genderTop, genderWidth, genderHeight)];
    self.gender.text = [Config userGender];
    self.gender.font = [UIFont boldSystemFontOfSize:20];
    self.gender.textColor = [UIColor colorWithHexString:@"#404d5f"];
    self.gender.textAlignment = NSTextAlignmentRight;
    [self.gender setUserInteractionEnabled:YES];
    [self.view addSubview:self.gender];
    
    UIButton *editGender = [[UIButton alloc] initWithFrame:CGRectMake(editGenderLeft, editGenderTop, editGenderWidth, editGenderHeight)];
    [editGender setImage:[UIImage imageNamed:@"right@3x.png"] forState:UIControlStateNormal];
    [editGender setImage:[UIImage imageNamed:@"right@3x.png"] forState:UIControlStateHighlighted];
    [editGender addTarget:self action:@selector(actionSelectGender) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editGender];
}

- (void)setupHeightInput {
    // setup position and size
    CGFloat heightTipLeft = 40;
    CGFloat heightTipTop = self.gender.frame.origin.y + 30 + 20;
    CGFloat heightTipWidth = 40;
    CGFloat heightTipHeight = 30;
    
    CGFloat editHeightWidth = 20;
    CGFloat editHeightHeight = 20;
    CGFloat editHeightTop = heightTipTop + 5;
    CGFloat editHeightLeft = CGRectGetWidth(self.view.frame) - heightTipLeft - editHeightWidth;
    
    CGFloat heightWidth = 150;
    CGFloat heightHeight = 30;
    CGFloat heightTop = heightTipTop;
    CGFloat heightLeft = CGRectGetWidth(self.view.frame) - heightTipLeft - heightWidth - editHeightWidth;
    
    UILabel *heightTip = [[UILabel alloc] initWithFrame:CGRectMake(heightTipLeft, heightTipTop, heightTipWidth, heightTipHeight)];
    heightTip.text = @"身高";
    heightTip.font = [UIFont systemFontOfSize:20];
    heightTip.textColor = [UIColor colorWithHexString:@"#858e9b"];
    [self.view addSubview:heightTip];
    
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(heightTipLeft, heightTipTop + heightTipHeight + 5, CGRectGetWidth(self.view.frame) - heightTipLeft * 2, 2)];
    [line1 setBackgroundColor:[UIColor colorWithHexString:@"#f2f4f3"]];
    [self.view addSubview:line1];
    
    self.height = [[UILabel alloc] initWithFrame:CGRectMake(heightLeft, heightTop, heightWidth, heightHeight)];
    self.height.text = [Config userHeight];
    self.height.font = [UIFont boldSystemFontOfSize:20];
    self.height.textColor = [UIColor colorWithHexString:@"#404d5f"];
    self.height.textAlignment = NSTextAlignmentRight;
    [self.height setUserInteractionEnabled:YES];
    [self.view addSubview:self.height];
    
    UIButton *editHeight = [[UIButton alloc] initWithFrame:CGRectMake(editHeightLeft, editHeightTop, editHeightWidth, editHeightHeight)];
    [editHeight setImage:[UIImage imageNamed:@"right@3x.png"] forState:UIControlStateNormal];
    [editHeight setImage:[UIImage imageNamed:@"right@3x.png"] forState:UIControlStateHighlighted];
    [editHeight addTarget:self action:@selector(actionSelectHeight) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editHeight];
}

- (void)setupTargetInput {
    // setup position and size
    CGFloat targetTipLeft = 40;
    CGFloat targetTipTop = self.height.frame.origin.y + 30 + 20;
    CGFloat targetTipWidth = 40;
    CGFloat targetTipHeight = 30;
    
    CGFloat editTargetWidth = 20;
    CGFloat editTargetHeight = 20;
    CGFloat editTargetTop = targetTipTop + 5;
    CGFloat editTargetLeft = CGRectGetWidth(self.view.frame) - targetTipLeft - editTargetWidth;
    
    CGFloat targetWidth = 150;
    CGFloat targetHeight = 30;
    CGFloat targetTop = targetTipTop;
    CGFloat targetLeft = CGRectGetWidth(self.view.frame) - targetTipLeft - targetWidth - editTargetWidth;
    
    UILabel *targetTip = [[UILabel alloc] initWithFrame:CGRectMake(targetTipLeft, targetTipTop, targetTipWidth, targetTipHeight)];
    targetTip.text = @"目标";
    targetTip.font = [UIFont systemFontOfSize:20];
    targetTip.textColor = [UIColor colorWithHexString:@"#858e9b"];
    [self.view addSubview:targetTip];
    
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(targetTipLeft, targetTipTop + targetTipHeight + 5, CGRectGetWidth(self.view.frame) - targetTipLeft * 2, 2)];
    [line1 setBackgroundColor:[UIColor colorWithHexString:@"#f2f4f3"]];
    [self.view addSubview:line1];
    
    self.target = [[UILabel alloc] initWithFrame:CGRectMake(targetLeft, targetTop, targetWidth, targetHeight)];
//    self.target.text = @"60.0 kg";
    self.target.text = [Config userTarget];
    self.target.font = [UIFont boldSystemFontOfSize:20];
    self.target.textColor = [UIColor colorWithHexString:@"#404d5f"];
    self.target.textAlignment = NSTextAlignmentRight;
    [self.target setUserInteractionEnabled:YES];
    [self.view addSubview:self.target];
    
    UIButton *editTarget = [[UIButton alloc] initWithFrame:CGRectMake(editTargetLeft, editTargetTop, editTargetWidth, editTargetHeight)];
    [editTarget setImage:[UIImage imageNamed:@"right@3x.png"] forState:UIControlStateNormal];
    [editTarget setImage:[UIImage imageNamed:@"right@3x.png"] forState:UIControlStateHighlighted];
    [editTarget addTarget:self action:@selector(actionSelectTarget) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editTarget];
}


- (void)setupSuggestion {
    // setup position and size
    CGFloat suggestionWidth = 300;
    CGFloat suggestionHeight = 30;
    CGFloat suggestionTop = self.target.frame.origin.y + 30 + 10;
    CGFloat suggestionLeft = CGRectGetWidth(self.view.frame) - 40 - suggestionWidth - 10;
    
    self.suggestion = [[UILabel alloc] initWithFrame:CGRectMake(suggestionLeft, suggestionTop, suggestionWidth, suggestionHeight)];
    self.suggestion.text = [NSString stringWithFormat:@"建议设置目标为: %@", [Config getBMISuggestion:self.height.text]];
    self.suggestion.font = [UIFont systemFontOfSize:12];
    self.suggestion.textAlignment = NSTextAlignmentRight;
    self.suggestion.textColor = [UIColor colorWithHexString:@"#858e9b"];
    [self.view addSubview:self.suggestion];
}

- (void)setupSubmitButton {
    CGFloat submitLeft = 40;
    CGFloat submitTop = self.suggestion.frame.origin.y + 40 + 10;
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

#pragma - Button Action

- (void)actionSubmit {
    [Config setUserGender:self.gender.text];
    [Config setUserHeight:self.height.text];
    [Config setUserTarget:self.target.text];
    
    if (self.allowTouchDismiss == NO) {
        [Config setIsUserInfoStored:YES];
    }
    
    [self actionDismiss];
}

- (void)actionDismiss {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)actionSelectGender {
    NSArray *pickerIndex;
    if ([self.gender.text isEqualToString:@"男"]) {
        pickerIndex = @[@0];
    } else {
        pickerIndex = @[@1];
    }
    self.genderPicker = [[SCAlertPicker alloc] initWithButtonTitle:@"确定" pickerData:@[@[@"男", @"女"]] pickerIndex:pickerIndex delegate:self];
    [self.genderPicker show];
}

- (void)actionSelectHeight {
    NSString *heightValue = [self.height.text stringByReplacingOccurrencesOfString:@" cm" withString:@""];
    NSRange point = [heightValue rangeOfString:@"."];
    NSString *heightValueNum = [heightValue substringToIndex:point.location];
    NSString *heightValueFraction = [heightValue substringFromIndex:point.location + point.length];
    NSMutableArray *pickerIndex = [[NSMutableArray alloc] initWithArray:@[@120, @0]];
    
    NSMutableArray *heightNum = [[NSMutableArray alloc] initWithCapacity:(250 - 50 + 1)];
    for (int num = 50; num <= 250; num++) {
        [heightNum addObject:[NSString stringWithFormat:@"%d", num]];
        if (num == [heightValueNum intValue]) {
            pickerIndex[0] = [NSNumber numberWithInt:num - 50];
        }
    }
    NSMutableArray *heightFraction = [[NSMutableArray alloc] initWithCapacity:10];
    for (int num = 0; num < 10; num++) {
        [heightFraction addObject:[NSString stringWithFormat:@".%d cm", num]];
        if (num == [heightValueFraction intValue]) {
            pickerIndex[1] = [NSNumber numberWithInt:num];
        }
    }

    self.heightPicker = [[SCAlertPicker alloc] initWithButtonTitle:@"确定" pickerData:@[heightNum, heightFraction] pickerIndex:pickerIndex delegate:self];
    [self.heightPicker show];
}

- (void)actionSelectTarget {
    NSString *targetValue = [self.target.text stringByReplacingOccurrencesOfString:@" kg" withString:@""];
    NSRange point = [targetValue rangeOfString:@"."];
    NSString *targetValueNum = [targetValue substringToIndex:point.location];
    NSString *targetValueFraction = [targetValue substringFromIndex:point.location + point.length];
    NSMutableArray *pickerIndex = [[NSMutableArray alloc] initWithArray:@[@30, @0]];
    
    NSMutableArray *targetNum = [[NSMutableArray alloc] initWithCapacity:(200 - 30 + 1)];
    for (int num = 30; num <= 200; num++) {
        [targetNum addObject:[NSString stringWithFormat:@"%d", num]];
        if (num == [targetValueNum intValue]) {
            pickerIndex[0] = [NSNumber numberWithInt:num - 30];
        }
    }
    NSMutableArray *targetFraction = [[NSMutableArray alloc] initWithCapacity:10];
    for (int num = 0; num < 10; num++) {
        [targetFraction addObject:[NSString stringWithFormat:@".%d kg", num]];
        if (num == [targetValueFraction intValue]) {
            pickerIndex[1] = [NSNumber numberWithInt:num];
        }
    }
    
    self.targetPicker = [[SCAlertPicker alloc] initWithButtonTitle:@"确定" pickerData:@[targetNum, targetFraction] pickerIndex:pickerIndex delegate:self];
    [self.targetPicker show];
}

#pragma - SCAlertPicker Delegate

- (void)SCAlertPicker:(SCAlertPicker *)alertPicker ClickWithValues:(NSArray *)values {
    if (alertPicker == self.genderPicker) {
        if ([values count] >= 1) {
            self.gender.text = values[0];
        }
    } else if (alertPicker == self.heightPicker) {
        if ([values count] >= 2) {
            self.height.text = [NSString stringWithFormat:@"%@%@", values[0], values[1]];
        }
    } else if (alertPicker == self.targetPicker) {
        if ([values count] >= 2) {
            self.target.text = [NSString stringWithFormat:@"%@%@", values[0], values[1]];
        }
    }
}

#pragma - Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"height.text"]) {
        id newHeight = [change objectForKey:NSKeyValueChangeNewKey];
        self.suggestion.text = [NSString stringWithFormat:@"建议设置目标为: %@", [Config getBMISuggestion:newHeight]];
    }
}

#pragma - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - Touch to Dismiss

- (void)actionTap:(UITapGestureRecognizer *)tap {
    CGPoint location = [tap locationInView:self.view];
    
    if (location.y > 80 && location.y < self.suggestion.frame.origin.y + 40 + 10 + 40 + 30) {
        return;
    } else {
        [self actionDismiss];
    }
}

#pragma - Touch to edit

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];

    if (touch.view == self.gender) {
        [self actionSelectGender];
    } else if (touch.view == self.height) {
        [self actionSelectHeight];
    } else if (touch.view == self.target) {
        [self actionSelectTarget];
    }
}

@end
