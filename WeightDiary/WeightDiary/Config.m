//
//  Config.m
//  WeightDiary
//
//  Created by 罗思成 on 16/2/12.
//
//

#import "Config.h"
#import <FMDatabase.h>

@implementation Config

#pragma - User Infomation

+ (BOOL)isUserInfoStored {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BOOL isUserInfoStored = [userDefault boolForKey:@"UserInfoStored"];
    if (isUserInfoStored) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)setIsUserInfoStored:(BOOL)stored {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:stored forKey:@"UserInfoStored"];
    [userDefault synchronize];
}

+ (void)setUserGender:(NSString *)gender {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:gender forKey:@"UserGender"];
    [userDefault synchronize];
}

+ (NSString *)userGender {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userGender = [userDefault objectForKey:@"UserGender"];
    if (!userGender) {
        userGender = @"男";
    }
    return userGender;
}

+ (void)setUserHeight:(NSString *)height {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:height forKey:@"UserHeight"];
    [userDefault synchronize];
}

+ (NSString *)userHeight {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userHeight = [userDefault objectForKey:@"UserHeight"];
    if (!userHeight) {
        userHeight = @"170.0 cm";
    }
    return userHeight;
}

+ (double)userHeightValue {
    NSString *userHeight = [[self userHeight] stringByReplacingOccurrencesOfString:@"cm" withString:@""];
    userHeight = [userHeight stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [userHeight doubleValue];
}

+ (void)setUserTarget:(NSString *)target {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:target forKey:@"UserTarget"];
    [userDefault synchronize];
}

+ (NSString *)userTarget {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userTarget = [userDefault objectForKey:@"UserTarget"];
    if (!userTarget) {
        userTarget = @"60.0 kg";
    }
    return userTarget;
}

+ (double)userTargetValue {
    NSString *userTarget = [[self userTarget] stringByReplacingOccurrencesOfString:@"kg" withString:@""];
    userTarget = [userTarget stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [userTarget doubleValue];
}

#pragma - BMI Calculation

+ (CGFloat)getBMIWithHeight:(NSString *)height weight:(NSString *)weight {
    height = [height stringByReplacingOccurrencesOfString:@"cm" withString:@""];
    height = [height stringByReplacingOccurrencesOfString:@" " withString:@""];
    CGFloat heightValue = [height doubleValue] / 100;
    
    weight = [weight stringByReplacingOccurrencesOfString:@"kg" withString:@""];
    weight = [weight stringByReplacingOccurrencesOfString:@" " withString:@""];
    CGFloat weightValue = [weight doubleValue];
    
    return weightValue / (heightValue * heightValue);
}

+ (NSString *)getBMISuggestion:(NSString *)height {
    height = [height stringByReplacingOccurrencesOfString:@"cm" withString:@""];
    height = [height stringByReplacingOccurrencesOfString:@" " withString:@""];
    CGFloat heightValue = [height doubleValue] / 100;
    
    CGFloat low = heightValue * heightValue * 18.5;
    CGFloat high = heightValue * heightValue * 23.9;
    return [NSString stringWithFormat:@"%.1lfkg - %.1lfkg", low, high];
}

#pragma - Database work

+ (NSString *)databasePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths lastObject] stringByAppendingString:@"/weight.db"];
}

+ (void)createDatabase {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dbPath = [self databasePath];
    if (![fileManager fileExistsAtPath:dbPath]) {
        // create table 'Record'
        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
        if ([db open]) {
            NSString *sql = @"CREATE TABLE IF NOT EXISTS Record (weight DOUBLE NOT NULL, date STRING PRIMARY KEY NOT NULL)";
            BOOL res = [db executeUpdate:sql];
            if (!res) {
                NSLog(@"error when creating db table");
            } else {
                NSLog(@"succ to creating db table");
            }
            [db close];
        } else {
            NSLog(@"error when open db");
        }
    }
}

+ (void)addRecord:(double)weight date:(NSString *)date {
    FMDatabase *db = [FMDatabase databaseWithPath:[self databasePath]];
    if ([db open]) {
        // insert new record
        NSString *sql = @"REPLACE INTO Record (weight, date) VALUES (?, ?)";
        BOOL res = [db executeUpdate:sql, @(weight), date];
        if (!res) {
            NSLog(@"error to insert new record");
        } else {
            NSLog(@"success to insert new record");
        }
        [db close];
    }
    
}

+ (void)deleteRecordByDate:(NSString *)date {
    FMDatabase *db = [FMDatabase databaseWithPath:[self databasePath]];
    if ([db open]) {
        // delete record with specific date
        NSString *sql = @"DELETE FROM Record WHERE date = ?";
        BOOL res = [db executeUpdate:sql, date];
        if (!res) {
            NSLog(@"error to delete record");
        } else {
            NSLog(@"success to delete record");
        }
        [db close];
    }
}

+ (NSArray *)allRecord {
    FMDatabase *db = [FMDatabase databaseWithPath:[self databasePath]];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if ([db open]) {
        // query all records
        NSString *sql = @"SELECT * FROM Record ORDER BY date DESC";
        FMResultSet *res = [db executeQuery:sql];
        while ([res next]) {
            double weight = [res doubleForColumn:@"weight"];
            NSString *date = [res stringForColumn:@"date"];
            // add record when date format is correct
            if ([date containsString:@"-"] == YES) {
                [result addObject:@[date, @(weight)]];
            }
        }
        [db close];
    }
    return [result copy];
}

+ (NSArray *)latestRecordWithCount:(NSInteger)count {
    FMDatabase *db = [FMDatabase databaseWithPath:[self databasePath]];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if ([db open]) {
        // query all records
        NSString *sql = @"SELECT * FROM Record ORDER BY date DESC";
        FMResultSet *res = [db executeQuery:sql];
        while ([res next] && count > 0) {
            double weight = [res doubleForColumn:@"weight"];
            NSString *date = [res stringForColumn:@"date"];
            // add record when date format is correct
            if ([date containsString:@"-"] == YES) {
                [result addObject:@[date, @(weight)]];
                count--;
            }
        }
        [db close];
    }
    return [result copy];
}

+ (double)latestRecord {
    FMDatabase *db = [FMDatabase databaseWithPath:[self databasePath]];
    double weight = -1;
    if ([db open]) {
        // query all records
        NSString *sql = @"SELECT * FROM Record ORDER BY date DESC";
        FMResultSet *res = [db executeQuery:sql];
        if ([res next]) {
            weight = [res doubleForColumn:@"weight"];
        }
        [db close];
    }
    return weight;
}

+ (double)firstRecord {
    FMDatabase *db = [FMDatabase databaseWithPath:[self databasePath]];
    double weight = -1;
    if ([db open]) {
        // query all records
        NSString *sql = @"SELECT * FROM Record ORDER BY date ASC";
        FMResultSet *res = [db executeQuery:sql];
        if ([res next]) {
            weight = [res doubleForColumn:@"weight"];
        }
        [db close];
    }
    return weight;
}

#pragma - Image Work

+ (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
