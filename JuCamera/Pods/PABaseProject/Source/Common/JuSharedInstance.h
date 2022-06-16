//
//  JuSharedInstance.h
//  PABase
//
//  Created by Juvid on 2017/8/23.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JuWindow.h"
#define Ju_Share [JuSharedInstance sharedInstance]

@interface JuSharedInstance : NSObject

+ (instancetype) sharedInstance;

@property (nonatomic,weak)      UIViewController *topViewcontrol;
@property (nonatomic,weak)      NSString *ju_userIdentifier;    ///< 用户唯一标识 （手机号）
@property (nonatomic,strong)    NSString *ju_dbName;            ///< 用户数据库标识
@property (nonatomic,copy)      NSDate *ju_finishData;          ///< webview当前链接是否加载结束
@property (nonatomic,strong)    JuWindow *ju_toPwindow;
@property (nonatomic,strong)    JuWindow *ju_window;

/// 设置用户唯一标识
/// @param phone 手机号
/// @param dbName 数据库名
-(void)setUserPhone:(NSString *)phone
             dbName:(NSInteger)dbName;

/// 获取数据库名
-(NSString *)juUserDBName;

/// 单例对象存储
/// @param value 值
/// @param key 关键key
-(void)juSetValue:(id)value key:(NSString *)key;

/// 查找对象
/// @param key 关键key
-(id)juObjectForKey:(NSString *)key;

/// 查找对象（无对象自动生成唯一类实例对象）
/// @param objClass 类名
-(id)juObjectForClass:(Class)objClass;

/// 根据key移除值
/// @param key key
-(void)juRemoveObjectForKey:(NSString *)key;

/// 根据class移除值
/// @param objClass 类名
-(void)juRemoveObjectForClass:(Class)objClass;

//-(NSString *)renameUserIMDB;
@end
