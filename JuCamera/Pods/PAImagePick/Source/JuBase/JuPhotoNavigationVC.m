//
//  TestViewController.m
//  PAImagePick
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/7/16.
//

#import "JuPhotoNavigationVC.h"
#import "UIImage+drawImage.h"

@interface JuPhotoNavigationVC ()<UIGestureRecognizerDelegate>

@end

@implementation JuPhotoNavigationVC


-(id)initWithRootViewController:(UIViewController *)rootViewController{
    self=[super initWithRootViewController:rootViewController];
    if (self) {
        self.modalPresentationStyle=UIModalPresentationFullScreen;
        self.interactivePopGestureRecognizer.delegate=self;
//        self.navigationBar.translucent = YES;///< 不透明
//        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: JUColor_BlackBlack, NSFontAttributeName:JUFont_NaviTitleM};
//        (使用下面这个方法，在iOS11下，系统导航栏的返回按钮会向下偏移,例：聊天选择本地图片)
    }
    return self;
}

-(void)setBarColor:(UIColor *)color{
    [self.navigationBar setBackgroundImage:[UIImage juImageWithColor:color size:CGSizeMake(375, 64)]   forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage juImageWithColor:color size:CGSizeMake(375, 0.3)]];
}

+(instancetype)juBasicNation:(UIViewController *)rootViewController{
    JuPhotoNavigationVC *basicNatcon=[[self alloc]initWithRootViewController:rootViewController];
    return basicNatcon;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.interactivePopGestureRecognizer.delegate=self;

    // Do any additional setup after loading the view.
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return [self.topViewController preferredStatusBarStyle];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    BOOL canPan = YES;
    BOOL isCanBack=self.viewControllers.count != 1 && ![[self valueForKey:@"_isTransitioning"] boolValue]  && canPan;
    return isCanBack;
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
