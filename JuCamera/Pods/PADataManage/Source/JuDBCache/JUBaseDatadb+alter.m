//
//  JUBaseDatadb+alter.m
//  PABase
//
//  Created by Juvid on 16/8/8.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//
#import "JUBaseDatadb+alter.h"
#import "JUQueueDatadb.h"
#import "FMDatabaseAdditions.h"
@implementation JUBaseDatadb (alter)
/*
 *追加表字段
 */
+(BOOL)juAlterTable:(NSString *)tableName addKeys:(NSArray *)keys{
     __block BOOL flag = YES;

        [self juInDatabase:^(FMDatabase *db) {
            if ([db tableExists:tableName]) {
                for (NSString *strKey in keys) {
                    NSString * sql= [JUPublicSQL juAlterSql:tableName withSql:strKey];
                    if (![db executeUpdate:sql]) {
                        flag = NO;
                    }
                }
            }
        }];

    return flag;
}

/*
 *字段名是否存在
 */
+(BOOL)juColumnExists:(NSString *)columnName withTable:(NSString *)tableName{
    if (!columnName||!tableName) return NO;
    __block BOOL flag = YES;
    [self juInDatabase:^(FMDatabase *db) {
        flag=[db columnExists:columnName inTableWithName:tableName];
    }];
    if (!flag) {
        [self juAlterTable:tableName addKeys:@[columnName]];
    }
    return flag;
}
//select * from sqlite_master where name='tablename' and sql like '%fieldname%';
@end
