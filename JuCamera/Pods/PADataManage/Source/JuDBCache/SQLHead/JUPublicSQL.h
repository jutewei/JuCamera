//
//  JUPublicSQL.h
//  PABase
//
//  Created by Juvid on 16/7/23.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JUPublicSQL : NSObject
/**建表语句*/
+(NSString *)juCreateTableSQL:(NSString *)className
                     withKeys:(NSArray *)arrKey
                   primaryKey:(NSString *)primaryKey;

/**添加表数据语句*/
+(NSString *)juInsertSql:(NSString *)tableName withSql:(NSString *)sqlStr;

/**删除表数据语句*/
+(NSString *)juDeleteSql:(NSString *)tableName withSql:(NSString *)sqlStr;

/**修改表数据语句*/
+(NSString *)juUpdateSql:(NSString *)tableName withSql:(NSString *)sqlStr;
/**添加字段*/
+(NSString *)juAlterSql:(NSString *)tableName withSql:(NSString *)sqlStr;
@end
