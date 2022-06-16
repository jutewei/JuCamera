//
//  JuDateManage.m
//  PABase
//
//  Created by Juvid on 2018/5/18.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuDateManage.h"

@implementation JuDateManage

+(NSTimeInterval )juTimeIntervalSince1970{
    return [[NSDate date] timeIntervalSince1970];
}
+(NSDate *)juTimeInterval:(NSTimeInterval)timeInterval{
    if(timeInterval > 140000000000) {
        timeInterval = timeInterval / 1000;
    }
    return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}

+(NSDate *)juDateWithString:(NSString *)dateStr{
    return [self juDateWithString:dateStr withFormate:JuChatTimeSSS];
}

+(NSDate *)juDateWithString:(NSString *)dateStr withFormate:(NSString *)formateStr{
    NSDateFormatter * formatter  = [[NSDateFormatter alloc] init] ;
    [formatter  setDateFormat:formateStr];
    NSDate *date=[formatter dateFromString:dateStr];
    return date;
}

+(NSString *)juStringWithDate:(NSDate *)date{
    return [self juStringWithDate:date withFormate:JUMareYMD];
}

+(NSString *)juStringWithDate:(NSDate *)date withFormate:(NSString *)formateStr{
    NSDateFormatter * formatter  = [[NSDateFormatter alloc] init] ;
    [formatter  setDateFormat:formateStr];
    NSString *stringDate=[formatter stringFromDate:date];
    return stringDate;
}

+(NSString *)juStringWithInterval:(NSTimeInterval)timeInterval{
    return [self juStringWithInterval:timeInterval withFormate:JUMareYMD];
}

+(NSString *)juStringWithInterval:(NSTimeInterval)timeInterval withFormate:(NSString *)formateStr{
    NSDate *date= [self juTimeInterval:timeInterval];
    return [self juStringWithDate:date withFormate:formateStr];
}
//创建当前时间
+(NSString *)juGetCurrentTime{
    return [self getCurrentTime:JuChatTimeSSS];
}
+(NSString *)getCurrentTime:(NSString *)formatter{
    return [self juStringWithDate:[NSDate date] withFormate:formatter];
}

+(NSString *)juSwitchDetailDateSring:(NSDate *)lastDay {
    if (!lastDay) lastDay =[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *today = [NSDate date];
    NSTimeZone *localTimeZone = [NSTimeZone systemTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    // 时分秒转为00:00:00
    NSDate *today2 = [dateFormatter dateFromString:[dateFormatter stringFromDate:today]];
    // 时分秒转为00:00:00
    NSDate *lastDay2 = [dateFormatter dateFromString:[dateFormatter stringFromDate:lastDay]];
    NSTimeInterval moreTime=[today2 timeIntervalSinceDate:lastDay2];
    [dateFormatter setDateFormat:@"HH:mm"];
    if (moreTime<60*60*24) {
        return [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:lastDay]];
    }else if (moreTime<60*60*24*2) {
        return [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:lastDay]];
    }else if (moreTime>=60*60*24*2&&moreTime<60*60*24*7) {
        [dateFormatter setDateFormat:@"EE HH:mm"];
    }else{
        [dateFormatter setDateFormat:@"yy/M/d"];
    }
    return  [dateFormatter stringFromDate:lastDay];
}
+(NSString *)juSwitchDateAgo:(NSDate *)lastDay {
    if (!lastDay) lastDay =[NSDate date];
    NSDate *today = [NSDate date];
    NSTimeInterval moreTime=[today timeIntervalSinceDate:lastDay];
    if (moreTime<60) {///< 一分钟内
        return [NSString stringWithFormat:@"%d秒前",(int)moreTime];
    }else if (moreTime<60*60) {///< 一小时内
        return [NSString stringWithFormat:@"%d分钟前",(int)moreTime/60];
    }else if (moreTime<60*60*24) {///< 一天内
        return [NSString stringWithFormat:@"%d小时前",(int)moreTime/3600];
    }
    //    else if (moreTime<60*60*24*7) {///< 一周内
    else{
        return [NSString stringWithFormat:@"%d天前",(int)moreTime/(3600*24)];
    }
    //    }else{///< 一周前
    //      return  @"1周前";
    //    }

}
//c语言方法
/*static NSDateFormatter* CreateDateFormatter(NSString *format)
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];

//    [dateFormatter setLocale:locale];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [dateFormatter setDateFormat:format];
    return dateFormatter;
}*/
@end
