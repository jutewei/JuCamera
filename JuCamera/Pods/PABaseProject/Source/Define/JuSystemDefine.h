//
//  LESysDefine.h
//  XYLEPlay
//
//  Created by Juvid on 15/6/23.
//  Copyright (c) 2015年 Juvid‘s. All rights reserved.
//

#import "JuThreadManage.h"

#ifndef JuSystemDefine_h
#define JuSystemDefine_h

typedef void(^__nullable JuResultHandle)(id _Nullable result);             //
/**
 *750*1334 375*667
 *1242*2208  414*736
 **/

/// 当前宽高
#define Window_Height       [[UIScreen mainScreen] bounds].size.height
#define Window_Width        [[UIScreen mainScreen] bounds].size.width
//屏幕固定宽高
#define Screen_Height       MAX(Window_Height,Window_Width)
#define Screen_Width        MIN(Window_Height,Window_Width)

#define StatusBar_Height    [[UIApplication sharedApplication] statusBarFrame].size.height///< 状态栏高
#define NavBar_Height       (StatusBar_Height+44)       ///< 导航栏和状态栏高
#define IPhoneXstatusBar    MAX(StatusBar_Height-20,0)  ///< iPhonex状态栏多出的高

#define Screen_MaxSide      MAX(Screen_Height,Screen_Width)
#define Screen_Scale        ([UIScreen mainScreen].scale)
#define Screen_MaxPix       (Screen_MaxSide*Screen_Scale)
#define Pixel_Unit          10000
#define Pixel_IPhone6       (1250*Pixel_Unit)   ///< 1200万
#define Pixel_IPhone45      (850*Pixel_Unit)    ///< 800万

#define IPHONE6PLUS         (Screen_Width>=414)
#define IPHONE345           (Screen_Width==320)

#define IPHONE5S            (Screen_Height<=568)
#define IPHONE4S            (Screen_Height==480)
#define IPHONE56            (Screen_Height>480)
#define IPHONE6             (Screen_Height==667)
#define IPHONE6P            (Screen_Height==736)
#define IPHONEX             (Screen_Height>736)

#define IPHONE_5_SCREEN_WIDTH       320
#define IPHONE_6_SCREEN_WIDTH       375
#define IPHONE_P_SCREEN_WIDTH       414

#define IPHONE_4_SCREEN_HEIGHT      480  //640x960
#define IPHONE_5_SCREEN_HEIGHT      568  //640x1136
#define IPHONE_6_SCREEN_HEIGHT      667  //750x1334
#define IPHONE_P_SCREEN_HEIGHT      736  //1242x2208

#define IS_ON_IPHONE        (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)    ///< 设备类型是iPhone
#define IS_ON_IPAD          (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)      ///< 设备类型是iPad

#define NSUSER_DEFAULTS             [NSUserDefaults standardUserDefaults]           ///< 偏好设置
#define NSNotification_Defaults     [NSNotificationCenter defaultCenter]            ///< 通知

#define WeakSelf                    __weak typeof(self)     weakSelf = self;
#define WeakObject(value)           __weak typeof(value)    weakOjc = value;              ///< weak转换

#define NSStringFromSelf            NSStringFromClass([self class])                 ///< class转换
#define NSStringFromObj(value)      NSStringFromClass([value class])

#define JuBlockHandle(handleBlock)         if(handleBlock) handleBlock();      ///< block 判断
#define JuBlockHandleV(handleBlock,value)  if(handleBlock) handleBlock(value); /// block 判断(带一个参数)

//判断设备的版本
#define IOS_SYS_VERSION             [[[UIDevice currentDevice] systemVersion] floatValue]
#define IOS_MAX_VERSION(value)      ((IOS_SYS_VERSION>=value)?YES:NO)

//处理null字典
//#define SET_OBJC_KEY_VALUE(member, value) {(member)=[NSString  stringWithFormat:@"%@", (value)==[NSNull null]?@"":(value)];}
//处理nil字符串
#define SET_SafeVaule(value) (value!=nil?value:@"")

//分享相关字段
#define ShareTitle    @"msg_title"
#define ShareDesc     @"msg_desc"
#define ShareCdnUrl   @"msg_cdn_url"
#define ShareMid      @"msg_mid"

#endif
