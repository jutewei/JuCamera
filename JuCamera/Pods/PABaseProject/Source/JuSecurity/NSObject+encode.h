//
//  NSObject+encode.h
//  PABase
//
//  Created by Juvid on 2019/12/13.
//  Copyright © 2019 Juvid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JuSecurityManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface NSObject (encode)

-(void)juSetEncode:(NSString *)encodeKey path:(NSString *)path;

+(id) juGetEncode:(NSString *)encodeKey path:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
