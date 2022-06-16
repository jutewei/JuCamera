//
//  UIViewController+JuAction.h
//  PABase
//
//  Created by Juvid on 2017/8/23.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Hud.h"
//#import "UIViewController+style.h"
@interface UIViewController (action)

@property  BOOL isUnablePanBack;
@property (nonatomic,assign) BOOL isPreviewPush;///< 按压使用

/**获取PFBUser其中控制器*/
+(id)juInitMainStoryVC;

+(instancetype)juInitStory:(NSString *)storyStr;
/**获取通用其中控制器*/
+(instancetype)juInitStoryVC:(NSString *)storyStr withVC:(NSString *)vcStr;
/**字符转控制器*/
+(id)juInitStrClass:(NSString *)vcStr;

-(void)juPushVCClassSring:(NSString *)clsStr;
/**push新控制器*/
-(void)juPushViewController:(UIViewController *)viewController;
/**push新控制器控制器可以和顶部控制器同一个类型*/
-(void)juPushNewViewController:(UIViewController *)viewController;
/**退出一个新的导航栏控制器*/
-(void)juPresentWithNCV:(UIViewController*)viewControlle;
-(void)juPresentWithNCV:(UIViewController*)viewController animated:(BOOL)animated;

-(void)juPopViewController:(BOOL)animated completion:(void (^)(void))completion;

-(void)juDismissViewController:(BOOL)animated completion:(void (^)(void))completion;
/*返回指定控制器*/
-(id)juPopControl:(NSString *)strControl;
/*返回指定控制器（继承控制器的基类）*/
-(id)juPopControlClass:(NSString *)strControl;

-(void)juRootReturn:(id)control;/**返回根控制器*/

/*返回指定控制器然后push到另一个控制器*/
-(id)juPopControlClsStr:(NSString *)popClsStr pushVC:(UIViewController *)pushVc;

-(void)juRemoveSelfFromNavigationVC;///< 移除自己
/**
 移除单个控制器

 @param vc 控制器
 */
-(void)juRemoveVc:(UIViewController *)vc;

/**
 移除一组不用的控制器

 @param arrList 控制器字符
 */
-(void)juRemoveVclassStr:(NSArray *)arrList;


-(BOOL)isClassString:(NSString *)string;

/**隐藏tabbar*/
-(void)juHideTabbarOnPush;



-(void)juSetOrientation:(UIDeviceOrientation)orientation;

@end
