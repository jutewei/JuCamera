//
//  JuLargeimageVC.m
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuImagePreviewVC.h"

#import "JuLayoutFrame.h"
#import "JuAnimated.h"
#import "JuImageObject.h"
#import "JuFullWindow.h"
@interface JuImagePreviewVC ()<UIViewControllerTransitioningDelegate>

@property (nonatomic,strong) JuAnimated *ju_animator;

@property (nonatomic,copy) JuHandle ju_handle;

@property (nonatomic,assign) BOOL isHidderStatus;

@end

@implementation JuImagePreviewVC

-(instancetype)init{
    self=[super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.transitioningDelegate = self;//转场管理者
        _ju_imgCollectView=[[JuImagePreView alloc]init];
    }
    return self;
}

- (JuAnimated *)ju_animator {
    if (!_ju_animator) {
        _ju_animator = [[JuAnimated alloc] init];
    }
    return _ju_animator;
}

+(instancetype)initRect:(CGRect)frame images:(NSArray *)arrList cIndex:(NSInteger)index handle:(JuHandle)handle{
    return [self initRect:frame images:arrList  cIndex:index thumbSize:0 handle:handle];
}

+(instancetype)initRect:(CGRect)frame images:(NSArray *)arrList  cIndex:(NSInteger)index thumbSize:(CGFloat)size handle:(JuHandle)handle{
    if (arrList.count==0) {
        return nil;
    }
    JuImagePreviewVC *vc=[[self alloc]init];
    vc.ju_handle =  handle;
    [vc juSetImages:arrList thumbSize:CGSizeMake(size, size) currentIndex:index startRect:frame];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    _ju_imgCollectView.ju_delegate=self;
    _ju_imgCollectView.ju_canEdit=self.ju_canEdit;
    [self.view addSubview:_ju_imgCollectView];
    _ju_imgCollectView.juEdge(UIEdgeInsetsMake(0, 0, 0, 0));
    
}

#pragma mark JuImagePreViewDelegate
-(void)juTapHidder{
    [self juHide];
}

-(void)juChangeSacle:(CGFloat)scale{
    [self juSetBarStatus:scale];
}

/**当前显示的是第几张**/
-(void)juCurrentIndex:(NSInteger)index{
    NSLog(@"%@",@(index));
}

/**预览结束坐标*/
-(CGRect)juRectIndex:(NSInteger)index{
    if (self.ju_handle) {
        return  self.ju_handle(@(index));
    }
    return CGRectZero;
}


-(void)juShow{
    JuFullWindow *window=[JuFullWindow sharedClient];
    [window juShowWindow:self];
}
-(void)juHide{
    [[JuFullWindow sharedClient] juHideWindow];
}

-(void)juSetBarStatus:(CGFloat)scale{
    BOOL hide=scale==1;
    if (self.isHidderStatus!=hide) {
        self.isHidderStatus=hide;
        [self setNeedsStatusBarAppearanceUpdate];
        if (self.ju_scaleHandle) {
            self.ju_scaleHandle();
        }
    }
}
#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    self.ju_animator.presented = YES;
    return self.ju_animator;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    self.ju_animator.presented = NO;
    return self.ju_animator;
}
-(void)juSetImages:(NSArray *)arrList currentIndex:(NSInteger)index startRect:(CGRect)frame{

    [self juSetImages:arrList thumbSize:CGSizeZero currentIndex:index startRect:frame];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       [self juSetBarStatus:1];
    });
}
-(void)juSetImages:(NSArray *)arrList
         thumbSize:(CGSize)size
      currentIndex:(NSInteger)index
         startRect:(CGRect)frame{
    [_ju_imgCollectView juSetImages:[JuImageObject juSwithObject:arrList size:size] cIndex:index rect:frame];
    [self juCurrentIndex:index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [_ju_imgCollectView changeFrame:nil];
}
-(void)juDeleteIndex:(NSInteger)index{
    [_ju_imgCollectView juDeleteIndex:index];
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
