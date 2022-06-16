//
//  JuManageLogs.h
//  PABase
//
//  Created by Juvid on 2017/8/25.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JuManageLogs : NSObject

@property (nonatomic,strong)NSString * ju_filePath;//当前操作的文件的路径
@property (nonatomic,strong)dispatch_queue_t ju_WriteFileQueue;//自己创建的一个线程


+ (instancetype) shareInstance;

/**
 日志写文件

 @param format 打印内容
 */
+ (void)juWriteLogFormat:(NSString *)format;

/**
 控制台log写日志，控制台不显示log
 */
+ (void)juRedirectNSlogToDocumentFolder;

//文件大小
/**
 日志文件大小

 @return 文件大小
 */
- (float)juLogFileSize;

/**
 删除日志文件
 */
- (void)juDeleteLogFile;

@end
