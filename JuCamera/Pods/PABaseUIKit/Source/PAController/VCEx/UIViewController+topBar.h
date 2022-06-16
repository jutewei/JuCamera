//
//  UIViewController+topBar.h
//  PABase
//
//  Created by Juvid on 2019/12/12.
//  Copyright © 2019 Juvid. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "JuBarButton.h"
#import "JuTopBarManage.h"

#warning 基类必须实现的两个方法不然会crash
#define barItemActions @[@"zlTouchLeftItems:",@"zlTouchRightItems:"]
NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (topBar)
@property(nonatomic,strong)JuTopBarManage *ju_styleManage;

-(JuNavBarStatus)ju_barStatus;


-(void)juSetBackItem;

-(void)juSetAndAddTopBar:(BOOL)isReset;


-(void)setBarAlpha:(CGFloat)barAlpha;
/**
 *  @author Juvid, 15-11-23 14:11
 *
 *  导航栏统一左边按钮

 */
-(void )setBarLeftItem:(id)element;
/**
 *  @author Juvid, 15-11-23 14:11
 *
 *  导航栏统一右边按钮
 *
 */
-(void )setBarRightItem:(id)element;

//导航栏自定义样式右边按钮
-(void )setCustomItem:(id)element left:(BOOL)isLeft;
/**
 *  @author Juvid, 15-11-23 14:11
 *
 *  导航栏多个按钮
 */
-(void)setBarLeftItems:(NSArray *)itemName;
-(void)setBarRightItems:(NSArray *)itemName;


-(JuBarButton *)ju_rightBarItem;
-(JuBarButton *)ju_leftBarItem;

/**
 白色状态栏

 @param isLight 是否白色
 */
-(void)setStatusBarIsLight:(BOOL)isLight;

/**
 隐藏导航栏

 @param isHide 隐藏
 */
-(void)setNavitationBarIsHide:(BOOL)isHide;

/**
 *  @author Juvid, 15-11-23 14:11
 *
 *  透明导航栏
 */
//-(void)shSetNavBarClear:(UIColor *)lineColor;

-(void)setNavBarStatus:(JuNavBarStatus)status;


-(UIBarButtonItem *)juNavBarSpacer;
-(void)juNavBarRightItemsWithSpacer;

@end

NS_ASSUME_NONNULL_END
