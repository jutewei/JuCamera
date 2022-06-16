//
//  SHFMDBSql+Update.h
//  PABase
//
//  Created by Juvid on 16/7/9.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JUBaseDatadb.h"

@interface JUBaseDatadb (update)
/**
 *  @author Juvid, 16-07-11 12:07:27
 *
 *  更新表中单条记录的所有值(推荐使用)
 *
 *  @param object      表对象
 *  @param whereKeys SET 的所有Key（数组或单个字符串Key）
 *
 *  @return 返回操作状态
 */
+(BOOL)juUpdateTable:(JuBaseDBModel *)object
           whereKeys:(id)whereKeys;
/**
 更新表

 @param object 对象
 @param whereKeys SET 的所有Key（数组或单个字符串Key）
 @param exceptKeys 不更新的属性
 @return 是否成功
 */
+(BOOL)juUpdateTable:(JuBaseDBModel *)object
           whereKeys:(id)whereKeys
          exceptKeys:(NSArray *)exceptKeys;
/**
 *  @author Juvid, 16-07-22 13:07:41
 *
 *  更新表
 *
 *  @param tableName 表名
 *  @param dicObject 需要更新的键值
 *  @param whereKeys   SET 的所有Key（数组或单个字符串Key
 *
 *  @return 返回操作状态
 */
+(BOOL)juUpdateTable:(NSString *)tableName
            withData:(NSDictionary *)dicObject
           whereKeys:(id)whereKeys;


+(BOOL)shUpdateTable:(NSString *)tableName
            withData:(NSDictionary *)dicObject
           whereData:(NSDictionary *)whereData;
/**
 *  @author Juvid, 16-07-11 12:07:22
 *
 *  更新表（批量更新，非主键）
 *
 *  @param table    表名
 *  @param dicSetObj set key 的值
 *
 *  @return 返回操作状态
 */
+(BOOL)juUpdateTable:(NSString *)table
           setKValue:(NSDictionary *)dicSetObj;
/**
 *  @author Juvid, 16-07-11 12:07:20
 *
 *  更新表（批量更新）
 *
 *  @param table      表名
 *  @param dicSetObj     set的key
 *  @param dicWhereObj   set key 的值
 *
 *  @return 返回操作状态
 */
+(BOOL)juUpdateTable:(NSString *)table
           setKValue:(NSDictionary *)dicSetObj
         whereKValue:(NSDictionary *)dicWhereObj;
/**
 *  @author Juvid, 16-07-11 12:07:16
 *
 *  更新表(非主键)
 *
 *  @param tableName 表名
 *  @param setSql    set SQL 键值 key='value'，……
 *
 *  @return 返回操作状态
 */
+(BOOL)juUpdateTable:(NSString *)tableName set:(NSString *)setSql;

/**
 *  @author Juvid, 16-07-11 12:07:14
 *
 *  更新表
 *
 *  @param tableName 表名
 *  @param whereSql  where SQL 键值 key='value' and……
 *
 *  @return 返回操作状态
 */
+(BOOL)juUpdateTable:(NSString *)tableName
                 set:(NSString *)setSql
               where:(NSString *)whereSql;
/**
 *  @author Juvid, 16-07-11 12:07:40
 *
 *  更新表
 *
 *  @param tableName 表名
 *  @param sqlStr    SQL语句
 *
 *  @return 返回操作状态
 */
+(BOOL)juUpdateTable:(NSString *)tableName withSql:(NSString *)sqlStr;

+(BOOL)juUpdateDBSQL:(NSString *)sqlStr;

@end
