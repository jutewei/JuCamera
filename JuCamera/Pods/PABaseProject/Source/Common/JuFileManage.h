//
//  JuFileManage.h
//  JuFileManage
//
//  Created by Juvid on 15/4/30.
//  Copyright (c) 2015年 Juvid(zhutianwei). All rights reserved.
//

#import <Foundation/Foundation.h>
#define splash_plist @"splash"///< 闪屏文件
#define user_cache @"JUPAUser"
@interface JuFileManage : NSObject

+(NSMutableArray *)juPlistResource:(NSString *)plistName;

+(id)juJsonResource:(NSString *)plistName;

/**获取文件名*/
+(NSString *)juGetFileName:(id)filePath;

/*获取Caches路径（包含创建）*/
+(NSString *)juGetFilePath:(NSString *)filePath
                  fileName:(NSString *)fileName;

/**获取(Document)路径 （包含创建**/
+(NSString *)juGetUserPath:(NSString *)filePath
                  fileName:(NSString *)fileName;



#pragma mark 创建Library下caches文件存储的路径
+ (NSString *)juCreateCachesPath:(NSString *)filePath;

#pragma mark 创建Documents下caches文件存储的路径
+(NSString *)juCreateDocumentsPath:(NSString *)filePath;
/**
 创建文件路径
 */
+(NSString *)juCreatFilePath:(NSString *)path
                    filePath:(NSString *)filePath;

//存储文件
+(NSString *)juSaveData:(NSData *)data path:(NSString *)path;

// 存储Library下caches文件存储
+(NSString *)juSaveCacheData:(NSData *)data
                      folder:(NSString *)folder
                      suffix:(NSString *)suffix;
// 存储Documents文件存储
+(NSString *)juSaveUserData:(NSData *)data
                     folder:(NSString *)folder
                     suffix:(NSString *)suffix;

+(NSString *)juGetTmpPath:(NSString *)filePath
                imageName:(NSString *)imageName;
// 存储Tmp文件存储
+(NSString *)juSaveTmpData:(NSData *)data
                     folder:(NSString *)folder
                     suffix:(NSString *)suffix;
//移除文件
+(NSError *)juRemoveAtFile:(NSString *)filePath;

//根据时间生成文件名
+(NSString *)juGetDateName;

//根据长度生成随机文件名
+(NSString *)juGet32coding:(int)numLength;

@end
