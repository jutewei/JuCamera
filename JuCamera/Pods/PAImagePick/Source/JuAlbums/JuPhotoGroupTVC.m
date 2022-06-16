//
//  JuPhotoGroupViewController.m
//  JuPhotoBrowser
//
//  Created by Juvid on 16/9/21.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JuPhotoGroupTVC.h"
#import <Photos/Photos.h>
#import "JuLayoutFrame.h"
#import "JuPhotoGroupCell.h"
#import "JuPhotoPickerVC.h"
#import "JuAlbumManage.h"
#import "JUProgresswHUD.h"
//#import "UIViewController+Hud.h"
@interface JuPhotoGroupTVC ()<JuPhotoDelegate,PHPhotoLibraryChangeObserver>{
    UITableView *ju_tableView;
    NSArray *ju_ArrList;
    dispatch_queue_t ju_photoQueue;
}
@property (nonatomic,weak) id<JuPhotoDelegate> juDelegate;
@property (nonatomic,copy)JuAlbumHandle ju_selectHandle;
@property (nonatomic, assign) BOOL ju_isMinView;
@end

@implementation JuPhotoGroupTVC

+(id)initWithDelegate:(id<JuPhotoDelegate>)delegate{
    return [self initWithDelegate:delegate maxSelectNum:0];
}
-(instancetype)initWitDelegate:(id<JuPhotoDelegate>)delegate maxSelectNum:(NSInteger)maxNum{
    self=[super init];
    if (self) {
        self.ju_maxNumSelection=maxNum;
        self.juDelegate=delegate;
    }
    return self;
}

+(id)initWithDelegate:(id<JuPhotoDelegate>)delegate maxSelectNum:(NSInteger)maxNum{
    JuPhotoGroupTVC *vc=[[JuPhotoGroupTVC alloc]initWitDelegate:delegate maxSelectNum:maxNum];
    return vc;
}

+(id)initWithHandle:(JuAlbumHandle)handle{
    JuPhotoGroupTVC *vc=[[JuPhotoGroupTVC alloc]init];
    vc.ju_selectHandle=handle;
    vc.ju_isMinView=YES;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    self.title=@"相册";
    [self juSetTable];
    if (!_ju_isMinView) {
        [self juAlbumsAuth];
    }
    // Do any additional setup after loading the view.
}

-(void)juSetTable{
    ju_tableView=[[UITableView alloc]init];
    ju_tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    ju_tableView.delegate=self;
    ju_tableView.dataSource=self;
    ju_tableView.rowHeight=55;
    [ju_tableView registerClass:[JuPhotoGroupCell class] forCellReuseIdentifier:@"JuPhotoGroupCell"];
    ju_tableView.backgroundColor= Photo_BackColor;
    [self.view addSubview:ju_tableView];
   
    if (_ju_isMinView) {
        ju_tableView.juFrame(CGRectMake(0, 0.01, 0, JU_Window_Height-(PA_IPHONE_X?220:180)));
        ju_tableView.juSafeEdge(UIEdgeInsetsMake(0, 0, 180, 0));

    }else{
        ju_tableView.juFrame(CGRectMake(0, 0, 0, 0));
    }
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(juCancel:)];
    [self.navigationItem setLeftBarButtonItem:cancelButton animated:NO];
    
//    self.navigationItem.r=nil;
}

-(void)juCancel:(id)sender{
    [self juPhotosDidCancelController:self];
}

-(void)setJu_isMinView:(BOOL)ju_isMinView{
    _ju_isMinView=ju_isMinView;
    if (ju_isMinView) {
        [self juGetAllAlbum:nil];
    }
}

//相册变化回调
- (void)photoLibraryDidChange:(PHChange *)changeInstance{
    [self juGetAllAlbum:nil];
}


//获取所有相册
-(void)juAlbumsAuth{
    [[[JUProgresswHUD alloc] initWithView:self.view] juShowLoadText:@"请稍后……"];
    [JuAlbumManage juFetchAuth:^{
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
        [self juGetAllAlbum:^{
            [JUProgresswHUD hideAllHUDsForView:self.view];
        }];
    }];
}

