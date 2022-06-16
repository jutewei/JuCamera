//
//  JuDateManage.h
//  PABase
//
//  Created by Juvid on 2018/5/18.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <Foundation/Foundation.h>
#define JUMareYMD   @"yyyy-MM-dd"
#define JuChatTimeSSS  @"yyyy-MM-dd HH:mm:ss.SSS"

@interface JuDateManage : NSObject

/**
 获取当前时间戳

 @return 时间戳
 */
+(NSTimeInterval )juTimeIntervalSince1970;
+(NSDate *)juTimeInterval:(NSTimeInterval)timeInterval;
/**
 格式化时间转换成日期

 @param dateStr 时间字符串
 @return 日期
 */
+(NSDate *)juDateWithString:(NSString *)dateStr;


+(NSDate *)juDateWithString:(NSString *)dateStr withFormate:(NSString *)formateStr;

/**
 日期转换成格式化时间字符

 @param date 日期
 @return 时间字符
 */
+(NSString *)juStringWithDate:(NSDate *)date;

+(NSString *)juStringWithDate:(NSDate *)date withFormate:(NSString *)formateStr;


/**
 时间戳转换成时间字符

 @param timeInterval 时间戳
 @return 时间字符
 */
+(NSString *)juStringWithInterval:(NSTimeInterval)timeInterval;

+(NSString *)juStringWithInterval:(NSTimeInterval)timeInterval withFormate:(NSString *)formateStr;


//创建当前具体时间
+(NSString *)juGetCurrentTime;
+(NSString *)getCurrentTime:(NSString *)formatter;

+(NSString *)juSwitchDetailDateSring:(NSDate *)lastDay;
+(NSString *)juSwitchDateAgo:(NSDate *)lastDay;
@end
