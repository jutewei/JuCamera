//
//  SHFMDBSql+insert.m
//  PABase
//
//  Created by Juvid on 16/7/9.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JUBaseDatadb+insert.h"

@implementation JUBaseDatadb (insert)
//插入表数据
/**批量插入数据使用事物*/

//插入表数据(单条)
+(BOOL)juInsertData:(JuBaseDBModel *)object primary:(NSString *)priKey{
    NSString *tableName=NSStringFromClass([object class]);
    return [self juInsertDatas:object withTable:tableName primary:priKey];
}
/**插入多条或者单条数据*/
+(BOOL)juInsertDatas:(id)object withTable:(NSString *)tableName primary:(NSString *)priKey{
    NSArray *allKeys=[[self shObjectForDic:object] allKeys];///< 获取建表所有key
    if ([self juCreateTable:tableName withKeys:allKeys  primaryKey:priKey]) {///< 建表成功后写数据
        if ([object isKindOfClass:[NSDictionary class]]||[object isKindOfClass:[JuBaseDBModel class]]) {
            return [self juInsertTable:tableName withSql:[self shObjectForSQL:object]];
        }else if([object isKindOfClass:[NSArray class]]){
            NSMutableArray *arrSql=[NSMutableArray array];
            for (id dicData in object) {
                [arrSql addObject:[JUPublicSQL juInsertSql:tableName withSql:[self shObjectForSQL:dicData]]];
            }
            return [self juUpdateMulitSQL:arrSql transaction:YES];
        }
    }
    return NO;
}

/**多条数据**/
+(BOOL)juUpdateMulitSQL:(NSArray *)allSQL transaction:(BOOL)isTrans{

    __block  BOOL flag = NO;
    if (isTrans) {
        [self juInTransaction:^(FMDatabase *db, BOOL *rollback) {
            [db open];
            for (NSString *string in allSQL) {
                if (![db executeUpdate:string]) flag=YES;
            }
            *rollback=!flag;
        }];
    }else{
        [self juInDatabase:^(FMDatabase *db) {
            [db open];
            for (NSString *string in allSQL) {
                if (![db executeUpdate:string]) flag = YES;
            }
        }];
    }
    if (!flag) {
//        LogWarm(@"批量添加数据成功%@",allSQL);
    }else{
//        LogError(@"批量添加数据失败%@",allSQL);
    }
    return !flag;
}
/**单条数据*/
+(BOOL)juInsertTable:(NSString *)tableName withSql:(NSString *)sqlStr{
    return [self juInsertDBSQL:[JUPublicSQL juInsertSql:tableName withSql:sqlStr]];
}
/**单条数据*/
+(BOOL)juInsertDBSQL:(NSString *)sqlStr{
    __block BOOL flag = NO;
    [self juInDatabase:^(FMDatabase *db) {
        [db open];
        if ([db executeUpdate:sqlStr]) {
//            LogWarm(@"添加数据成功%@",sqlStr);
            flag=YES;
        }else{
//            LogError(@"添加数据失败%@",sqlStr);
            flag=NO;
        }
    }];
    return flag;
}
+(NSDictionary *)shObjectForDic:(id)object{
    if ([object isKindOfClass:[NSDictionary class]]) {
        return object;
    }else if([object isKindOfClass:[NSArray class]]&&[object count]>0){
        return [self shObjectForDic:object[0]];
    }else if([object isKindOfClass:[JuBaseDBModel class]]){
        return [[object class] juToDictionary:object];
    }
    return @{};
}
/**拼接插入语句*/
+(NSString *)shObjectForSQL:(id)object{
    NSDictionary *dicObject=[self shObjectForDic:object];
    NSMutableArray * keyArr = [NSMutableArray array];
    NSMutableArray * valueArr = [NSMutableArray array];
    for (NSString *strKey in [dicObject allKeys]) {
        [keyArr addObject:strKey];
        [valueArr addObject:[NSString stringWithFormat:@"'%@'",dicObject[strKey]]];
    }
    return  [NSString stringWithFormat:@" (%@) VALUES (%@)",[keyArr componentsJoinedByString:@","] ,[valueArr componentsJoinedByString:@","]];
}

@end
