//
//  Config.h
//  WeightDiary
//
//  Created by 罗思成 on 16/2/12.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Config : NSObject

+ (void)setIsUserInfoStored:(BOOL)stored;
+ (BOOL)isUserInfoStored;

+ (void)setUserGender:(NSString *)gender;
+ (NSString *)userGender;

+ (void)setUserHeight:(NSString *)height;
+ (NSString *)userHeight;
+ (double)userHeightValue;

+ (void)setUserTarget:(NSString *)target;
+ (NSString *)userTarget;
+ (double)userTargetValue;

+ (CGFloat)getBMIWithHeight:(NSString *)height weight:(NSString *)weight;
+ (NSString *)getBMISuggestion:(NSString *)height;

+ (NSString *)databasePath;
+ (void)createDatabase;
+ (void)addRecord:(double)weight date:(NSString *)date;
+ (void)deleteRecordByDate:(NSString *)date;
+ (NSArray *)allRecord;
+ (NSArray *)latestRecordWithCount:(NSInteger)count;
+ (double)latestRecord;
+ (double)firstRecord;

+ (UIImage *)imageFromColor:(UIColor *)color;

@end
