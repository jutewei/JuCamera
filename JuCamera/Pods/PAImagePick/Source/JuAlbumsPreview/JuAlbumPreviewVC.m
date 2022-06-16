//
//  JuAlbumPreviewVC.m
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuAlbumPreviewVC.h"
//#import "JuImagePreView.h"
#import "JuLayoutFrame.h"
//#import "JuImageObject.h"
//#import "PAEditImageVC.h"
#import "UIImage+PhotoManage.h"
#import "JuAlbumPreToolBar.h"
#import "JuAlbumPreView.h"
#import "JuAlbumManage.h"
#import "JuPhotoAlert.h"

@interface JuAlbumPreviewVC (){
    JuAlbumPreView *ju_imgCollectView;
    NSInteger currentIndex;
    UIButton *ju_rightBarItem;
    NSArray *ju_arrAllImg;
    BOOL isHideBar;
}

@property (nonatomic,copy) JuEditFinish ju_finishHandle;

@property (nonatomic,strong) JuAlbumPreToolBar *ju_toolBar;

@property (nonatomic,strong)NSMutableArray *ju_mArrSelectImg;

@property (nonatomic,assign)BOOL ju_isSelect;///容器是否是已选择的预览


//@property BOOL isPreviewBack;///< 相册选择直接预览
@end

@implementation JuAlbumPreviewVC


+(instancetype)juInitPreAll:(NSArray *)arrList
                 selectList:(NSArray *)selectList
                currentIndex:(NSInteger)index
                    finish:(JuEditFinish)haldle{
    JuAlbumPreviewVC *vc=[[JuAlbumPreviewVC alloc]init];
    [vc juSetImages:arrList currentIndex:index finish:haldle];
    vc.ju_mArrSelectImg=selectList;
    return vc;
}

+(instancetype)juInitPreSelect:(NSArray *)arrList
                  currentIndex:(NSInteger)index
                        finish:(JuEditFinish)haldle{
    JuAlbumPreviewVC *vc=[JuAlbumPreviewVC juInitPreAll:arrList selectList:arrList currentIndex:index finish:haldle];
    vc.ju_isSelect=YES;
    return vc;
}

