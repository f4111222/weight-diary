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
#import "HistoryTableCell.h"

@interface UserViewController ()

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self preferredStatusBarStyle];
    [self setupHeaderView];
    [self setupHistoryTable];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // animation
    if (self.header) {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.header.alpha = 0;
            self.historyTable.alpha = 0;
            self.header.alpha = 1;
            self.historyTable.alpha = 1;
        } completion:nil];
    }
    
    // set height value
    NSString *heightValue = [NSString stringWithFormat:@"  %.0lfcm", floor([Config userHeightValue])];
    NSMutableAttributedString *heightText = [[NSMutableAttributedString alloc] initWithString:heightValue];
    NSRange cmRange = [heightValue rangeOfString:@"cm"];
    [heightText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:24] range:NSMakeRange(0, 2)];
    [heightText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:38] range:NSMakeRange(2, cmRange.location - 2)];
    [heightText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:cmRange];
    [self.height setAttributedText:heightText];
    
    // set target weight value
    NSString *targetWeightValue = [NSString stringWithFormat:@"  %.0lfkg", floor([Config userTargetValue])];
    NSMutableAttributedString *targetWeightText = [[NSMutableAttributedString alloc] initWithString:targetWeightValue];
    NSRange kgRange = [targetWeightValue rangeOfString:@"kg"];
    [targetWeightText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:24] range:NSMakeRange(0, 2)];
    [targetWeightText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:38] range:NSMakeRange(2, kgRange.location - 2)];
    [targetWeightText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:kgRange];
    [self.targetWeight setAttributedText:targetWeightText];
    
    // set gender value
    [self.gender setText:[Config userGender]];
    
    // process data
    if (self.historyTable) {
        NSArray *allRecord = [Config allRecord];
        
        if (allRecord && [allRecord count] >= 1) {
            self.historyHeader = [[NSMutableArray alloc] init];
            self.historyData = [[NSMutableArray alloc] init];
            NSMutableArray *tmp = [[NSMutableArray alloc] init];
            
            NSString *year = [allRecord[0][0] substringWithRange:NSMakeRange(0, 4)];
            NSString *month = [allRecord[0][0] substringWithRange:NSMakeRange(5, 2)];
            NSString *day = [allRecord[0][0] substringWithRange:NSMakeRange(8, 2)];
            [self.historyHeader addObject:@[year, month, day]];
            
            for (id record in allRecord) {
                year = [record[0] substringWithRange:NSMakeRange(0, 4)];
                month = [record[0] substringWithRange:NSMakeRange(5, 2)];
                day = [record[0] substringWithRange:NSMakeRange(8, 2)];
                
                if (![year isEqualToString:[self.historyHeader lastObject][0]] || ![month isEqualToString:[self.historyHeader lastObject][1]]) {
                    [self.historyHeader addObject:@[year, month, day]];
                    [self.historyData addObject:[tmp mutableCopy]];
                    [tmp removeAllObjects];
                }
                
                [tmp addObject:@[year, month, day, record[1]]];
            }
            [self.historyData addObject:[tmp mutableCopy]];
        }
        
        [self.historyTable reloadData];
    }
}

/**
 *  setup headview for height, weight target and gender
 */
- (void)setupHeaderView {
    CGFloat headerHeight = 150;
//    CGFloat paddingLeft = 0;
    CGFloat columnWidth = CGRectGetWidth(self.view.bounds) / 3;
    self.header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), headerHeight)];
    [self.header setBackgroundColor:[UIColor colorWithHexString:@"#38a2f7"]];
    [self.view addSubview:self.header];
    
    // height tip and height
    UILabel *heightTip = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, columnWidth, 30)];
    [heightTip setText:@"身高"];
    [heightTip setFont:[UIFont systemFontOfSize:18]];
    [heightTip setTextColor:[UIColor colorWithHexString:@"#9ff0f1f2"]];
    [heightTip setTextAlignment:NSTextAlignmentCenter];
    [self.header addSubview:heightTip];
    
    self.height = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, columnWidth, 40)];
    [self.height setTextColor:[UIColor colorWithHexString:@"#f0f1f2"]];
    [self.height setTextAlignment:NSTextAlignmentCenter];
    [self.header addSubview:self.height];
    
    // taget tip and target
    UILabel *targetWeightTip = [[UILabel alloc] initWithFrame:CGRectMake(columnWidth, 40, columnWidth, 30)];
    [targetWeightTip setText:@"目标"];
    [targetWeightTip setFont:[UIFont systemFontOfSize:18]];
    [targetWeightTip setTextColor:[UIColor colorWithHexString:@"#9ff0f1f2"]];
    [targetWeightTip setTextAlignment:NSTextAlignmentCenter];
    [self.header addSubview:targetWeightTip];
    
    self.targetWeight = [[UILabel alloc] initWithFrame:CGRectMake(columnWidth, 75, columnWidth, 40)];
    [self.targetWeight setTextColor:[UIColor colorWithHexString:@"#f0f1f2"]];
    [self.targetWeight setTextAlignment:NSTextAlignmentCenter];
    [self.header addSubview:self.targetWeight];
    
    // gender tip and gender
    UILabel *genderTip = [[UILabel alloc] initWithFrame:CGRectMake(columnWidth * 2, 40, columnWidth, 30)];
    [genderTip setText:@"性别"];
    [genderTip setFont:[UIFont systemFontOfSize:18]];
    [genderTip setTextAlignment:NSTextAlignmentCenter];
    [genderTip setTextColor:[UIColor colorWithHexString:@"#9ff0f1f2"]];
    [self.header addSubview:genderTip];
    
    self.gender = [[UILabel alloc] initWithFrame:CGRectMake(columnWidth * 2, 75, columnWidth, 40)];
    [self.gender setTextColor:[UIColor colorWithHexString:@"#f0f1f2"]];
    [self.gender setFont:[UIFont boldSystemFontOfSize:34]];
    [self.gender setTextAlignment:NSTextAlignmentCenter];
    [self.header addSubview:self.gender];
    
    NSLog(@"%@", [Config databasePath]);
}

