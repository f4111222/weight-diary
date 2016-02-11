//
//  SCTabBar.m
//  WeightDiary
//
//  Created by 罗思成 on 16/2/10.
//
//

#import "SCTabBar.h"
#import "UIColor+HexString.h"

@implementation SCTabBar

- (id)initWithFrame:(CGRect)frame {
    NSLog(@"SCTabBar: init");
    SCTabBar *tabBar = [super initWithFrame:frame];
    
    if (tabBar) {
        [tabBar.layer setBorderWidth:1];
        [tabBar.layer setBorderColor:[UIColor colorWithHexString:@"#eaeaea"].CGColor];
        [tabBar setClipsToBounds:YES];
    }
        
    return tabBar;
}

/**
 *  change tabbar height
 *
 *  @param size: original size
 *
 *  @return: new size with height 60
 */
- (CGSize)sizeThatFits:(CGSize)size {
    CGSize sizeThatFits = [super sizeThatFits:size];
    sizeThatFits.height = 60;
    
    return sizeThatFits;
}

@end
