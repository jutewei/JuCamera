//
//  PABaseNavigationC.m
//  PABase
//
//  Created by Juvid on 2021/4/19.
//

#import "PABaseNavigationC.h"
#import "UIColor+image.h"
#import "JuNavigationBar.h"
#import "UIViewController+action.h"

@interface PABaseNavigationC ()<UIGestureRecognizerDelegate>{
    BOOL isSetBar;
}

@end

@implementation PABaseNavigationC

-(id)initWithRootViewController:(UIViewController *)rootViewController{
    self=[super initWithRootViewController:rootViewController];
    if (self) {
        self.modalPresentationStyle=UIModalPresentationFullScreen;
        [self zlSetConfig];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self zlSetConfig];
}

-(void)zlSetConfig{
    
    if (isSetBar) return;
    isSetBar=YES;
    [self setValue:[JuNavigationBar new] forKey:@"navigationBar"];
    [[UINavigationBar appearance]setBarTintColor:JUColor_DarkWhite];
    self.interactivePopGestureRecognizer.delegate=self;
    self.navigationBar.translucent = YES;///< 不透明
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: JUColor_BlackBlack, NSFontAttributeName:JUFont_NaviTitleM};
    self.view.backgroundColor=JUColor_ContentWhite;

//        [self.navigationBar setShadowImage:[UIImage new]];
    [self.navigationBar setBackgroundImage:[[UIColor clearColor] juImageSize:CGSizeMake(Screen_Width, 64)]   forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIColor clearColor] juImageSize:CGSizeMake(Screen_Width, 0.3)]];

//        (使用下面这个方法，在iOS11下，系统导航栏的返回按钮会向下偏移,例：聊天选择本地图片)
    if(!IOS_MAX_VERSION(11)){
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

+(instancetype)zlBasicNation:(UIViewController *)rootViewController{
    PABaseNavigationC *basicNatcon=[[self alloc]initWithRootViewController:rootViewController];
    return basicNatcon;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {

    BOOL canPan = !Ju_Share.topViewcontrol.isUnablePanBack;
//    Ju_Share.topViewcontrol.isUnablePanBack==0;
    /**
     *  这里有两个条件不允许手势执行，1、当前控制器为根控制器；2、如果这个push、pop动画正在执行（私有属性）
     */
    BOOL isCanBack=self.viewControllers.count != 1 && ![[self valueForKey:@"_isTransitioning"] boolValue]  && canPan;
    return isCanBack;
}
/**
 屏幕旋转控制
 */
-(BOOL)shouldAutorotate{
    return [self.topViewController shouldAutorotate];
}
///< 只能写topViewController或者viewControllers.lastObject，visibleViewController会导致返回与设置不一样
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    //    NSLog(@"可用的：%@ 最顶层的：%@ 最后一个：%@",self.topViewController,self.visibleViewController,self.viewControllers.lastObject);
    return [self.topViewController supportedInterfaceOrientations];
}

/**
 状态栏颜色控制
 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.topViewController preferredStatusBarStyle];
}
-(BOOL)prefersStatusBarHidden{
    return NO;
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
