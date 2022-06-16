//
//  PABaseTabBarC.m
//  PABase
//
//  Created by Juvid on 2021/4/19.
//

#import "PABaseTabBarC.h"
#import "PABaseScrollVC.h"
#import "UIColor+image.h"

@interface PABaseTabBarC ()

@end

@implementation PABaseTabBarC

-(id)init{
    self=[super init];
    if (self){
//        [self setValue:[[MTTabBar alloc] init] forKey:@"tabBar"];
        self.tabBar.translucent=NO;
        [self zlInitViewControllers];
        [self zlSetBarStyle];
    }
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];
}
-(void)zlInitViewControllers{}

-(void)zlSetBarStyle{
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance* tabBarAppearance = self.tabBar.standardAppearance;
        [tabBarAppearance.stackedLayoutAppearance.normal setTitleTextAttributes:@{
                          NSForegroundColorAttributeName:JUDarkColorHex(0x888888),
                          NSFontAttributeName:[UIFont systemFontOfSize:10]}];
        [tabBarAppearance.stackedLayoutAppearance.selected setTitleTextAttributes:@{
                          NSForegroundColorAttributeName:PAColor_MainColor,
                          NSFontAttributeName:[UIFont systemFontOfSize:10]}];
        tabBarAppearance.backgroundImage = [JUColor_ContentWhite juImageSize:CGSizeMake(Screen_Width, 48)];
        tabBarAppearance.shadowImage = [JUDarkColorHex(0xeeeeee) juImageSize:CGSizeMake(Screen_Width, 0.5)];
        self.tabBar.standardAppearance = tabBarAppearance;
    }else{
        self.tabBar.shadowImage = [JUDarkColorHex(0xeeeeee) juImageSize:CGSizeMake(Screen_Width, 0.5)];
        self.tabBar.backgroundImage = [[JUColor_ContentWhite juImageSize:CGSizeMake(Screen_Width, 48)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        for (UIViewController *vc in self.viewControllers) {
            [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:JUDarkColorHex(0x888888),
                                                            NSFontAttributeName:[UIFont systemFontOfSize:10]
                                                            }
                                                 forState:UIControlStateNormal];
            [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:PAColor_MainColor,
                                                            NSFontAttributeName:[UIFont systemFontOfSize:10]
                                                            }
                                                 forState:UIControlStateSelected];
        }
 
    }
}
-(BOOL)shouldAutorotate{
    return [self.selectedViewController shouldAutorotate];
}
///< 只能写topViewController或者viewControllers.lastObject，visibleViewController会导致返回与设置不一样
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.selectedViewController supportedInterfaceOrientations];
}
-(BOOL)prefersStatusBarHidden{
    return NO;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    [self checkIsDoubleClick:viewController];
}

- (void)checkIsDoubleClick:(UIViewController *)viewController{
    static NSInteger lastSelectIndex = 0;
    static NSTimeInterval lastClickTime = 0;
    static JuTabbarClick clickTpye = 0;
    if (lastSelectIndex != self.selectedIndex) {//tabbar切换时
        lastSelectIndex = self.selectedIndex;
        lastClickTime = [NSDate timeIntervalSinceReferenceDate];
        clickTpye= ZLTabbarClickNone;
        return ;
    }
    NSTimeInterval clickTime = [NSDate timeIntervalSinceReferenceDate];
    if (clickTime - lastClickTime > 0.3 ) {///< 两次时间间隔 第一次和上一次比较（单击）
        lastClickTime = clickTime;
        clickTpye= ZLTabbarClickSingle;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.31 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (clickTpye==ZLTabbarClickSingle) {
                [self juClickHandle:viewController withType:clickTpye];
            }
        });
        return;
    }
    //双击
    lastClickTime = clickTime;

    if (clickTpye==ZLTabbarClickDouble) {///< 防止多次双击
        return;
    }
    clickTpye= ZLTabbarClickDouble;

    [self juClickHandle:viewController withType:clickTpye];

}

-(void)juClickHandle:(UIViewController *)viewController withType:(JuTabbarClick )clickType{
    PABaseScrollVC *vc=(PABaseScrollVC *)[(UINavigationController*)viewController topViewController];
    if ([vc isKindOfClass:[PABaseScrollVC class]]) {
        [vc zlScrollTop:clickType==ZLTabbarClickDouble];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
