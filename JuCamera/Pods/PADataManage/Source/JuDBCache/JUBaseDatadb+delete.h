//
//  JUBaseDatadb+delete.h
//  PABase
//
//  Created by Juvid on 16/7/11.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JUBaseDatadb.h"

@interface JUBaseDatadb (Delete)
/**
 *  @author Juvid, 16-07-11 15:07:27
 *
 *  删除表数据（推荐使用，对象属性 值为nil或为空不加人where条件）
 *
 *  @param object 表对象
 *
 *  @return 操作状态
 */
+(BOOL)juDeteleTabData:(JuBaseDBModel *)object;
/**
 *  @author Juvid, 16-07-22 13:07:19
 *
 *  删除表数据（推荐使用，对象属性 值为nil或为空,不加人where条件）
 *
 *  @param dicObject 要删除的关键键值
 *  @param tableName 表名
 *
 *  @return 操作状态
 */
//+(BOOL)shDeteleTabData:(NSDictionary *)dicObject table:(NSString *)tableName;
//删除表数据
/**
 *  @author Juvid, 16-07-11 15:07:58
 *
 *  删除表数据
 *
 *  @param className 表名
 *  @param dKey      指定key
 *  @param dValue    指定key 值
 *
 *  @return 操作状态
 */

+(BOOL)juDeteleTabData:(NSString *)className delKey:(NSString *)dKey delValue:(NSString *)dValue;
/**
 *  @author Juvid, 16-07-11 15:07:31
 *
 *  删除表数据
 *
 *  @param className 表名
 *  @param strWhere  key=’value‘，……
 *
 *  @return 操作状态
 */
+(BOOL)juDeteleTabData:(NSString *)className whereStr:(NSString *)strWhere;
/**
 *  @author Juvid, 16-07-11 15:07:25
 *
 *  删除表数据
 *
 *  @param tableName 表名
 *  @param whereDic  键值对
 *
 *  @return 操作状态
 */
+(BOOL)juDeteleTabData:(NSString *)tableName whereDic:(NSDictionary *)whereDic;
/**
 *  @author Juvid, 16-07-11 15:07:01
 *
 *  删除表数据
 *
 *  @param tableName 表名
 *  @param sqlStr    sql语句
 *
 *  @return 操作状态
 */
+(BOOL)juDeleteTable:(NSString *)tableName withSql:(NSString *)sqlStr;

/**
 *  @author Juvid, 16-07-11 15:07:24
 *
 *  清空表数据
 *
 *  @param tableName 表名
 *
 *  @return 操作状态
 */
+(BOOL)juCleanAllData:(NSString *)tableName;

+(BOOL)juDeleteDBSQL:(NSString *)sqlStr;

@end
