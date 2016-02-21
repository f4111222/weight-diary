//
//  HistoryTableCell.m
//  WeightDiary
//
//  Created by 罗思成 on 16/2/20.
//
//

#import "HistoryTableCell.h"

@implementation HistoryTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.date = [[UILabel alloc] initWithFrame:CGRectZero];
        self.weight = [[UILabel alloc] initWithFrame:CGRectZero];
        self.right = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        self.date.textAlignment = NSTextAlignmentLeft;
        self.weight.textAlignment = NSTextAlignmentRight;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.4) {
            self.date.font = [UIFont monospacedDigitSystemFontOfSize:18 weight:UIFontWeightUltraLight];
            self.weight.font = [UIFont monospacedDigitSystemFontOfSize:18 weight:UIFontWeightMedium];
        } else {
            self.date.font = [UIFont systemFontOfSize:18 weight:UIFontWeightLight];
            self.weight.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
        }
        
        [self.contentView addSubview:self.date];
        [self.contentView addSubview:self.weight];
        [self.contentView addSubview:self.right];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat topPadding = 4;
    CGFloat leftPadding = 15;
    CGFloat rightPadding = CGRectGetWidth(self.contentView.frame) - 5;
    CGFloat width = (CGRectGetWidth(self.contentView.frame) - leftPadding - 5 - 20) / 2;
    
    self.date.frame = CGRectMake(leftPadding, topPadding, width, 30);
    self.weight.frame = CGRectMake(rightPadding - width - 20, topPadding, width, 30);
    self.right.frame = CGRectMake(rightPadding - 20, topPadding + 5, 20, 20);
    
    self.right.image = [UIImage imageNamed:@"right@3x.png"];
}

@end
