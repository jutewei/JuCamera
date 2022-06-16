//
//  JuPhotoCollectionVController.m
//  JuPhotoBrowser
//
//  Created by Juvid on 16/9/21.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JuPhotoPickerVC.h"
#import "JuLayoutFrame.h"
#import "JuPhotoPickerCell.h"
#import "JuPhotoPickerFoot.h"
#import "JuAlbumPreviewVC.h"
#import "JuPhotoGroupTVC.h"
#import "JuAlbumManage.h"
#import "JuPhotoAlert.h"

@interface JuPhotoPickerVC ()<PHPhotoLibraryChangeObserver>{
    UICollectionView *ju_collectionView;
    PHFetchResult *ju_fetchResult;
    NSMutableArray *ju_mArrSelects;
    JuPhotoPickerToolBar *ju_toolBar;
    NSInteger isDidLoad;
    JuPhotoPickerTitleView *ju_barView;
    JuPhotoGroupTVC *ju_groupAlbumVc;
}
@property (nonatomic,weak) id<JuPhotoDelegate> juDelegate;

@end

@implementation JuPhotoPickerVC

+(id)initWitDelegate:(id<JuPhotoDelegate>)delegate maxSelectNum:(NSInteger)maxNum{
    JuPhotoPickerVC   *ju_photoGropVC=[[JuPhotoPickerVC alloc]initWitDelegate:delegate maxSelectNum:maxNum];
    JuPhotoNavigationVC *nav=[JuPhotoNavigationVC juBasicNation:ju_photoGropVC];
    nav.view.backgroundColor=Photo_BackColor;
    [nav setBarColor:Photo_BackColor];
    return ju_photoGropVC;
}

-(instancetype)initWitDelegate:(id<JuPhotoDelegate>)delegate maxSelectNum:(NSInteger)maxNum{
    self=[super init];
    if (self) {
        self.ju_maxNumSelection=maxNum;
        self.juDelegate=delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=Photo_BackColor;
    [self.view setClipsToBounds:YES];
    ju_mArrSelects=[NSMutableArray array];
    [self juSetCollect];
    [self juSetHeadBarView];
    [self juSetToolBar];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self juAlbumsAuth];
    });
    // Do any additional setup after loading the view.
}

-(void)juSetHeadBarView{
    __weak typeof(self) weakSelf=self;
    ju_barView=[JuPhotoPickerTitleView initWithHandle:^{
        [weakSelf juSetGroupView:NO];
    }];
    self.navigationItem.titleView=ju_barView;
}

-(void)juSetGroupView:(BOOL)isAuth{
    __weak typeof(self) weakSelf=self;
    if (!ju_groupAlbumVc) {
        ju_groupAlbumVc=[JuPhotoGroupTVC initWithHandle:^(id  _Nullable result) {
            weakSelf.ju_PhotoGroup=result;
            [weakSelf juGetAllPhoto];
        }];
        ju_groupAlbumVc.ju_onlyVideo=(_ju_mediaType==JuPhotoAlbumVideo);
    }
    if (isAuth)  return;///初始化的时候不调用show
    [ju_groupAlbumVc juShowVC:self];
}
-(void )juSetCollect{
//    self.view.backgroundColor=[UIColor whiteColor];
    CGFloat screen_Width = MIN([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);    //屏幕宽
    CGFloat itemW=(screen_Width-8)/4;

    UICollectionViewFlowLayout* ju_layout = [UICollectionViewFlowLayout new];
    ju_layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    ju_layout.itemSize =CGSizeMake(itemW, itemW);
    ju_layout.sectionInset=UIEdgeInsetsMake(1, 1, 1, 1);
//    ju_layout.footerReferenceSize=CGSizeMake(screen_Width, 46);
    ju_layout.minimumLineSpacing=2;//   行间距
    ju_layout.minimumInteritemSpacing=2;//    内部cell间距
    ju_collectionView=[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:ju_layout];
    ju_collectionView.backgroundColor=Photo_blackColor;
//    ju_collectionView.allowsMultipleSelection = YES;
    ju_collectionView.alwaysBounceVertical=YES;
    ju_collectionView.delegate=self;
    ju_collectionView.dataSource=self;
    [ju_collectionView registerClass:[JuPhotoPickerCell class]  forCellWithReuseIdentifier:@"JuPhotoPickerCell"];
//    [ju_CollectionView registerClass:[JuPhotoPickerFoot class]
//            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
//                   withReuseIdentifier:@"JuPhotoPickerFoot"];
    [self.view addSubview:ju_collectionView];
    ju_collectionView.juSafeEdge(UIEdgeInsetsMake(0, 0, 64, 0));
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 0)];
    [btn setImage:juPhotoImage(@"photo_selectClose") forState:UIControlStateNormal];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btn addTarget:self action:@selector(juCancel:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancleButton = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:cancleButton animated:NO];
}

