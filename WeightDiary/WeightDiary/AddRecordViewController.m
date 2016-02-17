//
//  AddRecordViewController.m
//  WeightDiary
//
//  Created by 罗思成 on 16/2/16.
//
//

#import "AddRecordViewController.h"

@interface AddRecordViewController ()

@end

@implementation AddRecordViewController

#pragma - View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupDismissButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - Setup View

- (void)setupDismissButton {
    UIButton *dismiss = [[UIButton alloc] initWithFrame:CGRectMake(20, 30, 25, 25)];
    [dismiss setBackgroundImage:[UIImage imageNamed:@"left@3x.png"] forState:UIControlStateNormal];
    [dismiss addTarget:self action:@selector(actionDismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismiss];
}

#pragma - Button Action

- (void)actionDismiss {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.2;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
