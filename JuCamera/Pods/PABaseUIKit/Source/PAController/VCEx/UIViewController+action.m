//
//  UIViewController+JuAction.m
//  PABase
//
//  Created by Juvid on 2017/8/23.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import "UIViewController+action.h"
#import "PABaseNavigationC.h"
#import "PABaseVC.h"
#import "JuSharedInstance.h"
#import <objc/runtime.h>
@implementation UIViewController (action)

static const void *IsUnablePanBack = &IsUnablePanBack;

-(BOOL)isUnablePanBack{
    return [objc_getAssociatedObject(self, IsUnablePanBack) intValue];
}
-(void)setIsUnablePanBack:(BOOL)isUnablePanBack{
    NSNumber *number = [[NSNumber alloc] initWithBool:isUnablePanBack];
    objc_setAssociatedObject(self, IsUnablePanBack, number, OBJC_ASSOCIATION_COPY);
}

-(BOOL)isPreviewPush{
    return [objc_getAssociatedObject(self,@selector(isPreviewPush)) intValue];
}

-(void)setIsPreviewPush:(BOOL)isPreviewPush{
    objc_setAssociatedObject(self, @selector(isPreviewPush),[NSNumber numberWithBool:isPreviewPush], OBJC_ASSOCIATION_COPY);
}

#pragma mark 跳转控制器

/**获取PAUser其中控制器*/
+(id)juInitMainStoryVC{
    return [self juInitStory:@"Main"];
}

+(instancetype)juInitStory:(NSString *)storyStr{
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:storyStr bundle:nil];
    UIViewController* vc = [secondStoryBoard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];  //
    [vc juHideTabbarOnPush];
    return vc;
}
/**获取通用其中控制器*/
+(instancetype)juInitStoryVC:(NSString *)storyStr withVC:(NSString *)vcStr{
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:storyStr bundle:nil];
    UIViewController* vc = [secondStoryBoard instantiateViewControllerWithIdentifier:vcStr];  //
    [vc juHideTabbarOnPush];
    return vc;
}
+(id)juInitStrClass:(NSString *)vcStr{
    return [[NSClassFromString(vcStr) alloc]init];
}
-(void)juPushVCClassSring:(NSString *)clsStr{
    UIViewController *vc=[[NSClassFromString(clsStr) alloc]init];
    [self juPushViewController:vc];
}
/**push新控制器*/
-(void)juPushViewController:(UIViewController *)viewController{
    if (!viewController)  return;
    UIViewController *topViewcontrol=Ju_Share.topViewcontrol;
    if ([[viewController class] isMemberOfClass:[topViewcontrol class]]) {
        if ([Ju_Share.topViewcontrol isKindOfClass:[PABaseVC class]]) {///跳转相同页面刷新顶部视图内容
            PABaseVC *vc=(id)Ju_Share.topViewcontrol;
            [vc zlGetBaseData];
        }
    }else{
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

-(void)juPushNewViewController:(UIViewController *)viewController{
    if (!viewController)  return;
    viewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

/**退出一个新的导航栏控制器*/
-(void)juPresentWithNCV:(UIViewController*)viewController{
    [self juPresentWithNCV:viewController animated:YES];
}

-(void)juPresentWithNCV:(UIViewController*)viewController animated:(BOOL)animated{
    if (![[viewController class]isEqual:[Ju_Share.topViewcontrol class]]) {
        Class class=NSClassFromString(@"PABaseNavigationC");
        PABaseNavigationC *nav=[class?class:[PABaseNavigationC class] zlBasicNation:viewController];
        nav.modalPresentationStyle=UIModalPresentationFullScreen;
        if (self.navigationController) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController presentViewController:nav animated:animated completion:nil];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:nav animated:animated completion:nil];
            });
        }
    }
}

