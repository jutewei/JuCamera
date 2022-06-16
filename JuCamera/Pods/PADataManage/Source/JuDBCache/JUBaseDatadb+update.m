//
//  SHFMDBSql+Update.m
//  PABase
//
//  Created by Juvid on 16/7/9.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JUBaseDatadb+update.h"

@implementation JUBaseDatadb (update)

+(BOOL)juUpdateTable:(JuBaseDBModel *)object whereKeys:(id)whereKeys{
    return [self juUpdateTable:object whereKeys:whereKeys exceptKeys:nil];
}

+(BOOL)juUpdateTable:(JuBaseDBModel *)object
           whereKeys:(id)whereKeys
          exceptKeys:(NSArray *)exceptKeys{
    NSString *className=NSStringFromClass([object class]);
    NSMutableDictionary *dicKeyVaule=[[object class] juToDictionary:object];
    if (exceptKeys) {
        [dicKeyVaule removeObjectsForKeys:exceptKeys];
    }
    return [self juUpdateTable:className withData:dicKeyVaule whereKeys:whereKeys];
}

+(BOOL)juUpdateTable:(NSString *)tableName
            withData:(NSDictionary *)dicObject
           whereKeys:(id)whereKeys{
    if ([whereKeys isKindOfClass:[NSString class]]) {
        whereKeys=@[whereKeys];
    }
    NSMutableArray * setArr = [NSMutableArray array];
    NSMutableArray *whereArr = [NSMutableArray array];

    for (NSString *strKey in [dicObject allKeys]) {
        if ([whereKeys containsObject:strKey]) {///< 更新的值
            [whereArr addObject:[NSString stringWithFormat:@" %@='%@' ",strKey,dicObject[strKey]]];
        }else{///< 更新的条件
            if (dicObject[strKey]&&![dicObject[strKey] isEqual:@""]) {
                [setArr addObject:[NSString stringWithFormat:@" %@='%@' ",strKey,dicObject[strKey]]];
            }
        }
    }
    return [self juUpdateTable:tableName set:[setArr componentsJoinedByString:@","] where:[whereArr componentsJoinedByString:@"AND"]];
}

+(BOOL)shUpdateTable:(NSString *)tableName
            withData:(NSDictionary *)dicObject
           whereData:(NSDictionary *)whereData{

    NSMutableArray * setArr = [NSMutableArray array];
    NSMutableArray *whereArr = [NSMutableArray array];

    for (NSString *strKey in whereData.allKeys) {///< 更新的值
        [whereArr addObject:[NSString stringWithFormat:@" %@='%@' ",strKey,whereData[strKey]]];
    }
    for (NSString *strKey in [dicObject allKeys]) {
        if (dicObject[strKey]&&![dicObject[strKey] isEqual:@""]) {
            [setArr addObject:[NSString stringWithFormat:@" %@='%@' ",strKey,dicObject[strKey]]];
        }
    }
    return [self juUpdateTable:tableName set:[setArr componentsJoinedByString:@","] where:[whereArr componentsJoinedByString:@"AND"]];
}

//批量更新表数据
+(BOOL)juUpdateTable:(NSString *)table
           setKValue:(NSDictionary *)dicSetObj{
    return [self juUpdateTable:table set:[[self juDealKValue:dicSetObj] componentsJoinedByString:@","]];
}
+(BOOL)juUpdateTable:(NSString *)table
           setKValue:(NSDictionary *)dicSetObj
         whereKValue:(NSDictionary *)dicWhereObj{
    return [self juUpdateTable:table set:[[self juDealKValue:dicSetObj] componentsJoinedByString:@","] where:[[self juDealKValue:dicWhereObj] componentsJoinedByString:@"AND"]];
}
/**拼接处理条件*/
+(NSArray *)juDealKValue:(NSDictionary *)dicObj{
    NSMutableArray * dealArr = [NSMutableArray array];
    for (NSString *strKey in [dicObj allKeys]) {
        if (dicObj[strKey]&&![dicObj[strKey] isEqual:@""]) {
            [dealArr addObject:[NSString stringWithFormat:@" %@='%@' ",strKey,dicObj[strKey]]];
        }
    }
    return dealArr.count>0?dealArr:nil;
}

+(BOOL)juUpdateTable:(NSString *)tableName set:(NSString *)setSql{
    return [self juUpdateTable:tableName set:setSql where:nil];
}
+(BOOL)juUpdateTable:(NSString *)tableName set:(NSString *)setSql where:(NSString *)whereSql{
    NSMutableString * sqlStr= [NSMutableString string];
    if (setSql) {
        [sqlStr appendString:setSql];
    }
    if (whereSql) {
        [sqlStr appendString:@" WHERE "];
        [sqlStr appendString:whereSql];
    }
   return [self juUpdateTable:tableName withSql:sqlStr];
}
+(BOOL)juUpdateTable:(NSString *)tableName withSql:(NSString *)sqlStr{
    return [self juUpdateDBSQL:[JUPublicSQL juUpdateSql:tableName withSql:sqlStr]];
}

+(BOOL)juUpdateDBSQL:(NSString *)sqlStr{
    __block BOOL flag = NO;
    [self juInDatabase:^(FMDatabase *db) {
        if ([db open]) {
            if ([db executeUpdate:sqlStr]) {
//                LogWarm(@"更新表数据成功%@",sqlStr);
                flag = YES;
            }else{
//                LogError(@"更新表数据失败%@",sqlStr);
                flag = NO;
            }
        }
    }];
    return flag;
}
@end