-(instancetype)init{
    self =[super init];
    if (self) {
         ju_imgCollectView=[[JuAlbumPreView alloc]init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    ju_imgCollectView.ju_allowVideo=_ju_allowVideo;
    [self juSetRightButton];
    [self juSetCollectView];
    [self juSetToolBar];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (@available(iOS 11.0, *)) {
        ju_imgCollectView.ju_collectView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.navigationController.navigationBar.translucent = YES;///< 透明
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;///<
}

-(void)juSetCollectView{
    [self.view addSubview:ju_imgCollectView];
    ju_imgCollectView.juEdge(UIEdgeInsetsMake(0, 0, 0, 0));
    __weak typeof(self) weakSelf = self;
    ju_imgCollectView.ju_tapHandle = ^(BOOL isPlay) {
        [weakSelf juTapHideBar:isPlay];
    };

}

#pragma mark 照片代理
-(void)juTapHideBar:(BOOL)isPlay{
    isHideBar=!isHideBar;
    if (isPlay) {
        isHideBar=isPlay;
    }
    if (isHideBar) {
        _ju_toolBar.hide=isHideBar;
        [self.navigationController setNavigationBarHidden:isHideBar animated:NO];
    }else{
        _ju_toolBar.hide=isHideBar;
        [self.navigationController setNavigationBarHidden:isHideBar animated:NO];
    }
    [self setNeedsStatusBarAppearanceUpdate];
}

//导航栏右边按钮
-(void)juSetRightButton{

    UIButton *btnSelect=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 35)];
    [btnSelect setImage:juPhotoImage(@"photo_un_select") forState:UIControlStateNormal];
    [btnSelect setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnSelect setImage:juPhotoImage(@"photo_select") forState:UIControlStateSelected];
    [btnSelect addTarget:self action:@selector(juRightReturn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnSelect];
    ju_rightBarItem=btnSelect;
    [self juSetCurrentIndex:currentIndex];
    
    UIButton *btnBack=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 35)];
    [btnBack setImage:juPhotoImage(@"photo_selectBack") forState:UIControlStateNormal];
    [btnBack setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnBack addTarget:self action:@selector(juBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnBack];
}

-(void)juBack:(UIButton *)sender{
    [self juRemoveNoSelect];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)juRemoveNoSelect{
    NSMutableArray *arrCache=[NSMutableArray array];
    for (PHAsset *asset in _ju_mArrSelectImg) {
        if (!asset.isSelect) {
            [arrCache addObject:asset];
        }
    }
    [_ju_mArrSelectImg removeObjectsInArray:arrCache];
}
//底部工具栏
-(void)juSetToolBar{
    
    __weak typeof(self) weakSelf=self;
    _ju_toolBar=[[JuAlbumPreToolBar alloc]init];
    _ju_toolBar.ju_arrImage=_ju_mArrSelectImg;
    _ju_toolBar.ju_hanlleIndex = ^(NSInteger index) {
        [weakSelf juSetSelectIndex:index];
    };
    _ju_toolBar.ju_hanlleDone = ^{
        [weakSelf juTouchFinish:nil];
    };
    [self.view addSubview:_ju_toolBar];
    _ju_toolBar.juSafeFrame(CGRectMake(0, -0.01, 0, 139));
    [self juSetAllIndex];
}

-(void)juRightReturn:(UIButton *)sender{

    PHAsset *objcet=ju_arrAllImg[currentIndex];
//    if (objcet.isNetwork) {
//        [JuPhotoAlert juAlertTitle:@"该资源暂不可用" message:nil withVc:self];
//        return;
//    }
//    控制最多选择
    if(!objcet.isSelect&&self.ju_mArrSelectImg.count>=_ju_maxNumSelection){
        [JuPhotoAlert juAlertTitle:[NSString stringWithFormat:@"最多选择%@张图片",@(_ju_maxNumSelection)] message:nil withVc:self];
        return;;
    }
    
    objcet.isSelect=!objcet.isSelect;
    ju_rightBarItem.selected=objcet.isSelect;
    [_ju_toolBar setDoneCount:objcet.isSelect];
    
    if (_ju_isSelect)   return;
//        选择全部需要添加和移除
    if (objcet.isSelect) {
        [self.ju_mArrSelectImg addObject:objcet];
    }else{
        [self.ju_mArrSelectImg removeObject:objcet];
    }
    _ju_toolBar.ju_arrImage=_ju_mArrSelectImg;
    [self juSetAllIndex];
}

-(void)juSetCurrentIndex:(NSInteger)index{
    currentIndex=index;
    if (currentIndex>=ju_arrAllImg.count) {
        currentIndex=0;
    }
    PHAsset *objcet=ju_arrAllImg[currentIndex];
    ju_rightBarItem.selected=objcet.isSelect;
}

//编辑图片（未开放）
-(void)juTouchEdit:(UIButton *)sender{
    PHAsset *imageM=ju_arrAllImg[currentIndex];
//    [imageM juGetfullScreenImage:^(UIImage *image) {
//        PAEditImageVC *vc=[[PAEditImageVC alloc]initWithImage:image handle:^(UIImage * _Nullable result) {
//            ;
//        }];
//        [self.navigationController presentViewController:vc animated:NO completion:nil];
//    }];
}

- (void)juTouchFinish:(id)sender {
    NSMutableArray *arrSelect=[NSMutableArray array];
    for (PHAsset *object in ju_arrAllImg) {
        if (!object.isSelect) {
            [arrSelect addObject:object];
        }
    }
    self.ju_finishHandle(arrSelect);
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)juSetImages:(NSArray *)arrList
      currentIndex:(NSInteger)sIndex
            finish:(JuEditFinish)finishHaldle{
    self.ju_finishHandle=finishHaldle;
    currentIndex=sIndex;
    ju_arrAllImg=arrList;
    __weak typeof(self)  weakSelf = self;
    [ju_imgCollectView juSetImages:arrList cIndex:sIndex handle:^(NSInteger index) {
        [weakSelf juSetCurrentIndex:index];
        [weakSelf juSetAllIndex];
    }];
}


//所有图片栏选中
-(void)juSetAllIndex{
    PHAsset *objcet=ju_arrAllImg[currentIndex];
    self.ju_toolBar.ju_currentIndex=[_ju_mArrSelectImg indexOfObject:objcet];
}

//工具栏图片选中
-(void)juSetSelectIndex:(NSInteger)toolIndex{
    PHAsset *objcet=_ju_mArrSelectImg[toolIndex];
    NSInteger index=[ju_arrAllImg indexOfObject:objcet];
    if (index!=NSNotFound) {
        [self juSetCurrentIndex:index];
        ju_imgCollectView.ju_currentIndex=index;
    }
}

-(NSMutableArray *)ju_mArrSelectImg{
    if (!_ju_mArrSelectImg) {
        _ju_mArrSelectImg=[NSMutableArray array];
    }
    return _ju_mArrSelectImg;
}

//状态栏颜色 ios9以后
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(BOOL)prefersStatusBarHidden{
    return _ju_toolBar.hidden;
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
