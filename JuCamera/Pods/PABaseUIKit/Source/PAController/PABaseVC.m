//
//  PABaseViewC.m
//  PABase
//
//  Created by Juvid on 2021/4/19.
//

#import "PABaseVC.h"
#import "PABaseNavigationC.h"

@interface PABaseVC ()

@end

@implementation PABaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self zlSetManageConfig];
    [self.navigationItem setHidesBackButton:YES];
    self.view.backgroundColor=JUColor_ContentWhite;
    [self juSetBackItem];
    [self parentIsNavitionVC];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [Ju_Share juNotificationOff:NO];///< 远程通知开关提示
//    [JuUmeng juBeginLoadPage:sh_barTitle]; ///< 友盟统计
    [self zlSetTopBarStyle];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [JuUmeng juEndDisPage:sh_barTitle];///< 友盟统计
    [self.view endEditing:YES];
    self.navigationItem.backBarButtonItem.title=@"";
}

- (void)zlGetBaseData{}

- (void)zlAppBecomeActive{}

-(void)zlSetManageConfig{
//    self.ju_styleManage=[[JuTopBarManage alloc]init];
    self.ju_styleManage.zl_barStatus=JuNavBarStatusNone;
}

-(void)zlSetTopBarStyle{
    if (![self parentIsNavitionVC]) return;
//    添加自定义导航栏
    [self juSetAndAddTopBar:NO];
}

-(BOOL)parentIsNavitionVC{
    if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
        PABaseNavigationC *nav=(id)self.parentViewController;
        if (![nav isKindOfClass:[PABaseNavigationC class]]||!nav.isPreviewPush) {
            Ju_Share.topViewcontrol=(id)self;
        }
        return YES;
    }
    return NO;
}
//自定义natigationitem标题
-(void)setTitle:(NSString *)title{
    if (self.ju_barStatus>=JuNavBarStatusSpecially) {
        if (title.length) {
            UILabel *labTitleView=self.ju_styleManage.titleView;
            labTitleView.text=title;
            labTitleView.adjustsFontSizeToFitWidth = YES;
            labTitleView.minimumScaleFactor =0.6;
            self.navigationItem.titleView=labTitleView;
        }
        else{
            self.navigationItem.titleView=nil;
        }
    }else{
        self.navigationItem.title=title;
    }
    _zl_barTitle=title;
}

//导航栏左边按钮事件
-(void)zlTouchLeftItems:(UIButton *)sender{
    if (![self isMemberOfClass:[PABaseNavigationC class]]) {
        [self juPopViewController:YES completion:nil];
    }
}

//导航栏右边按钮事件
-(void)zlTouchRightItems:(UIButton *)sender{
    if (![self isMemberOfClass:[PABaseNavigationC class]]) {
        // 如果是通过BaseViewController子类的实例调用了此处的RightReturn，则抛出一个异常：表明子类并没有重写RightReturn方法。
        // 注：在OC中并没有abstract class的概念，只有protocol，如果在基类中只定义接口(没有具体方法的实现)，
        //    则可以使用protocol，这样会更方便。
        [NSException raise:NSInternalInconsistencyException
                    format:BV_Exception_Format, [NSString stringWithUTF8String:object_getClassName(self)], NSStringFromSelector(_cmd)];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)zlReloadNetData{
    [self zlGetBaseData];
}
-(void)zlNoDataStatusHandle{
    [self zlTouchLeftItems:nil];
}

-(BOOL)shouldAutorotate{
    return YES;
}
///< 只能写topViewController或者viewControllers.lastObject，visibleViewController会导致返回与设置不一样
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
#pragma mark - 屏幕翻转就会调用
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
//    CGFloat duration = [coordinator transitionDuration];
    if ([self isEqual:Ju_Share.topViewcontrol]) {
       [self.ju_styleManage.zl_topBarView juViewWillTransitionToSize:size];
    }
}
-(BOOL)prefersStatusBarHidden{
    return NO;
}

//状态栏颜色 ios9以后
- (UIStatusBarStyle)preferredStatusBarStyle{
    return self.ju_styleManage.isLightStyle?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ 释放了",self);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
////如果需要传参直接在参数列表后面添加就好了
/*void dynamicBaseVCIMP(id self, SEL _cmd, id name) {
    NSString *method = NSStringFromSelector(_cmd);
    NSLog(@"%@ %@ %@",self ,method ,name);
}

+ (BOOL)resolveInstanceMethod:(SEL)name {
    return [super resolveInstanceMethod:name];
}

+ (BOOL)resolveClassMethod:(SEL)name {
    [super resolveClassMethod:name];
    class_addMethod(object_getClass(self), name, (IMP)dynamicBaseVCIMP, "v@:");
    return YES;
}

- (id)forwardingTargetForSelector:(SEL)aSelector{
    NSString *method = NSStringFromSelector(aSelector);
    NSLog(@"未找到的方法 %@ %@",self,method);
    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    return [super methodSignatureForSelector:@selector(noMethodDeal:)];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
#ifdef DEBUG
    // 从继承树中查找
    [super forwardInvocation:anInvocation];
#else
    SEL sel = @selector(noMethodDeal:);
    [anInvocation setTarget:self];
    [anInvocation setSelector:sel];
    NSString *city = @"baseVC";
    // 消息的第一个参数是self，第二个参数是选择子，所以"北京"是第三个参数
    [anInvocation setArgument:&city atIndex:2];
    [anInvocation invokeWithTarget:self];
#endif
}
// 完整的消息转发
- (void)noMethodDeal:(NSString*)city{
    NSLog(@"crash class：%@", city);
}*/
@end
