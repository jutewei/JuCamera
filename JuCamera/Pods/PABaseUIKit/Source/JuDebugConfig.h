//
//  JuBaseConfig.h
//  PABase
//
//  Created by Juvid on 2020/7/28.
//  Copyright © 2020 Juvid. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JuDebugConfig : NSObject

+(NSInteger)datAPI;

+(NSInteger)apiMainNum;

+(NSInteger)apiModelNum:(NSString *)strUrl;

+(NSString *)baseURLStr;

+(BOOL)isTest;

@end

NS_ASSUME_NONNULL_END
