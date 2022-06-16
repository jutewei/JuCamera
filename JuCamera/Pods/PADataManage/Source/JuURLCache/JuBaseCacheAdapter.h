//
//  JuCacheAdapter.h
//  JUURLCache
//
//  Created by Juvid on 2018/10/25.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define JuDate @"date"
#define JuCachePolicy @"cachePolicy"
//#define MinCacheInterval @"minCacheInterval"
#define JuMinRefresh  @"minRefresh"
#define JuConfigurationPlist @"JuvidPlist"

@protocol JuCacheAdapterProtocol <NSObject>

-(NSString *)juEnptyKey;

-(NSString *)juPageIndexKey;

-(NSArray *)juNoEncryptKeys;

-(CGFloat)juMinRefresh:(NSString *)path;

-(id)juGetNetData:(id)response;

@end

//基类适配器，如果有多个配置，再写适配器
@interface JuBaseCacheAdapter : NSObject<JuCacheAdapterProtocol>

@end
