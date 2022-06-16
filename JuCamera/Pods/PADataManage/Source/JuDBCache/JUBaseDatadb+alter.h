//
//  JUBaseDatadb+alter.h
//  PABase
//
//  Created by Juvid on 16/8/8.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JUBaseDatadb.h"

@interface JUBaseDatadb (alter)

/**
 添加表字段

 @param tableName 表名
 @param keys      字段集合

 @return 成功失败
 */
+(BOOL)juAlterTable:(NSString *)tableName addKeys:(NSArray *)keys;

/**
 判断表字段是否存在

 @param columnName      字段名
 @param tableName       表名

 @return 成功失败
 */
+(BOOL)juColumnExists:(NSString *)columnName withTable:(NSString *)tableName;
@end
