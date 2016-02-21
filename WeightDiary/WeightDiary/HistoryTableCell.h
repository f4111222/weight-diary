//
//  HistoryTableCell.h
//  WeightDiary
//
//  Created by 罗思成 on 16/2/20.
//
//

#import <UIKit/UIKit.h>
#import <MGSwipeTableCell.h>

@interface HistoryTableCell : MGSwipeTableCell

@property (strong, nonatomic) UILabel *date;
@property (strong, nonatomic) UILabel *weight;
@property (strong, nonatomic) UIImageView *right;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
