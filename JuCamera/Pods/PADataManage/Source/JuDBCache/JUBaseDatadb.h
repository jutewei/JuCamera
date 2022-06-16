//
//  JUBaseDatadb.h
//  PABase
//
//  Created by Juvid on 15/4/21.
//  Copyright (c) 2015年 Juvid(zhutianwei). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "JUPublicSQL.h"
#import "JuBaseDBModel.h"
@interface JUBaseDatadb : NSObject
/**创建数据库*/
+(FMDatabase *)juBasedb;

/**创建表SQL*/
+(BOOL)juCreateTable:(NSString *)className
            withKeys:(NSArray *)arrKey
          primaryKey:(NSString *)primaryKey;

//删除表
+ (BOOL)juDropTable:(NSString *)className;

//判断表是否存在
+ (BOOL)hasTable:(NSString *)tableName;

//普通数据库操作方法
+ (void)juInDatabase:(__attribute__((noescape)) void (^)(FMDatabase *db))block;

//带事务方法数据库操作方法
+ (void)juInTransaction:(__attribute__((noescape)) void (^)(FMDatabase *db, BOOL *rollback))block;

@end
//ALTER TABLE `table1` ADD `AAAA` VARCHAR( 10 ) NOT NULL ;
