//
//  JuFileManage.m
//  JuFileManage
//
//  Created by Juvid on 15/4/30.
//  Copyright (c) 2015年 Juvid(zhutianwei). All rights reserved.
//

#import "JuFileManager.h"

@implementation JuFileManager

+(NSMutableArray *)juPlistResource:(NSString *)plistName{
    NSString *path = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    if (path) {
        NSMutableArray *arr=[[NSMutableArray arrayWithContentsOfFile:path] mutableCopy];
           return arr;
    }
    return [NSMutableArray array];
}

+(id )juJsonResource:(NSString *)plistName{
    NSString *path = [[NSBundle mainBundle] pathForResource:plistName ofType:@"json"];
    if (path) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        id object=  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];//kNilOptions
        return object;
    }
    return nil;
}

/**获取文件名*/
+(NSString *)juGetFileName:(id)filePath {
    NSString *strPath=[NSString stringWithFormat:@"%@",filePath];
    return [strPath lastPathComponent];
}

/******************新路径*****************/
/*Caches路径*/
+(NSString *)juGetFilePath:(NSString *)filePath fileName:(NSString *)fileName{
    return [[self juCreateCachesPath:filePath] stringByAppendingPathComponent:fileName];
}
/**用户(Document)路径**/
+(NSString *)juGetUserPath:(NSString *)filePath fileName:(NSString *)fileName{
    NSString *path=[self juCreateDocumentsPath:[NSString stringWithFormat:@"%@/%@",ju_user_cache,filePath]];
    if (fileName) {
        return [path stringByAppendingPathComponent:fileName];
    }
    return path;
}

#pragma mark 创建Library下caches文件存储的路径
+ (NSString *)juCreateCachesPath:(NSString *)filePath {
//    NSLibraryDirectory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    if (paths.count) {
        return [self juCreatFilePath:[paths objectAtIndex:0] filePath:filePath];
    }
    return nil;
}
#pragma mark 创建Documents文件存储的路径
+(NSString *)juCreateDocumentsPath:(NSString *)filePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (paths.count) {
        if (filePath) {
            return [self juCreatFilePath:[paths objectAtIndex:0] filePath:filePath];
        }
    }
    return nil;
}
/**
 创建文件路径
 */
+(NSString *)juCreatFilePath:(NSString *)path filePath:(NSString *)filePath{
    NSArray *segments = [NSArray arrayWithObjects:path,filePath, nil];

    NSString *imgfilePath =  [NSString pathWithComponents:segments];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if (![fileManager fileExistsAtPath:imgfilePath]) {
        [fileManager createDirectoryAtPath:imgfilePath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    return imgfilePath;
}


#pragma mark 存储Library下caches文件存储
+(NSString *)juSaveCacheData:(NSData *)data
                      folder:(NSString *)folder
                      suffix:(NSString *)suffix{
    if (data) {
        NSString *imageName=[[self juGetDateName] stringByAppendingPathExtension:suffix];
        NSString *path=[JuFileManager juGetFilePath:folder fileName:imageName];
        return [JuFileManager juSaveData:data path:path];
    }
    return nil;
}
#pragma mark 存储Documents文件存储
+(NSString *)juSaveUserData:(NSData *)data
                     folder:(NSString *)folder
                     suffix:(NSString *)suffix{
    if (data) {
        NSString *imageName=[[self juGetDateName] stringByAppendingPathExtension:suffix];
        NSString *path=[JuFileManager juGetUserPath:folder fileName:imageName];
        return [JuFileManager juSaveData:data path:path];
    }
    return nil;
}

+(NSString *)juSaveData:(NSData *)data path:(NSString *)path{
    if (![data isKindOfClass:[NSData class]]) {
        return nil;
    }
    BOOL isSuccess= [[NSFileManager defaultManager] createFileAtPath:path
                                                            contents:data
                                                          attributes:nil];
    if (isSuccess) {
        return path;
    }
    return nil;
}

+(NSError *)juRemoveAtFile:(NSString *)filePath{
    NSError *error=nil;
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    return error;
}

+(NSString *)juGetDateName{
    NSDate *date = [NSDate date];
    NSDateFormatter *datematter=[[NSDateFormatter alloc]init ];
    [datematter setDateFormat:@"YYYYMMddHHmmssSSS"];
    NSString *dateStr=[datematter stringFromDate:date];
    return [NSString stringWithFormat:@"%@%@",dateStr,[self juGet32coding:16]];
}

+ (NSString *)juGet32coding:(int)numLength{
    int kNumber = numLength;

    NSString *sourceStr = @"0123456789abcdefghijklmnopqrstuvwxyz";//ABCDEFGHIJKLMNOPQRSTUVWXYZ
    NSMutableString *resultStr = [[NSMutableString alloc] init];

    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
@end
