//
//  JUURLCache.h
//  JUURLCache
//
//  Created by Juvid on 18/10/25.
//  Copyright (c) 2018年 Juvid(zhutianwei). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JuBaseCacheAdapter.h"

typedef enum JuCacheStoragePolicy {
    JuCacheNotPolicy=0,//默认无缓存
    JuCacheRoutineCachePolicy = 1,//有缓存（缓存过期会预加载）
    JuCacheCacheExpiredPolicy  = 2,//有缓存（缓存过期就不使用缓存）

} CacheStoragePolicy;
@protocol JuCacheAdapterProtocol;
@interface JUURLCache : NSObject

+(id)initWithPath:(NSString *)path parameter:(NSDictionary *)para;
/**
 初始化

 @param path 路径
 @param para 参数
 @param dapter 适配器
 @return 对象
 */
+(id)initWithPath:(NSString *)path parameter:(NSDictionary *)para adapter:(id<JuCacheAdapterProtocol>)dapter;
/**
 调用失败后直接读取本地数据

 @return 数据
 */
-(id)juGetCached;
/**
 读取缓存

 @param netConnection 网络是否连接
 @param cacheResult 返回本地数据
 @return 是否需要刷新接口
 */
-(BOOL)juGetCache:(BOOL)netConnection withData:(void(^)(id result))cacheResult;

/**
 写缓存

 @param response 网络数据
 */
- (void)juSaveCacheData:(id)response;

//检测缓存是否存在
-(BOOL)isCached;

+(void)juRemoveURLCache;
@end
