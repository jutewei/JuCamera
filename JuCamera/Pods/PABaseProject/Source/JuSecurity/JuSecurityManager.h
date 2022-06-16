//
//  JuSecurityManager.h
//  PABase
//
//  Created by Juvid on 15/10/28.
//  Copyright © 2015年 Juvid(zhutianwei). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+AES.h"
#import "NSObject+encode.h"

@interface JuSecurityManager : NSObject
+ (NSString *)juSetMD5:(NSString *)str;
@end


