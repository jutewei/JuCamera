//
//  JuLogLevel.h
//  JuRefresh
//
//  Created by Juvid on 16/8/10.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//
#import "JuManageLogs.h"

#ifndef JuLogLevel_h
#define JuLogLevel_h
typedef NS_OPTIONS(NSUInteger, LogFlag){
    LogFlagHint     = 1 << 0,///00001 1
    LogFlagError    = 1 << 1,///00010 2
    LogFlagWarn     = 1 << 2,///00100 4
    LogFlagDebug    = 1 << 3,///01000 8
    LogFlagVerbose  = 1 << 4,///01000 16
};
typedef NS_OPTIONS(NSUInteger, LogLevel){
    LogLevelOff         = 0,///< 关闭打印
    LogLevelHint        = (LogFlagHint),///< 简短信息1
    LogLevelError       = (LogLevelHint|LogFlagError),      ///< 打印错误 3
    LogLevelWarn        = (LogLevelError|LogFlagWarn),      ///< 打印提示 7
    LogLevelDebug       = (LogLevelWarn|LogFlagDebug),      ///< Debug 15
    LogLevelVerbose     = (LogLevelDebug|LogFlagVerbose),   ///< Verbose 31
};

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()
#endif


#define JU_LOG_MAYBE(lvl, flg, frmt, ...) \
do { if(lvl & flg) [JuManageLogs juWriteLogFormat:[NSString stringWithFormat:(frmt), ##__VA_ARGS__]]; } while(0)

#ifndef JU_LOG_LEVEL_DEF
#define JU_LOG_LEVEL_DEF JuLogLevel
#endif


#define LogHint(frmt, ...)      if (JU_LOG_LEVEL_DEF&LogFlagHint)       {  NSLog((frmt), ##__VA_ARGS__);}
#define LogError(frmt, ...)     if (JU_LOG_LEVEL_DEF&LogFlagError)      { [JuManageLogs juWriteLogFormat:[NSString stringWithFormat:(frmt), ##__VA_ARGS__]];}
#define LogWarm(frmt, ...)      JU_LOG_MAYBE(JU_LOG_LEVEL_DEF,LogFlagWarn,frmt,##__VA_ARGS__) 
#define LogDebug(...)           if (JU_LOG_LEVEL_DEF&LogFlagDebug)      { NSLog(__VA_ARGS__);}
#define LogVerbose(...)         if (JU_LOG_LEVEL_DEF&LogFlagVerbose)    { NSLog(__VA_ARGS__);}

#endif /* JuLogLevel_h */