-(void)juRootReturn:(UIViewController *)control{
    if (control) {
        [self.navigationController popToViewController:control animated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)juPopViewController:(BOOL)animated completion:(void (^)(void))completion{
    if (self.parentViewController.childViewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:animated];
        if (completion)   completion();
    }else{
        [self dismissViewControllerAnimated:animated completion:completion];
    }
}

-(void)juDismissViewController:(BOOL)animated completion:(void (^)(void))completion{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:animated completion:completion];
    }else{
        [self.navigationController popToRootViewControllerAnimated:animated];
         if (completion)   completion();
    }
}

/*返回指定控制器*/
-(id)juPopControl:(NSString *)strControl{
    for (int i = 0; i < self.navigationController.viewControllers.count; i++) {
        UIViewController *vc = self.navigationController.viewControllers[i];
        if ([NSStringFromClass([vc class]) isEqualToString:strControl]) {
            [self.navigationController popToViewController:vc animated:true];
            return vc;
        }
    }
    return nil;
}
/*返回某一类控制器（继承控制器的基类）*/
-(id)juPopControlClass:(NSString *)strControl{
    for (int i = 0; i < self.navigationController.viewControllers.count; i++) {
        UIViewController *vc = self.navigationController.viewControllers[i];
        if ([vc isKindOfClass:[NSClassFromString(strControl) class]]) {
            [self.navigationController popToViewController:vc animated:true];
            return vc;
        }
    }
    return nil;
}
/*返回指定控制器然后push到另一个控制器*/
-(id)juPopControlClsStr:(NSString *)popClsStr pushVC:(UIViewController *)pushVc{
    if (!pushVc) {
        return [self juPopControl:popClsStr];
    }
    NSMutableArray *arrVC=[NSMutableArray array];
    UINavigationController *nav=self.navigationController;
    for (int i = 0; i < nav.viewControllers.count; i++) {
        UIViewController *vc = nav.viewControllers[i];
        [arrVC addObject:vc];
        if ([NSStringFromClass([vc class]) isEqualToString:popClsStr]) {
            [Ju_Share.topViewcontrol juPushViewController:pushVc];
            [arrVC addObject:pushVc];
            juDis_mian_after(1, ^{
                nav.viewControllers=arrVC;
            });
            return vc;
        }
    }
    return nil;
}

-(void)juRemoveSelfFromNavigationVC{
    [self juRemoveVc:self];
}

-(void)juRemoveVc:(UIViewController *)vc{
    UINavigationController *nav=vc.navigationController;
    juDis_mian_after(0.5, ^{
        NSMutableArray *vcList=[nav.viewControllers mutableCopy];
        [vcList removeObject:vc];
        [nav setViewControllers:vcList animated:NO];
    });
}

-(void)juRemoveVclassStr:(NSArray *)removeList{
    UINavigationController *nav=self.navigationController;
    juDis_mian_after(0.5, ^{
        NSMutableArray *vcList=[nav.viewControllers mutableCopy];
        NSMutableArray *arrMoveVc=[NSMutableArray array];
        for (UIViewController *vc in vcList) {
            if ([removeList containsObject:NSStringFromClass([vc class])]) {
                [arrMoveVc addObject:vc];
            }
        }
        [vcList removeObjectsInArray:arrMoveVc];
        nav.viewControllers=vcList;
    });
}

/**判断是否某个VC class**/
-(BOOL)isClassString:(NSString *)string{
    return ![NSStringFromClass([self class]) isEqualToString:string];
}
-(void)juHideTabbarOnPush{
    if([Ju_Share.topViewcontrol.parentViewController.parentViewController isKindOfClass:[UITabBarController class]]&&Ju_Share.topViewcontrol.parentViewController.childViewControllers.count>0){
        self.hidesBottomBarWhenPushed = YES;
    }
}


/**
 强制屏幕旋转
 */
-(void)juSetOrientation:(UIDeviceOrientation)orientation{

    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    UIDeviceOrientation val = orientation;
    [invocation setArgument:&val atIndex:2];//前两个参数已被target和selector占用
    [invocation invoke];

}
@end
