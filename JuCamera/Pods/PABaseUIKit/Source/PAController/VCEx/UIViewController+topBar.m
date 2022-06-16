//
//  UIViewController+topBar.m
//  PABase
//
//  Created by Juvid on 2019/12/12.
//  Copyright © 2019 Juvid. All rights reserved.
//

#import "UIViewController+topBar.h"
#import <objc/runtime.h>
//#import "UIImage+drawImage.h"
@implementation UIViewController (topBar)

-(void)setJu_styleManage:(JuTopBarManage *)ju_styleManage{
    objc_setAssociatedObject(self,@selector(ju_styleManage), ju_styleManage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(JuTopBarManage *)ju_styleManage{
    if (!objc_getAssociatedObject(self,@selector(ju_styleManage))) {
        self.ju_styleManage=[[JuTopBarManage alloc]init];
    }
    return objc_getAssociatedObject(self,@selector(ju_styleManage));
}
-(JuNavBarStatus)ju_barStatus{
    return self.ju_styleManage.zl_barStatus;
}

-(void)juSetBackItem{
    if (!self.ju_styleManage.isHideBackButton&&[self.parentViewController isKindOfClass:[UINavigationController class]]) {///隐藏返回按钮
        if (self.parentViewController.childViewControllers.count>1) {
            [self setBarLeftItem:[UIImage imageNamed:self.ju_styleManage.zl_barLeftImage]];
        }
        else{
            if (self.presentingViewController) {/// 上一级model控制器
                [self setBarLeftItem:[UIImage imageNamed:self.ju_styleManage.zl_barCloseImage]];
            }
        }
    }
}

-(void)juSetAndAddTopBar:(BOOL)isReset{
    if (isReset) {
        [self.ju_styleManage zlResetTopbar];
    }
    [self setNavBarStatus:self.ju_barStatus];
    [self.ju_styleManage zlTopBarView:self];
    [self setStatusBarIsLight:self.ju_styleManage.isLightStyle];
}
-(void)setBarAlpha:(CGFloat)barAlpha{
    self.ju_styleManage.zl_barAlpha=barAlpha;
    UILabel *titleView=(id)self.navigationItem.titleView;
    if (barAlpha<0.6) {///< 透明
        [self.ju_rightBarItem setTitleColor:self.ju_styleManage.zl_barItemColor];
        if (self.ju_leftBarItem) {
            [self.ju_leftBarItem setImageName:self.ju_styleManage.zl_barLeftLightImg];
        }
        if ([titleView isKindOfClass:[UILabel class]]) {
            titleView.textColor=self.ju_styleManage.zl_barTitleColor;
        }
    }else{///< 不透明
        if (!self.ju_styleManage.isLightStyle) {///< 状态栏未白色不切换
            [self.ju_rightBarItem setTitleColor:PAColor_Main];
            if (self.ju_leftBarItem) {
                [self.ju_leftBarItem setImageName:self.ju_styleManage.zl_barLeftLightImg];
            }
            if ([titleView isKindOfClass:[UILabel class]]) {
                titleView.textColor=JUColor_NavTitleMain;
            }
        }
    }
}

/*——————————————————单个按钮————————————————————————————*/
//导航栏自定义样式按钮
-(void )setCustomItem:(id)element left:(BOOL)isLeft{
    [self shSetItemAction:[JuBarButton juInitBarItem:element systemType:NO] isLeft:isLeft];
}
//导航栏左边按钮
-(void)setBarLeftItem:(id)element {
    if (element)  [self setBarLeftItems:@[element]];
}
//导航栏右边按钮
-(void )setBarRightItem:(id)element{
    if (element)  [self setBarRightItems:@[element]];
}

/**************多个按钮******************/
-(void)setBarLeftItems:(NSArray *)itemsName {
    self.navigationItem.leftBarButtonItems = [JuBarButton juInitBarItems:itemsName resultHandle:^(JuBarButton *button) {
        [self shSetItemAction:button isLeft:YES];
    }];
}

//导航栏多个按钮
-(void)setBarRightItems:(NSArray *)itemsName{
    self.navigationItem.rightBarButtonItems = [JuBarButton juInitBarItems:itemsName resultHandle:^(JuBarButton *button) {
        [self shSetItemAction:button isLeft:NO];
    }];
}

-(void)shSetItemAction:(JuBarButton *)button isLeft:(BOOL)isLeft{
    if (isLeft) {
        [button addTarget:self action:NSSelectorFromString(barItemActions.firstObject) forAlignment:UIControlContentHorizontalAlignmentLeft];
    }else{
        [button addTarget:self action:NSSelectorFromString(barItemActions.lastObject) forAlignment:UIControlContentHorizontalAlignmentRight];
    }
    [button setTitleColor:self.ju_styleManage.zl_barItemColor];
    button.tintColor=self.ju_styleManage.zl_barItemColor;
}

-(JuBarButton *)ju_rightBarItem{
    return self.navigationItem.rightBarButtonItems.firstObject.customView;
}
-(JuBarButton *)ju_leftBarItem{
    return self.navigationItem.leftBarButtonItems.firstObject.customView;
}



-(void)setNavBarStatus:(JuNavBarStatus)status{
    [self setNavitationBarIsHide:status==JuNavBarStatusHidden];

    if (status==JuNavBarStatusHidden)return;

    if (status==JuNavBarStatusNone) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
        return;
    }
    self.edgesForExtendedLayout=UIRectEdgeAll;
    self.navigationController.navigationBar.translucent = YES;
    
    if (status==JuNavBarStatusTranslucent) {

    }else{
    }

    if (status==JuNavBarStatusClear) {
        self.automaticallyAdjustsScrollViewInsets=NO;
    }

}

/**是否显示导航栏*/
-(void)setNavitationBarIsHide:(BOOL)isHide{
    if (isHide) {
        if (self.navigationController.navigationBarHidden==NO) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }else{
        if (self.navigationController.navigationBarHidden==YES) {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
    }
}
-(void)setStatusBarIsLight:(BOOL)isLight{
    [self setNeedsStatusBarAppearanceUpdate];
}

-(UIBarButtonItem *)juNavBarSpacer{
    UIBarButtonItem *juBarSpacer = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                     target:nil action:nil];
    juBarSpacer.width = -4;
    return juBarSpacer;
}

-(void)juNavBarRightItemsWithSpacer{
    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:self.juNavBarSpacer];
    if (self.navigationItem.rightBarButtonItem) {
        [arr addObject:self.navigationItem.rightBarButtonItem];
    }
    self.navigationItem.rightBarButtonItems=arr;
}
@end