//获取权限
-(void)juAlbumsAuth{
    [JuAlbumManage juFetchAuth:^{
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
        [self juGetAllPhoto];
        [self juSetGroupView:YES];
    }];
}
//相册变化回调
- (void)photoLibraryDidChange:(PHChange *)changeInstance{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self juGetAllPhoto];
    });
}

//获取当前相册的所有照片
-(void)juGetAllPhoto{
    if (!_ju_PhotoGroup) {
        if (_ju_mediaType==JuPhotoAlbumVideo) {
            _ju_PhotoGroup=[JuAlbumManage juFetchVideoAlbums].firstObject;
        }else{
            _ju_PhotoGroup=[JuAlbumManage juFetchRecentAlbums].firstObject;
        }
    }
    ju_fetchResult = [PHAsset fetchAssetsInAssetCollection:_ju_PhotoGroup options:nil];
    ju_barView.text=_ju_PhotoGroup.localizedTitle;
    
    [self checkSelected];
    
    if (ju_collectionView) {
        [ju_collectionView reloadData];
    }
    [self juScrollEnd];
    isDidLoad=0;
//    [self performSelector:@selector(juScrollEnd) withObject:nil afterDelay:0];
}

- (void)checkSelected {
    if (ju_mArrSelects.count==0) return;
//    NSMutableSet *selectedAssets = [NSMutableSet setWithCapacity:ju_mArrSelects.count];
//    for (PHAsset *asset in ju_mArrSelects) {
//        [selectedAssets addObject:asset];
//    }
    for (PHAsset *set in  ju_mArrSelects) {
        if ([ju_fetchResult containsObject:set]) {
            NSInteger setIndex=[ju_fetchResult indexOfObject:set];
            if (setIndex!=NSNotFound) {
                PHAsset *asset=ju_fetchResult[setIndex];
                asset.isSelect=set.isSelect;
                asset.isOriginal=set.isOriginal;
            }
        }
    }
}


