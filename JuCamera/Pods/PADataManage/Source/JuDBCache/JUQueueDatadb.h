//
//  JUSQLQueuedb.h
//  PABase
//
//  Created by Juvid on 16/7/22.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JUFMDB.h"

//#define JUShareQueuedb  [JUQueuDatadb sharedClient].ju_dbQueue

@interface JUQueueDatadb : JUBaseDatadb

+ (instancetype)sharedClient;

@property (nonatomic,readonly)FMDatabaseQueue *ju_dbQueue;

@property (nonatomic,copy)NSString *ju_dbName;

@property (nonatomic,strong)NSMutableDictionary *ju_dicDBTable;

+(JUQueueDatadb *)client;

+(void)juDeallocDB;///< 摧毁数据单例（每个用户数据库不一样）

-(void)juSetQueueDBPath:(NSString *)path;

@end
