//
//  PredicateCheck.h
//  YunMySelf
//
//  Created by Juvid on 14/12/1.
//  Copyright (c) 2014年 Juvid(zhutianwei). All rights reserved.
//
/**
 *正则表达式过滤
 */
#import <Foundation/Foundation.h>

@interface JuPredicateCheck : NSObject
// 去空字符
+(NSString*)abandonWhitesSpaceWithString:(NSString*)str;
+(BOOL)isMobileCheck:(NSString *)str;
+(NSString *)juSwithSafe:(NSString *)str left:(NSInteger)left right:(NSInteger)right;
//空字符
+(BOOL)isEmpty:(id)strObject;
+(BOOL)userIDNumCheck:(NSString *)IDNum;///< 身份证
+(BOOL)isCheckEmail:(NSString *)str;
//加密手机号
+(NSString *)safePhoneNum:(NSString *)str;
+(NSString *)GetLast:(NSString *)startStr RangStr:(NSString *)str;
+(NSString *)GetPrevious:(NSString *)startStr RangStr:(NSString *)str;
+(BOOL)isPassWord:(NSString *)pass;

@end