-(void)juScrollEnd{
    if (ju_fetchResult.count) {
        [ju_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:ju_fetchResult.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    }
//    if (isDidLoad<2) {
//        CGFloat offsizeY=ju_collectionView.collectionViewLayout.collectionViewContentSize.height - ju_collectionView.frame.size.height;
//        if(offsizeY>0)
//            [ju_collectionView setContentOffset:CGPointMake(0, offsizeY) animated:NO];
//
//    }
//    isDidLoad++;
}

-(void)juCancel:(id)sender{
    if ([self.juDelegate respondsToSelector:@selector(juPhotosDidCancelController:)]) {
        [self.juDelegate juPhotosDidCancelController:self];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self juSetButtonTitel];
    [ju_collectionView reloadData];
//    [self performSelector:@selector(juScrollEnd) withObject:nil afterDelay:0.05];
}

-(void)juSetToolBar{
    if (!ju_toolBar) {
        __weak typeof(self)    weakSelf = self;
        ju_toolBar=[JuPhotoPickerToolBar initWithHandle:^(NSInteger index) {
            [weakSelf juTouchBtnWithTag:index];
        }];
        [self.view addSubview:ju_toolBar];
        ju_toolBar.juSafeFrame(CGRectMake(0, -.01, 0, 64));
    }
    if (_ju_mediaType==JuPhotoAlbumVideo) {
        ju_toolBar.ju_hidePreView=_ju_mediaType==JuPhotoAlbumVideo;
        self.ju_hideOImg=YES;
    }else{
        self.ju_hideOImg=_ju_hideOImg;
    }
}

-(void)setJu_hideOImg:(BOOL)ju_hideOImg{
    _ju_hideOImg=ju_hideOImg;
    if (ju_toolBar) {
        ju_toolBar.ju_hideOImg=_ju_hideOImg;
    }
}

-(void)juTouchBtnWithTag:(NSInteger)tag{
    if (tag==1) {///预览
        __weak typeof(self)    weakSelf = self;
        JuAlbumPreviewVC *vc=[JuAlbumPreviewVC juInitPreSelect:ju_mArrSelects currentIndex:0 finish:^(NSArray *arrList) {
            [weakSelf juFinishSlectPhotos];
        }];
        vc.ju_allowVideo=_ju_mediaType;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(tag==2){///原图
        PHAsset *asset=ju_mArrSelects.lastObject;
        if (asset) {
            asset.isOriginal=!asset.isOriginal;
        }
        [ju_toolBar juSetOriginal:asset.isOriginal];
    }
    else{///完成
        [self juFinishSlectPhotos];
    }
}

-(void)juSetButtonTitel{
    [ju_toolBar juSetCount:ju_mArrSelects.count];
    PHAsset *asset=ju_mArrSelects.lastObject;
    [ju_toolBar juSetOriginal:asset.isOriginal];
}

//选择完成
-(void)juFinishSlectPhotos{
//    for (PHAsset *asset in ju_MArrSelects) {
//        asset.isOriginal=ju_oBtnItem.selected;
//    }
    if ([self.juDelegate respondsToSelector:@selector(juPhotosDidFinishController:didSelectAssets:)]) {
        [self.juDelegate juPhotosDidFinishController:self didSelectAssets:ju_mArrSelects];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return ju_fetchResult.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self)  weakSelf = self;
    JuPhotoPickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JuPhotoPickerCell" forIndexPath:indexPath];
    PHAsset *assetIndex=ju_fetchResult[indexPath.row];
    cell.ju_allowVideo=_ju_mediaType;
//    cell.ju_singleSelect=_ju_mediaType==JuPhotoAlbumVideo;
    cell.ju_asset=assetIndex;
    cell.ju_assetHandle = ^(PHAsset *asset) {
      [weakSelf juSetSelectAsset:asset index:indexPath];
    };
    return cell;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    if (kind == UICollectionElementKindSectionFooter) {
//        JuPhotoCollectionFoot *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"JuPhotoCollectionFoot" forIndexPath:indexPath];
//        footerView.ju_strText=[NSString stringWithFormat:@"共 %ld 张照片",ju_fetchResult.count];
//        return footerView;
//    }
//
//    return nil;
//}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    PHAsset *asset=ju_fetchResult[indexPath.row];
//    单选直接返回
    if (_ju_mediaType==JuPhotoAlbumVideo) {
//        PHAsset *asset=ju_fetchResult[indexPath.row];
//        asset.isSelect=YES;
//        asset.isOriginal=NO;
//        [self juSetSelectAsset:asset];
//        [self juTouchBtnWithTag:3];
        return;
    }
    
    __weak typeof(self)    weakSelf = self;
    JuAlbumPreviewVC *vc=[JuAlbumPreviewVC juInitPreAll:ju_fetchResult selectList:ju_mArrSelects  currentIndex:indexPath.row finish:^(NSArray *arrList) {
        [weakSelf juFinishSlectPhotos];
    }];
    vc.ju_allowVideo=_ju_mediaType;
    vc.ju_maxNumSelection=_ju_maxNumSelection;
    [self.navigationController pushViewController:vc animated:YES];
    
//    asset.isSelect=YES;
//    [ju_MArrSelects addObject:ju_fetchResult[indexPath.row]];
//    [self juSetButtonTitel];
}
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    return ju_mArrSelects.count<_ju_maxNumSelection;
//}

//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
//    PHAsset *asset=ju_fetchResult[indexPath.row];
//    asset.isSelect=NO;
//    [ju_mArrSelects removeObject:ju_fetchResult[indexPath.row]];
//    [self juSetButtonTitel];
//}

-(void)juSetSelectAsset:(PHAsset *)asset index:(NSIndexPath *)indexPath{
//    if (asset.isNetwork) {///网络资源
//        asset.isSelect=NO;
//        [ju_collectionView reloadItemsAtIndexPaths:@[indexPath]];
//        [JuPhotoAlert juAlertTitle:@"该资源暂不可用" message:nil withVc:self];
//        return ;
//    }
    if (asset.isSelect&&ju_mArrSelects.count>=_ju_maxNumSelection) {
        asset.isSelect=NO;
        [ju_collectionView reloadItemsAtIndexPaths:@[indexPath]];
        [JuPhotoAlert juAlertTitle:[NSString stringWithFormat:@"最多选择%@%@",@(_ju_maxNumSelection),_ju_mediaType==JuPhotoAlbumImage?@"张图片":@"个文件"] message:nil withVc:self];
        return ;
    }
    
    if (asset.isSelect) {
        [ju_mArrSelects addObject:asset];
    }else{
        [ju_mArrSelects removeObject:asset];
    }
    [self juSetButtonTitel];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//状态栏颜色 ios9以后
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)dealloc{
    ;
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
