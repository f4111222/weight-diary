//
//  TabBarController.m
//  WeightDiary
//
//  Created by 罗思成 on 16/2/10.
//
//

#import "TabBarController.h"
#import "DataViewController.h"
#import "UserViewController.h"

#import "UIColor+HexString.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"TabBar: MainView");
    DataViewController *dataView = [[DataViewController alloc] init];
    UserViewController *userView = [[UserViewController alloc] init];
    UIViewController *addRecordView = [[UIViewController alloc] init];
    
    // entrance for data interface
    UIImage *dataImage = [[UIImage imageNamed:@"data@3x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *dataSelectedImage = [[UIImage imageNamed:@"dataSelected@3x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *dataItem = [[UITabBarItem alloc] initWithTitle:@"" image:dataImage selectedImage:dataSelectedImage];
    [dataItem setTag:0];
    [dataItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
    
    // entrance for history interface
    UIImage *historyImage = [[UIImage imageNamed:@"history@3x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *historySelectedImage = [[UIImage imageNamed:@"historySelected@3x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *historyItem = [[UITabBarItem alloc] initWithTitle:@"" image:historyImage selectedImage:historySelectedImage];
    [historyItem setTag:1];
    [historyItem setImageInsets:UIEdgeInsetsMake(4, 0, -4, 0)];
    
    // entrance for addRecord interface
    UIImage *addRecordImage = [[UIImage imageNamed:@"addRecord@3x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *addRecordItem = [[UITabBarItem alloc] initWithTitle:@"" image:addRecordImage selectedImage:addRecordImage];
    [addRecordItem setTag:2];
    [addRecordItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
    
    // entrance for user interface
    UIImage *userImage = [[UIImage imageNamed:@"user@3x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *userSelectedImage = [[UIImage imageNamed:@"userSelected@3x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *userItem = [[UITabBarItem alloc] initWithTitle:@"" image:userImage selectedImage:userSelectedImage];
    [userItem setTag:3];
    [userItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
    
    // entrance for setting interface
    UIImage *settingImage = [[UIImage imageNamed:@"setting@3x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *settingSelectedImage = [[UIImage imageNamed:@"settingSelected@3x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *settingItem = [[UITabBarItem alloc] initWithTitle:@"" image:settingImage selectedImage:settingSelectedImage];
    [settingItem setTag:4];
    [settingItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];

    // set TabBar item for each view
    [dataView setTabBarItem:dataItem];
    [addRecordView setTabBarItem:addRecordItem];
    [userView setTabBarItem:userItem];
    
    // set TabBar border color
    [self.tabBar.layer setBorderWidth:1];
    [self.tabBar.layer setBorderColor:[UIColor colorWithHexString:@"#eaeaea"].CGColor];
    [self.tabBar setClipsToBounds:YES];
    
    [self setViewControllers:@[dataView, addRecordView, userView]];
    [self setSelectedIndex:0];
}

/**
 *  set TabBar height to 60
 */
- (void)viewWillLayoutSubviews {
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = 60;
    tabFrame.origin.y = CGRectGetHeight(self.view.frame) - 60;
    self.tabBar.frame = tabFrame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
