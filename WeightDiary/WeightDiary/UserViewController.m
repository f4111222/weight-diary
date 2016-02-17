//
//  UserViewController.m
//  WeightDiary
//
//  Created by 罗思成 on 16/2/10.
//
//

#import "UserViewController.h"
#import "UIColor+HexString.h"

#import "Config.h"

@interface UserViewController ()

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self preferredStatusBarStyle];
    [self setupHeaderView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.header) {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.header.alpha = 0;
            self.header.alpha = 1;
        } completion:nil];
    }
}

/**
 *  setup headview for height, weight target and gender
 */
- (void)setupHeaderView {
    CGFloat headerHeight = 200;
//    CGFloat paddingLeft = 0;
    CGFloat columnWidth = CGRectGetWidth(self.view.bounds) / 3;
    self.header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), headerHeight)];
    [self.header setBackgroundColor:[UIColor colorWithHexString:@"#38a2f7"]];
    [self.view addSubview:self.header];
    
    UILabel *heightTip = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, columnWidth, 30)];
    [heightTip setText:@"身高"];
    [heightTip setFont:[UIFont systemFontOfSize:18]];
    [heightTip setTextColor:[UIColor colorWithHexString:@"#9ff0f1f2"]];
    [heightTip setTextAlignment:NSTextAlignmentCenter];
    [self.header addSubview:heightTip];
    
    UILabel *height = [[UILabel alloc] initWithFrame:CGRectMake(0, 95, columnWidth, 40)];
    
    NSString *heightValue = [NSString stringWithFormat:@"  %.0lfcm", floor([Config userHeightValue])];
    NSMutableAttributedString *heightText = [[NSMutableAttributedString alloc] initWithString:heightValue];
    NSRange cmRange = [heightValue rangeOfString:@"cm"];
    [heightText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:24] range:NSMakeRange(0, 2)];
    [heightText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:38] range:NSMakeRange(2, cmRange.location - 2)];
    [heightText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:cmRange];
    
    [height setAttributedText:heightText];
    [height setTextColor:[UIColor colorWithHexString:@"#f0f1f2"]];
    [height setTextAlignment:NSTextAlignmentCenter];
    [self.header addSubview:height];
    
    UILabel *targetWeightTip = [[UILabel alloc] initWithFrame:CGRectMake(columnWidth, 60, columnWidth, 30)];
    [targetWeightTip setText:@"目标"];
    [targetWeightTip setFont:[UIFont systemFontOfSize:18]];
    [targetWeightTip setTextColor:[UIColor colorWithHexString:@"#9ff0f1f2"]];
    [targetWeightTip setTextAlignment:NSTextAlignmentCenter];
    [self.header addSubview:targetWeightTip];
    
    UILabel *targetWeight = [[UILabel alloc] initWithFrame:CGRectMake(columnWidth, 95, columnWidth, 40)];
    
    NSString *targetWeightValue = [NSString stringWithFormat:@"  %.0lfkg", floor([Config userTargetValue])];
    NSMutableAttributedString *targetWeightText = [[NSMutableAttributedString alloc] initWithString:targetWeightValue];
    NSRange kgRange = [targetWeightValue rangeOfString:@"kg"];
    [targetWeightText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:24] range:NSMakeRange(0, 2)];
    [targetWeightText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:38] range:NSMakeRange(2, kgRange.location - 2)];
    [targetWeightText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:kgRange];
    
    [targetWeight setAttributedText:targetWeightText];
    [targetWeight setTextColor:[UIColor colorWithHexString:@"#f0f1f2"]];
    [targetWeight setTextAlignment:NSTextAlignmentCenter];
    [self.header addSubview:targetWeight];
    
    UILabel *genderTip = [[UILabel alloc] initWithFrame:CGRectMake(columnWidth * 2, 60, columnWidth, 30)];
    [genderTip setText:@"性别"];
    [genderTip setFont:[UIFont systemFontOfSize:18]];
    [genderTip setTextAlignment:NSTextAlignmentCenter];
    [genderTip setTextColor:[UIColor colorWithHexString:@"#9ff0f1f2"]];
    [self.header addSubview:genderTip];
    
    UILabel *gender = [[UILabel alloc] initWithFrame:CGRectMake(columnWidth * 2, 95, columnWidth, 40)];
    [gender setText:[Config userGender]];
    [gender setTextColor:[UIColor colorWithHexString:@"#f0f1f2"]];
    [gender setFont:[UIFont boldSystemFontOfSize:34]];
    [gender setTextAlignment:NSTextAlignmentCenter];
    [self.header addSubview:gender];
    
    NSLog(@"%@", [Config databasePath]);
}

#pragma - Status Bar Style

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
