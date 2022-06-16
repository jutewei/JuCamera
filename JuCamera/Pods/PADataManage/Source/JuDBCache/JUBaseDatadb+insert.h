//
//  SHFMDBSql+insert.h
//  PABase
//
//  Created by Juvid on 16/7/9.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JUBaseDatadb.h"

@interface JUBaseDatadb (insert)
//插入表数据
//+(BOOL)insertTabData:(id)data PrimaryKey:(NSString *)primaryKey;

/**
 *  @author Juvid, 16-07-11 13:07:44
 *
 *  插入数据（包括建表）
 *
 *  @param object    表对象
 *  @param priKey 主键
 *
 *  @return 操作状态
 */
+(BOOL)juInsertData:(JuBaseDBModel *)object primary:(NSString *)priKey;
/**
 *  @author Juvid, 16-07-22 13:07:57
 *
 *   插入数据（包括建表）
 *
 *  @param tableName 表名
 *  @param object    字典，数组
 *  @param priKey    主键（不设置传nil）
 *
 *  @return 操作状态
 */
+(BOOL)juInsertDatas:(id)object withTable:(NSString *)tableName primary:(NSString *)priKey;


/**
 *  @author Juvid, 16-07-23 11:07:22
 *
 *  多条数据更新操作（事物）
 *
 */
+(BOOL)juUpdateMulitSQL:(NSArray *)allSQL transaction:(BOOL)isTrans;

+(BOOL)juInsertDBSQL:(NSString *)sqlStr;

@end
