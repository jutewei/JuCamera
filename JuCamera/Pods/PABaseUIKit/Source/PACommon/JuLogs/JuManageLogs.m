//
//  JuManageLogs.m
//  PABase
//
//  Created by Juvid on 2017/8/25.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import "JuManageLogs.h"

@implementation JuManageLogs

+ (instancetype) shareInstance{
    static dispatch_once_t onceToken;
    static JuManageLogs *ju_ManageLogs = nil;
    //确保创建单例只被执行一次。
    dispatch_once(&onceToken, ^{
        ju_ManageLogs = [JuManageLogs new];
        //自己建立一个线程
        ju_ManageLogs.ju_WriteFileQueue = dispatch_queue_create("write_log_file", DISPATCH_QUEUE_CONCURRENT);
    });
    return ju_ManageLogs;
}

-(void)juCreateFile{
    // 文件存储的路径，
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [paths objectAtIndex:0];
    NSLog(@"%@",documentDirectory);
    
    NSFileManager *manager = [NSFileManager defaultManager];
    // 路径下的所有文件名
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateSysStr=[dateFormatter stringFromDate:[NSDate date]];
    //首次创建文件名
    self.ju_filePath = [NSString stringWithFormat:@"%@/logs/pifubao_%@.log",documentDirectory,dateSysStr];
    BOOL ifFileExist = [manager fileExistsAtPath:self.ju_filePath];
    BOOL success = NO;
    if (!ifFileExist) {
        success =  [manager createFileAtPath:self.ju_filePath contents:[NSData data] attributes:nil];
    }
   
}
- (void)juWriteMessageToFileWithJsonStr:(NSDictionary*)dic{
    // 字典转JSON
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self juWriteMessageStr:json];
    
}
- (void)juWriteMessageStr:(NSString *)str{
    
    dispatch_barrier_async(self.ju_WriteFileQueue, ^{
        [self juCreateFile];
        if (!self.ju_filePath) {
            NSLog(@"文件路径错误，写不进去");
            return;
        }
        NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:self.ju_filePath];
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"[yyyy/MM/dd HH:mm:ss.SSS]"];
        NSString *dateStr=[dateFormatter stringFromDate:[NSDate date]];///日志加时间
        
        // 字典转JSON
        NSString *jsonStr =[NSString stringWithFormat:@"%@ %@\n",dateStr,str];
        // 在文件的末尾添加内容。如果想在开始写 [file seekToFileOffset:0];
        [file seekToEndOfFile];
        NSData *strData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        [file writeData:strData ];
    });
    
}

//文件大小
- (float)juLogFileSize{
    NSFileManager *manager = [NSFileManager defaultManager];
    return  [[manager attributesOfItemAtPath:self.ju_filePath error:nil] fileSize]/(1024.0);//这里返回的单位是KB
}

- (void)juDeleteLogFile{
    dispatch_barrier_async(self.ju_WriteFileQueue, ^{
        NSFileManager *manager = [NSFileManager defaultManager];
        BOOL deleSuccess = [manager removeItemAtPath:self.ju_filePath error:nil];
        if (deleSuccess) {
            NSLog(@"删除文件成功");
        }else{
            NSLog(@"删除文件不成功");
        }
    });
    
}

//写日志
+ (void)juWriteLogFormat:(NSString *)format
{
    NSLog(@"%@", format);
    [[JuManageLogs shareInstance]juWriteMessageStr:format];
}

//直接把控制台消息文件保存控制台不输出信息
+ (void)juRedirectNSlogToDocumentFolder
{
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"juvid.log"];//注意不是NSData!
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    //先删除已经存在的文件
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:logFilePath error:nil];
    
    // 将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+", stderr);
}

@end
