//
//  JUSQLQueuedb.m
//  PABase
//
//  Created by Juvid on 16/7/22.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JUQueueDatadb.h"
#import "JuFileManager.h"
//#import "JuSharedInstance.h"

@implementation JUQueueDatadb

+ (instancetype)sharedClient {
    static JUQueueDatadb *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc]init];
    });
    return _sharedClient;
}

-(void)setJu_dbName:(NSString *)ju_dbName{
    if (![_ju_dbName isEqual:ju_dbName]) {
        [self juDeallocDB];
        _ju_dbName=ju_dbName;
        [self juSetQueueDBPath];
    }
}

-(void)juSetQueueDBPath{
    if(_ju_dbName.length>0&&!_ju_dbQueue){
        NSString *newPath =[JuFileManager juGetUserPath:@"db" fileName:[NSString stringWithFormat:@"%@.db",self.ju_dbName]];
        [self juSetQueueDBPath:newPath];
    }
}

-(void)juSetQueueDBPath:(NSString *)path{
    if (!_ju_dbQueue) {
        NSLog(@"沙盒路径：%@",path);
        _ju_dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
        _ju_dicDBTable=[NSMutableDictionary dictionary];
    }
}

+ (void)juInDatabase:(__attribute__((noescape)) void (^)(FMDatabase *db))block{
    [[self client].ju_dbQueue inDatabase:block];
}

+ (void)juInTransaction:(__attribute__((noescape)) void (^)(FMDatabase *db, BOOL *rollback))block {
    [[self client].ju_dbQueue inTransaction:block];
}

+ (void)juCreatSuccess:(NSString *)tableName{
    [[self client].ju_dicDBTable setValue:@(1) forKey:tableName];
}

+(BOOL)hasTable:(NSString *)tableName{
    return  ([self client].ju_dicDBTable[tableName]||[super hasTable:tableName]);
}

/**摧毁单例，保证一个用户一个数据库*/
+(void)juDeallocDB{
    [[self client]juDeallocDB];
}

+(JUQueueDatadb *)client{
    return [self sharedClient];
}

-(void)juDeallocDB{
    [_ju_dbQueue close];
    _ju_dbQueue=nil;
    _ju_dicDBTable=nil;
    _ju_dbName=nil;
}

@end
