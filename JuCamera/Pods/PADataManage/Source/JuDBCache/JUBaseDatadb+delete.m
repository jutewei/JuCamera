//
//  JUBaseDatadb+delete.m
//  PABase
//
//  Created by Juvid on 16/7/11.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JUBaseDatadb+delete.h"

@implementation JUBaseDatadb (Delete)
//删除表数据
+(BOOL)juDeteleTabData:(NSString *)className delKey:(NSString *)dKey delValue:(NSString *)dValue{
    return [self juDeleteTable:className withSql:[NSString stringWithFormat:@" %@='%@' ",dKey,dValue]];
}
+(BOOL)juDeteleTabData:(NSString *)className whereStr:(NSString *)strWhere {
    return [self juDeleteTable:className withSql:strWhere];
}
+(BOOL)juDeteleTabData:(NSString *)tableName whereDic:(NSDictionary *)whereDic{
    NSMutableArray *arrWhere=[NSMutableArray array];
    for (NSString *strKey in [whereDic allKeys]) {
        id value = [whereDic valueForKey:strKey];
        if (value&&![value isEqual:@""]) {
            [arrWhere addObject:[NSString stringWithFormat:@" %@='%@' ",strKey,value]];
        }
    }
    return [self juDeleteTable:tableName withSql:[arrWhere componentsJoinedByString:@" AND "]];
}
//删除表数据
+(BOOL)juDeteleTabData:(JuBaseDBModel *)object{
    NSDictionary *dicKeyVaule=[[object class] juToDictionary:object];
    return [self juDeteleTabData:NSStringFromClass([object class])  whereDic:dicKeyVaule];
}
+(BOOL)shDeteleTabData:(NSDictionary *)dicObject table:(NSString *)tableName{
    return [self juDeteleTabData:tableName whereDic:dicObject];
}

+(BOOL)juDeleteTable:(NSString *)tableName withSql:(NSString *)sqlStr{
    return [self juDeleteDBSQL:[JUPublicSQL juDeleteSql:tableName withSql:sqlStr]];
}


+(BOOL)juCleanAllData:(NSString *)tableName{
    return [self juDeleteDBSQL:[JUPublicSQL juDeleteSql:tableName withSql:nil]];
}

+(BOOL)juDeleteDBSQL:(NSString *)sqlStr{
    __block BOOL flag = NO;
    [self juInDatabase:^(FMDatabase *db) {
        if ([db open]) {
            if ([db executeUpdate:sqlStr]) {
//                LogWarm(@"删除表数据成功%@",sqlStr);
                flag = YES;
            }else{
//                LogError(@"删除表数据失败%@",sqlStr);
                flag = NO;
            }
        }
    }];
    return flag;
}

@end
