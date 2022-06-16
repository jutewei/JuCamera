//
//  JuBaseDataManage.h
//  PABase
//
//  Created by Juvid on 2019/12/5.
//  Copyright © 2019 Juvid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JuTopBarView.h"
#import "JuBarButton.h"
#import "NSObject+Safety.h"
#import "JuBaseConfig.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, JUStatusBarStyle) {
    JUStatusBarStyleNone = 0,//未赋值
    JUStatusBarStyleLight = 1,//白色
    JUStatusBarStyleDark = 2,//黑色
};
@interface JuTopBarManage : NSObject

@property (nonatomic,strong) UIColor *zl_topBarColor;           ///<导航栏颜色
@property (nonatomic,strong) UIImage *zl_topBarImage;           ///<导航栏图片

@property (nonatomic,strong) UIColor *zl_barLineColor;              ///<导航栏下划线颜色
@property (nonatomic,strong) UIColor *zl_barItemColor;              ///<导航栏按钮颜色
@property (nonatomic,strong) NSString *zl_barLeftImage;             ///<导航栏返回正常图标
@property (nonatomic,strong) NSString *zl_barCloseImage;            ///<导航栏关闭正常图标

@property (nonatomic,strong) NSString *zl_barLeftLightImg;          ///<导航栏左边特殊图标
@property (nonatomic,strong) UIFont *zl_barItemFont;                ///<标题栏字体
@property (nonatomic,strong,nullable) UIColor *zl_barTitleColor;             ///<标题栏字体颜色

@property (nonatomic,assign) JUStatusBarStyle zl_statusBarStyle;    ///< 状态栏颜色
@property (nonatomic,assign) CGFloat zl_changeBarPoint;             ///< 状态栏变化的位置
@property (nonatomic,assign) CGFloat zl_barAlpha;                   ///< 状态栏透明色
@property (nonatomic,assign) JuNavBarStatus zl_barStatus;           ///< 导航栏状态
@property (nonatomic,assign) BOOL isHideBackButton;                 ///< 导航栏状态

@property (nonatomic,copy) id zl_largeTitles;
@property (nonatomic,assign) CGFloat zl_largeTitleHeight;

@property (nonatomic,readonly) JuTopBarView *zl_topBarView;         ///<
@property (nonatomic,strong) UIView *zl_cunstomTitleView;         ///<

@property (nonatomic,strong)JuTitleTopEdgeView *zl_topEdgeView;     ///< 大标题背景

@property (nonatomic,assign) BOOL isUse;                            ///< 是否已经赋值保证初始化时只加载一次

-(void)zlTopBarView:(UIViewController *)supvc;

-(BOOL)isLightStyle;

-(UILabel *)titleView;

-(void)zlResetTopbar;

@end

@interface NSString (image)

- (UIImage *)image ;


@end

NS_ASSUME_NONNULL_END
