//
//  JUBaseDatadb.m
//  PABase
//
//  Created by Juvid on 15/4/21.
//  Copyright (c) 2015年 Juvid(zhutianwei). All rights reserved.
//

#import "JUBaseDatadb.h"
#import <objc/message.h>
#import <objc/runtime.h>
//#define FriendsList @"Friend_List"
//#define ChatRecord  @"Chat_Record"
@implementation JUBaseDatadb

+(FMDatabase *)juBasedb{
    static FMDatabase *ju_db=nil;
    if (!ju_db) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        NSString *dbPath =[documentDirectory stringByAppendingPathComponent:@"PAUser.db"];
//        LogHint(@"沙盒路径%@",dbPath);
        ju_db = [FMDatabase databaseWithPath:dbPath] ;
    }

    if (![ju_db open]) {
        [ju_db close];
//        LogError(@"Could not open db.");
    }
    return ju_db;
}

+ (void)juInDatabase:(__attribute__((noescape)) void (^)(FMDatabase *db))block{
    if (block) {
        block([JUBaseDatadb juBasedb]);
    }
}

+ (void)juInTransaction:(__attribute__((noescape)) void (^)(FMDatabase *db, BOOL *rollback))block {
    FMDatabase *db=[JUBaseDatadb juBasedb];
    [db beginTransaction];
    BOOL shouldRollback = NO;
    if (block) {
        block(db,&shouldRollback);
    }
    if (shouldRollback) {
        [db rollback];
    }
    else {
        [db commit];
    }
}
+(BOOL)hasTable:(NSString *)tableName{
    return [self isTableOK:tableName];;
}
+ (void)juCreatSuccess:(NSString *)tableName{}
//判定是否存在表明
+(BOOL)isTableOK:(NSString *)tableName{
    __block BOOL flag = NO;
    [self juInDatabase:^(FMDatabase *db) {
        [db open];
        FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
        while ([rs next]){
            // just print out what we've got in a number of formats.
            NSInteger count = [rs intForColumn:@"count"];
            if (0 == count){
//                LogWarm(@"表不存在 %@",tableName);
                flag= NO;
            }
            else{
//                LogWarm(@"表存在 %@",tableName);
                [self juCreatSuccess:tableName];
                flag= YES;
            }
        }
    }];
    return flag;
}

+(BOOL)juCreateTable:(NSString *)className withKeys:(NSArray *)arrKey primaryKey:(NSString *)primaryKey{

    if ([self hasTable:className])  return YES;

    __block BOOL flag = NO;
    [self juInDatabase:^(FMDatabase *db) {
        [db open];
        NSString * creatSql=[JUPublicSQL juCreateTableSQL:className withKeys:arrKey primaryKey:primaryKey];
        if ([db executeUpdate:creatSql]) {
//            LogWarm(@"创建表成功%@",creatSql);
            [self juCreatSuccess:className];
//         [[JUSQLQueuedb sharedClient].ju_dicDBTable setValue:@(1) forKey:className];
            flag = YES;
        }else{
//            LogError(@"创建表失败%@",creatSql);
            flag = NO;
        }
    }];
    return flag;
}
//删除表
+(BOOL)juDropTable:(NSString *)className{
    __block BOOL flag = NO;
    [self juInDatabase:^(FMDatabase *db) {
        [db open];
        NSString *stringSql=[NSString stringWithFormat:@"DROP TABLE %@",className];
        if ([db executeUpdate:stringSql]) {
//            LogWarm(@"删除表成功成功%@",className);
            flag = YES;
        }
        else{
//            LogError(@"删除表成功失败%@",className);
            flag = NO;
        }
    }];
    return flag;
}
@end
