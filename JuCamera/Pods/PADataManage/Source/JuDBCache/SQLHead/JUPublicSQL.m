//
//  JUPublicSQL.m
//  PABase
//
//  Created by Juvid on 16/7/23.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JUPublicSQL.h"

@implementation JUPublicSQL
+(NSString *)juCreateTableSQL:(NSString *)className withKeys:(NSArray *)arrKey primaryKey:(NSString *)primaryKey{
    NSMutableArray *creatArr=[NSMutableArray array];
    for (NSString *strKey in arrKey) {
        if (primaryKey&&[strKey isEqualToString:primaryKey]) {
            [creatArr addObject:[NSString stringWithFormat:@"%@ text PRIMARY KEY",strKey]];
        }
        else{
            [creatArr addObject:[NSString stringWithFormat:@"%@ text",strKey]];
        }
    }
    NSMutableString * creatSql =[NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ ",className];
    [creatSql appendFormat:@"(%@)",[creatArr componentsJoinedByString:@","]];
    return creatSql;
}
+(NSString *)juInsertSql:(NSString *)tableName withSql:(NSString *)sqlStr{
    NSMutableString * sql= [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"INSERT INTO %@",tableName]];
    [sql appendString:sqlStr];
    return sql;
}

+(NSString *)juDeleteSql:(NSString *)tableName withSql:(NSString *)sqlStr{

    NSMutableString * sql= [NSMutableString stringWithString:[NSString stringWithFormat:@"DELETE %@ FROM %@ WHERE ",sqlStr?@"":@"*",tableName]];
    if (sqlStr) {
        [sql appendString:sqlStr];
    }
    return sql;
}

+(NSString *)juUpdateSql:(NSString *)tableName withSql:(NSString *)sqlStr{
    NSMutableString * sql=[[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"UPDATE  %@  SET ",tableName]];
    [sql appendString:sqlStr];
    return sql;
}

+(NSString *)juAlterSql:(NSString *)tableName withSql:(NSString *)sqlStr{
    NSString * sql=[NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT ",tableName,sqlStr];

    return sql;
}
@end
