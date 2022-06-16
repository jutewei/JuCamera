//
//  PABaseScrollVC.m
//  PABase
//
//  Created by Juvid on 2021/4/19.
//

#import "PABaseScrollVC.h"
#import "PABaseNavigationC.h"
#import "PABaseScrollView.h"
#import "NSObject+JuEasy.h"

@interface PABaseScrollVC ()

@end

@implementation PABaseScrollVC

@synthesize zl_scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self zlSetScrollView];
    if (self.zl_scrollView) {
        self.zl_scrollView.delegate=self;
    }
//    if (self.ju_styleManage.zl_barStatus==JuNavBarStatusLarge) {
//        self.ju_styleManage.zl_largeTitleHeight=10.0;
//        self.zl_scrollView.contentInset=UIEdgeInsetsMake(self.zlInsetTop, 0, 0, 0);
//    }
    [self zlSetResultHandle];
    [self zlSetHeadView];
    [self zlSetFootView];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.ju_barStatus==JuNavBarStatusClear||self.ju_barStatus==JuNavBarStatusHidden) {///< 透明导航栏
        if (@available(iOS 11.0, *)) {
            zl_scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
}

-(CGFloat)zlInsetTop{
    return self.ju_styleManage.zl_largeTitleHeight;
}

-(void)zlSetScrollView{
    if (!zl_scrollView) {
        UIScrollView *scrollview=[[PABaseScrollView alloc]init];
        [self.view addSubview:scrollview];
        [self zlSetContentFrame:scrollview];
        zl_scrollView=scrollview;
    }
    zl_scrollView.bounces=YES;
}

-(void)zlReloadNetData{
    if (_zl_refeshType) {
         [self zlStartRefresh];
    }else{
        [self zlGetBaseData];
    }
}

-(void)setTitle:(NSString *)title{
    [super setTitle:title];
    [self scrollViewDidScroll:zl_scrollView];
}
#pragma mark 请求数据
-(void)zlGetBaseData{
    [self zlGetListData:YES];
}

// 分页
-(void)zlGetListData:(BOOL)isFristPage{
    self.zl_pageSize.zl_isFirstPage=isFristPage;
}
//改变导航栏颜色
-(void)zlChangNavBarColor:(CGFloat)alpha{
    CGFloat minAlpha=MIN(alpha,1);
    self.barAlpha=minAlpha;
    [self setStatusBarIsLight:self.ju_styleManage.isLightStyle];
}

#pragma mark 下拉刷新与上拉加载
-(void)setZl_refeshType:(JuRefreshType)ju_refeshType{
    _zl_refeshType=ju_refeshType;
    
    if (_zl_refeshType!=JuRefreshTypeHide) {
        [self juSetDataHint:(_zl_refeshType==JuRefreshTypeMore)];
    }
    CGFloat space=0;
    if (self.ju_styleManage.zl_barStatus==JuNavBarStatusHidden&&IPhoneXstatusBar>0) {
        space=20;
    }
    WeakSelf
    [zl_scrollView juSetRefeshType:ju_refeshType topSpace:space head:^{
        [weakSelf zlGetBaseData];
    } foot:^(BOOL isNextPage) {
        if (isNextPage) weakSelf.zl_pageSize.zl_pageNum++;
        [weakSelf zlGetListData:NO];
    }];

}

-(void)zlStartRefresh{
    self.zl_scrollView.ju_RefreshHead.hidden=NO;
    if (_zl_refeshType>0) {
        [zl_scrollView.ju_RefreshHead juStartRefresh];
    }
}

-(BOOL)isNotUseCache{
    return self.zl_mArrList.count;
}

-(void)zlScrollTop:(BOOL)isDouble{
    [zl_scrollView zlScrollTop:isDouble];
}

//topBar 相关控制
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.ju_styleManage.zl_changeBarPoint>0) {
        if (self.ju_barStatus==JuNavBarStatusHidden) {
            [self zlChangNavBarColor:scrollView.contentOffset.y>self.ju_styleManage.zl_changeBarPoint?1:0];
        }
        else if(self.ju_barStatus==JuNavBarStatusClear){
            [self zlChangNavBarColor:scrollView.contentOffset.y/self.ju_styleManage.zl_changeBarPoint];
        }
    }
//    else if(self.ju_barStatus==JuNavBarStatusLarge){
//        if (self.ju_styleManage.zl_topEdgeView) {
//            self.ju_styleManage.zl_topEdgeView.ju_Height.constant=MAX(-scrollView.contentOffset.y, 0);
//        }
//        if (scrollView.contentOffset.y>-(NavBar_Height+self.zlInsetTop+10)&&scrollView.contentOffset.y<0) {///显示与隐藏区域
//            self.navigationItem.titleView.hidden=[self.ju_styleManage.zl_topBarView.ju_largeView scrollViewDidScroll:scrollView];
//        }
//    }
}

-(NSMutableArray *)zl_mArrList{
    return self.zl_baseVMData.zl_mArrList;
}
-(void)setZl_data:(id)zl_data{
    self.zl_baseVMData.zl_data=zl_data;
    self.zl_dataResult(nil);
}
//分页处理
-(void)setZl_mArrList:(NSMutableArray *)zl_mArrList{
    [self.zl_baseVMData setArrList:zl_mArrList isPage:_zl_refeshType==JuRefreshTypeMore];
    JuLoadStatus status=JuLoadStatusSuccess;
    if (zl_mArrList.count<self.zl_pageSize.zl_pageSize) {///< 判断是否最后一页
        status=JuLoadStatusFinish;
    }
    [self zlLoadFinishStatus:status];
}


