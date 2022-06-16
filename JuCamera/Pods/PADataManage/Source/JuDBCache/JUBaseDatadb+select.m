//
//  SHFMDBSql+Select.m
//  PABase
//
//  Created by Juvid on 16/7/9.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JUBaseDatadb+select.h"

@implementation JUBaseDatadb (select)

//查询表
+(NSMutableArray *)juSelectTable:(NSString *)tableName{
    return [self juSelectTable:tableName whereKey:nil pIndex:nil
                         pSize:nil asc:nil desc:nil];
}

+(NSMutableArray *)juSelectTable:(NSString *)tableName
                          pIndex:(NSString *)pageIndex
                           pSize:(NSString *)pageSize  {
    return [self juSelectTable:tableName whereKey:nil pIndex:pageIndex
                         pSize:pageSize asc:nil desc:nil];
}

+(NSMutableArray *)juSelectTable:(NSString *)tableName
                        whereKey:(NSDictionary *)whereKey{
    return [self juSelectTable:tableName whereKey:whereKey pIndex:nil
                         pSize:nil asc:nil desc:nil];
}

+(NSMutableArray *)juSelectTable:(NSString *)tableName
                        whereKey:(NSDictionary *)whereKey
                          pIndex:(NSString *)pageIndex
                           pSize:(NSString *)pageSize{
    return [self juSelectTable:tableName whereKey:whereKey pIndex:pageIndex
                         pSize:pageSize asc:nil desc:nil];
}

+(NSMutableArray *)juSelectTable:(NSString *)tableName
                             asc:(NSArray *)ascArrKey{
   return  [self juSelectTable:tableName whereKey:nil pIndex:nil
                         pSize:nil asc:ascArrKey desc:nil];
}

+(NSMutableArray *)juSelectTable:(NSString *)tableName
                        whereKey:(NSDictionary *)whereKey
                             asc:(NSArray *)ascArrKey
                            desc:(NSArray *)desArrcKey{
     return  [self juSelectTable:tableName whereKey:whereKey pIndex:nil
                           pSize:nil asc:ascArrKey desc:desArrcKey];
}

+(NSMutableArray *)juSelectTable:(NSString *)tableName
                          pIndex:(NSString *)pindex
                           pSize:(NSString *)psize
                            desc:(NSArray *)desArrcKey{
    return [self juSelectTable:tableName whereKey:nil pIndex:pindex
                         pSize:psize asc:nil desc:desArrcKey];
}
/*
 *asc升序
 *desc降序
 */
+(NSMutableArray *)juSelectTable:(NSString *)tableName
                        whereKey:(NSDictionary *)whereKey
                          pIndex:(NSString *)pindex
                           pSize:(NSString *)psize
                             asc:(NSArray *)ascArrKey
                            desc:(NSArray *)desArrcKey
{
    NSMutableString *sqlStr=[NSMutableString string];
    if (whereKey) {
        NSMutableArray *arrKey=[NSMutableArray array];
        for (NSString *strKey in [whereKey allKeys]) {
            [arrKey addObject:[NSString stringWithFormat:@" %@='%@'",strKey,whereKey[strKey]]];
        }
        [sqlStr appendFormat:@"WHERE %@",[arrKey componentsJoinedByString:@" AND "]];
    }
    if(ascArrKey||desArrcKey){
        [sqlStr appendString:@" ORDER BY "];
        if (ascArrKey) {///< 默认升序
            [sqlStr appendString:[ascArrKey componentsJoinedByString:@","]];
        }
        if(desArrcKey){///< 降序
            NSMutableArray *arrDesc=[NSMutableArray array];
            for (NSString *string in desArrcKey) {
                [arrDesc addObject:[NSString stringWithFormat:@"%@ DESC",string]];
            }
            [sqlStr appendString:[arrDesc componentsJoinedByString:@","]];
        }
    }
    if (pindex&&psize) {
        [sqlStr appendFormat:@" limit %@,%@",pindex,psize];
    }
    return [self juSelectTable:tableName selectKey:nil withSql:sqlStr];
}
+(NSMutableArray *)juSelectTable:(NSString *)tableName
                          selectKey:(NSArray *)selectArr
                         withSql:(NSString *)strSql{
    NSString *select=@"*";
    if (selectArr) {
        select =[selectArr componentsJoinedByString:@","];
    }
    return [self juSelectDBSQL:[NSString stringWithFormat:@"SELECT %@ FROM %@ %@",select,tableName,strSql]];
}

+(NSMutableArray *)juSelectDBSQL:(NSString *)strSql{
    NSMutableArray *arrResult=[NSMutableArray array];
    [self juInDatabase:^(FMDatabase *db) {
        if ([db open]) {
            FMResultSet *rs=[db executeQuery:strSql];
            while ([rs next]) {
                NSMutableDictionary *dicResult=[NSMutableDictionary dictionaryWithDictionary:[rs resultDictionary]];
                [arrResult addObject:dicResult];
            }
        }
    }];
    return arrResult;
}
@end