#pragma - setup history table

- (void)setupHistoryTable {
    CGFloat top = self.header.frame.size.height;
    self.historyTable = [[UITableView alloc] initWithFrame:CGRectMake(0, top, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 60 - top) style:UITableViewStylePlain];
    self.historyTable.dataSource = self;
    self.historyTable.delegate = self;
    self.historyTable.allowsSelection = NO;
    self.historyTable.backgroundColor = [UIColor clearColor];
    self.historyTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.historyTable];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.historyData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.historyData[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"historyTableCell";
    HistoryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[HistoryTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    __weak NSArray *tmp = self.historyData[indexPath.section][indexPath.row];
    
    cell.delegate = self;
    cell.date.text = [NSString stringWithFormat:@"%@/%@", tmp[1], tmp[2]];
    cell.weight.text = [NSString stringWithFormat:@"%.1lf kg", [tmp[3] doubleValue]];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.historyTable.frame.size.width, 30)];
    [headerView setBackgroundColor:[UIColor colorWithHexString:@"#eaeaea"]];
    
    int year = [self.historyHeader[section][0] intValue];
    int month = [self.historyHeader[section][1] intValue];
    
    UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(13, 2, 100, 26)];
    date.text = [NSString stringWithFormat:@"%d年%d月", year, month];
    date.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    date.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:date];
    
    if ([self.historyData[section] count] > 1) {
        double gapValue = [[[self.historyData[section] lastObject] lastObject] doubleValue] - [[[self.historyData[section] firstObject] lastObject] doubleValue];
        NSLog(@"%lf", gapValue);
        
        if (fabs(gapValue - 0) > 0.01) {
            UILabel *gap = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(headerView.frame) - 100 - 26, 2, 100, 26)];
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.4) {
                gap.font = [UIFont monospacedDigitSystemFontOfSize:16 weight:UIFontWeightSemibold];
            } else {
                gap.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
            }
            
            gap.textColor = [UIColor colorWithHexString:@"#d90000"];
            gap.textAlignment = NSTextAlignmentRight;
            
            if (gapValue > 0) {
                gap.text = [NSString stringWithFormat:@"-%.1lf kg", gapValue];
            } else {
                gap.text = [NSString stringWithFormat:@"+%.1lf kg", -gapValue];
            }
            
            [headerView addSubview:gap];
        }
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)actionDeleteRecord:(NSIndexPath *)indexPath {
    NSString *year = [self.historyData[indexPath.section] objectAtIndex:indexPath.row][0];
    NSString *month = [self.historyData[indexPath.section] objectAtIndex:indexPath.row][1];
    NSString *day = [self.historyData[indexPath.section] objectAtIndex:indexPath.row][2];
    
    [Config deleteRecordByDate:[NSString stringWithFormat:@"%@-%@-%@", year, month, day]];
    
    [self.historyData[indexPath.section] removeObjectAtIndex:indexPath.row];
    if ([self.historyData[indexPath.section] count] == 0) {
        [self.historyData removeObjectAtIndex:indexPath.section];
        [self.historyTable deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.historyTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self.historyTable reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma - Swipe Delegate

- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell canSwipe:(MGSwipeDirection)direction fromPoint:(CGPoint)point {
    return YES;
}

- (NSArray *)swipeTableCell:(MGSwipeTableCell *)cell swipeButtonsForDirection:(MGSwipeDirection)direction swipeSettings:(MGSwipeSettings *)swipeSettings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings {
    swipeSettings.transition = MGSwipeTransitionBorder;
    expansionSettings.buttonIndex = 0;
    
    if (direction == MGSwipeDirectionRightToLeft) {
        expansionSettings.fillOnTrigger = YES;
        expansionSettings.threshold = 1.1;
        
        __weak UserViewController *weakSelf = self;
        MGSwipeButton *delete = [MGSwipeButton buttonWithTitle:@"删除" backgroundColor:[UIColor colorWithHexString:@"#ff3b30"] padding:15 callback:^BOOL(MGSwipeTableCell *sender) {
            NSIndexPath *indexPath = [weakSelf.historyTable indexPathForCell:sender];
            [weakSelf actionDeleteRecord:indexPath];
            return NO;
        }];
        return @[delete];
    } else {
        return nil;
    }
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
