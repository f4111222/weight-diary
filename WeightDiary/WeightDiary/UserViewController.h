//
//  UserViewController.h
//  WeightDiary
//
//  Created by 罗思成 on 16/2/10.
//
//

#import <UIKit/UIKit.h>
#import <MGSwipeTableCell.h>

@interface UserViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate>

@property (strong, nonatomic) UIView *header;
@property (strong, nonatomic) UILabel *height;
@property (strong, nonatomic) UILabel *targetWeight;
@property (strong, nonatomic) UILabel *gender;

@property (strong, nonatomic) NSMutableArray *historyData;
@property (strong, nonatomic) NSMutableArray *historyHeader;
@property (strong, nonatomic) UITableView *historyTable;

@end