//成功失败回调
-(void)zlSetResultHandle{
    WeakSelf
    self.zl_dataResult = ^(id error) {
        [weakSelf zlLoadFinishStatus:error?JuLoadStatusFailure:JuLoadStatusSuccess];
    };
}

#pragma mark 上拉加载更多停止
/**网络请求结束**/
-(void)zlLoadFinishStatus:(JuLoadStatus)status{
    if (self.isViewLoaded&&zl_scrollView.ju_RefreshHead) {
        [zl_scrollView.ju_RefreshHead juEndRefresh];
    }
    if (zl_scrollView.ju_RefreshFoot) {
        [zl_scrollView.ju_RefreshFoot juLoadMoreStatus:status];
    }
    if (status==JuLoadStatusFailure) {
        self.isFailStatus=(self.zl_baseVMData.isNoData&&self.ju_dataManage.zl_showFailHint==JUShowHintTypeShow);
    }else{
        [self zlReloadData];
    }
}

-(void)zlReloadData{
    [self.zl_baseVMData zlReloadData:self.zl_scrollView];
    self.isNoDataStatus=(self.zl_baseVMData.isNoData&&self.ju_dataManage.zl_showNoDataHint==JUShowHintTypeShow);
}

//无数据显示
-(void)setIsNoDataStatus:(BOOL)isNoDataStatus{
    BOOL isNoData=(self.zl_mArrList.count==0&&self.ju_dataManage.zl_showNoDataHint==JUShowHintTypeShow);
    [self zlSetStatusView:isNoData?JUDataLoadStatusNoData:JUDataLoadStatusNormal];
}
//加载失败显示
-(void)setIsFailStatus:(BOOL)isFailStatus{
    BOOL isNoData=isFailStatus;
    [self zlSetStatusView:isNoData?JUDataLoadStatusFail:JUDataLoadStatusNormal];
}

-(void)zlSetStatusView:(JUDataLoadStatus)status{
    __weak typeof(self) weakSelf=self;
    [self juAddStatusView:^(NSInteger type) {
        if (type==1) {///< 返回
            [weakSelf zlNoDataStatusHandle];
        }else{///<重新加载
            [weakSelf zlReloadNetData];
        }
    } status:status];
}

-(JuBaseDataVM *)zl_baseVMData{
    if (!_zl_baseVMData) {
        _zl_baseVMData=[[self zlVMDataClass] zlInitWithContentView:zl_scrollView];
    }
    return _zl_baseVMData;
}

-(PAPageModel *)zl_pageSize{
    return self.zl_baseVMData.zl_pageSize;
}


-(void)zlSetHeadView{}
-(void)zlSetFootView{}

-(UIView *)zlInitFootView:(BOOL)isAbsolute height:(CGFloat)height{
    UIView *footView=[[UIView alloc]init];
    if (isAbsolute) {
        [self.view addSubview:footView];
        zl_scrollView.juBottom.safe.equal(height);
        footView.juSafeFrame(CGRectMake(0, -.01, 0, height));
    }else if([zl_scrollView isKindOfClass:[UITableView class]]){
        footView.frame=CGRectMake(0, 0, 0, height);
        ((UITableView *)zl_scrollView).tableFooterView=footView;
    }
    return footView;
}

-(void)zlSetContentFrame:(UIView *)view{
    view.juEdge(UIEdgeInsetsMake(0, 0, 0, 0));
}

-(Class)zlVMDataClass{
    return JuBaseDataVM.class;
}
/*
//3D touch(暂未使用)
-(void)setRegisterPreviewingView:(UIView *)view{
    if (IOS_MAX_VERSION(9)&&self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        //给cell注册3DTouch的peek（预览）和pop功能
        if (view.payloadSelect==0) {
            [self registerForPreviewingWithDelegate:self sourceView:view];
            view.payloadSelect=1;
        }
    }
}

-(PABaseVC *)zlPreviewVC:(id <UIViewControllerPreviewing>)previewingContext{
    return nil;
}

//pop（按用点力进入视图）
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    UIViewController *showVC=viewControllerToCommit;
    if ([viewControllerToCommit isKindOfClass:[UINavigationController class]]&&viewControllerToCommit.childViewControllers.count) {
        showVC=viewControllerToCommit.childViewControllers.firstObject;
        viewControllerToCommit=nil;
    }
    [self showViewController:showVC sender:self];
}

//peek(预览)
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    //获取按压的cell所在行，[previewingContext sourceView]就是按压的那个视图
    //设定预览的界面
    PABaseVC *vc = [self zlPreviewVC:previewingContext];
    vc.isPreviewPush=YES;
    vc.hidesBottomBarWhenPushed = YES;
    //    webViewVC.preferredContentSize = CGSizeMake(0.0f,0.0f);
    PABaseNavigationC *navc=[PABaseNavigationC zlBasicNation:vc];
    navc.isPreviewPush=YES;
    //调整不被虚化的范围，按压的那个cell不被虚化（轻轻按压时周边会被虚化，再少用力展示预览，再加力跳页至设定界面）
    //    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width,120);
    //    previewingContext.sourceRect = rect;
    //返回预览界面
    return navc;
}
*/
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