//获取授权
-(void)juGetAllAlbum:(dispatch_block_t)block{
    if (!ju_photoQueue) {
        ju_photoQueue=dispatch_queue_create("com.juvid.photo", DISPATCH_QUEUE_SERIAL);
    }
    dispatch_async(ju_photoQueue, ^{
        if (self.ju_onlyVideo) {
            self->ju_ArrList=[JuAlbumManage juFetchVideoAlbums];
        }else{
            self->ju_ArrList=[JuAlbumManage juFetchPhotoAlbums];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.isViewLoaded) {
                [self->ju_tableView reloadData];
            }
            if (block) {
                block();
            }
        });
    });
}

- (void)juPhotosDidCancelController:(UIViewController *)pickerController{
    if ([self.juDelegate respondsToSelector:@selector(juPhotosDidCancelController:)]) {
        [self.juDelegate juPhotosDidCancelController:self];
    }
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        UIViewController *popVc = nil;
        for (int i = 0; i < self.navigationController.viewControllers.count; i++) {
            UIViewController *vc = self.navigationController.viewControllers[i];
            if ([NSStringFromClass([vc class]) isEqualToString:@"JuPhotoGroupViewController"]) {
                [self.navigationController popToViewController:popVc animated:true];
                return;
            }
            popVc=vc;
        }
    }
}

- (void)juPhotosDidFinishController:(UIViewController *)pickerController didSelectAssets:(NSArray *)arrList isPreview:(BOOL)ispreview{
    if ([self.juDelegate respondsToSelector:@selector(juPhotosDidFinishController:didSelectAssets:)]) {
        [self.juDelegate juPhotosDidFinishController:self didSelectAssets:arrList];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ju_ArrList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JuPhotoGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JuPhotoGroupCell" forIndexPath:indexPath];
    cell.ju_PhotoGroup=ju_ArrList[indexPath.row];
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.ju_selectHandle) {
        self.ju_selectHandle(ju_ArrList[indexPath.row]);
        [self juHideSelf];
        return;
    }
    
    JuPhotoPickerVC *vc=[[JuPhotoPickerVC alloc]initWitDelegate:self maxSelectNum:_ju_maxNumSelection];
    vc.ju_PhotoGroup=ju_ArrList[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}


/***==============未使用=================***/
//是否在iCloud
-(BOOL)isExist:(PHAsset *)asset{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.networkAccessAllowed = NO;
    option.synchronous = YES;
    __block BOOL isInLocalAblum = YES;
    [[PHCachingImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        isInLocalAblum = imageData ? YES : NO;
    }];
    return isInLocalAblum;
}
/***===============================***/

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [self juHideSelf];
}

/*下拉时使用*/
-(void)juShowVC:(UIViewController *)vc{
    if (self.view.superview) {
        [self juHideSelf];
    }else{
        [vc.view addSubview:self.view];
        [vc addChildViewController:self];
        self.view.juEdge(UIEdgeInsetsZero);
        self.view.backgroundColor=[UIColor colorWithWhite:0 alpha:0];

        ju_tableView.transform=CGAffineTransformMakeTranslation(0, -400);
        [UIView animateWithDuration:0.3 animations:^{
            self.view.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
            ju_tableView.transform=CGAffineTransformMakeTranslation(0, 0);
        }];
    }
}

-(void)juHideSelf{
    if (_ju_isMinView) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
            ju_tableView.transform=CGAffineTransformMakeTranslation(0, -CGRectGetHeight(ju_tableView.frame));
        }completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self.juDelegate respondsToSelector:@selector(juDidReceiveMemoryWarning)]&&!self.view.window) {
        [self.juDelegate juDidReceiveMemoryWarning];
    }
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [PHPhotoLibrary.sharedPhotoLibrary unregisterChangeObserver:self];
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
