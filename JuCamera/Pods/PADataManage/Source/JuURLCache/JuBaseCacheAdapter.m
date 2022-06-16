//
//  JuCacheAdapter.m
//  JUURLCache
//
//  Created by Juvid on 2018/10/25.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuBaseCacheAdapter.h"

@implementation JuBaseCacheAdapter

-(NSString *)juEnptyKey{
    return  @"emptyData";
}

-(NSString *)juPageIndexKey{
    return @"offset";
}

-(NSArray *)juNoEncryptKeys{
    return @[@"emptyData",@"common"];
}


/**
 设置需要缓存的url

 @param path url路径
 @return 刷新时间
 */
-(CGFloat)juMinRefresh:(NSString *)path{
    if ([path isEqual:@"test"]) {
        return 5;
    }
    return 0;
}

/*
 self.cachePolicy=CachePermanentlyCacheStoragePolicy时强制使用缓存，如果缓存过期，请求网络
 self.cachePolicy=CacheRoutineCachePolicy时判断是否刷新，刷新数据没过期，优先使用缓存
 self.cachePolicy=CacheNotPolicy无缓存
 无网络时不管刷新日期是否过期，都使用缓存
 */

//添加自己需要添加的缓存时间、缓存策略和刷新时间，否则使用默认设置
//个人调用接口自行加缓存策略
-(id)juGetNetData:(id)response{
    if (([response isKindOfClass:[NSArray class]]||[response isKindOfClass:[NSDictionary class]])&&[response count]>0) {
        return response;
    }
    return nil;
}
@end
