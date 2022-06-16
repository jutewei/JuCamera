//
//  SHGetPhotos.m
//  SHBaseProject
//
//  Created by Juvid on 15/11/4.
//  Copyright © 2015年 Juvid(zhutianwei). All rights reserved.
//

#import "JuPhotoPickers.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "JuImagePickerVC.h"
#import "JuPhotoPickerVC.h"
#import "JuDocumentPickerVC.h"
#import "JuPhotoAlert.h"
#import "JuPhotoNavigationVC.h"
#import "PHAsset+juDeal.h"
#import "PAImageDealModel.h"

@interface JuPhotoPickers ()<JuPhotoDelegate,UINavigationControllerDelegate>{
    NSMutableArray *ju_mArrAsset;
//    JuPhotoGroupTVC *ju_photoGropVC;
}

@property(nonatomic,copy)JuImageHandle ju_imageHandle;
@property (nonatomic,copy)dispatch_block_t ju_cancel;

@property (nonatomic, weak) UIViewController * _Nullable presentController;
//@property (nonatomic, assign) BOOL allowsMultipleSelection;//允许多选
//@property (nonatomic, assign) NSUInteger maximumNumberOfSelection;//最多张数

@end

@implementation JuPhotoPickers

+ (instancetype) sharedInstance{
    static JuPhotoPickers *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(instancetype)init{
    self=[super init];
    if (self) {
//        _maximumNumberOfSelection=8;
        ju_mArrAsset=[NSMutableArray array];
        __weak typeof(self) weakSelf=self;
        self.ju_cancel = ^{
            [weakSelf juCacelSelect];
        };
    }
    return self;
}


-(void)juSheetWithType:(JuPhotoPickType)type
             albumType:(JuPhotoAlbumType)albumType
                maxNum:(NSInteger)maxNum
                withVC:(nullable UIViewController *)vc
                handle:(JuImageHandle)handle{
    
    if (maxNum<=0) {
        [JuPhotoAlert juAlertTitle:@"提示" message:@"文件数已达到上限"];
        return;
    }
    NSArray *arrItems=[self juItems:type];
    [JuPhotoAlert juSheetControll:nil actionItems:arrItems handler:^(UIAlertAction *action) {
        if ([action.title isEqual:@"取消"]) {
            return;
        }
        JuPhotoPickType pickType=JuPhotoPickTypeImage;
        if([action.title isEqual:@"文件"]){
            pickType=JuPhotoPickTypeFile;
        }else if([action.title isEqual:@"从手机相册选择"]){
            pickType=JuPhotoPickTypeImage;
        }else{
            pickType=JuPhotoPickTypeCamera;
        }
        [self juPickVcWithType:pickType albumType:albumType maxNum:maxNum supVC:vc handle:handle];
    }];
}

-(NSArray *)juItems:(JuPhotoPickType)pickType{
    NSMutableArray *arrItem=[NSMutableArray arrayWithArray:@[@"取消",@"拍照",@"从手机相册选择",@"文件"]];
    if (pickType==JuPhotoPickTypeFile) {
        [arrItem removeObjectsInArray:@[@"拍照",@"从手机相册选择"]];
    }else if(pickType==JuPhotoPickTypeImage){
        [arrItem removeObjectsInArray:@[@"文件"]];
    }
    return arrItem;
}

//-(void)setMaximumNumberOfSelection:(NSUInteger)maximumNumberOfSelection{
//    _maximumNumberOfSelection=maximumNumberOfSelection;
//    self.allowsMultipleSelection=maximumNumberOfSelection>0;
//}

-(void)setJu_Assets:(NSMutableArray *)leAssets{
    [ju_mArrAsset removeAllObjects];
    if (leAssets) {
        _ju_Assets=leAssets;
    }else{
        _ju_Assets =[NSMutableArray array];
    }
}

-(UIViewController *)juPickVcWithType:(JuPhotoPickType)pickType
                            albumType:(JuPhotoAlbumType)albumType
                               maxNum:(NSInteger)maxNum
                                supVC:(UIViewController *)supVC
                               handle:(JuImageHandle)handle{
    NSArray *types;
    if (pickType==JuPhotoPickTypeFile) {
        if (albumType==JuPhotoAlbumImage) {
            types=@[@"com.adobe.pdf",@"com.microsoft.word.doc",@"org.openxmlformats.wordprocessingml.document"];
        }else{
//                public.movie
            types=@[@"public.mpeg-4",@"com.apple.quicktime-movie"];
        }
    }
    return [self juPickVcWithType:pickType albumType:albumType mediaTypes:types maxNum:maxNum supVC:supVC handle:handle];
}

-(UIViewController *)juPickVcWithType:(JuPhotoPickType)pickType
                            albumType:(JuPhotoAlbumType)albumType
                           mediaTypes:(NSArray *)mediaTypes
                               maxNum:(NSInteger)maxNum
                                supVC:(UIViewController *)supVC
                               handle:(JuImageHandle)handle{
    UIViewController *pushVc=nil;
    JuImageHandle complete=^(id result){
        if (result&&handle) {
            handle(@[result]);
        }
    };
    switch (pickType) {
        case JuPhotoPickTypeCamera:{
            pushVc=[self juCameraPick:self.allowsEditing albumType:albumType complete:complete];
        }
            break;
        case JuPhotoPickTypeLibrary:{
            pushVc=[self juLibraryPick:self.allowsEditing  complete:complete];
        }
            break;
        case JuPhotoPickTypeFile:{
            pushVc=[self juFilePickTypes:mediaTypes complete:complete];
        }
            break;
        case JuPhotoPickTypeImage:{
            pushVc=[self juAlbumPick:albumType maxNum:maxNum complete:handle].parentViewController;
        }
            break;
        default:
            break;
    }
    self.presentController=supVC;
    if (pushVc) {
        [self juPresentViewController:pushVc];
    }
    return pushVc;
}

//附件
-(UIViewController *)juFilePickTypes:(NSArray *)mediaTypes
                            complete:(JuImageHandle)complete{
    return [self juFilePickTypes:mediaTypes isNewPath:NO complete:complete];
}

-(UIViewController *)juFilePickTypes:(NSArray *)mediaTypes
                           isNewPath:(BOOL)isNewPath
                            complete:(JuImageHandle)complete{
    _ju_imageHandle=complete;
    __weak typeof(self) weakSelf=self;
    JuDocumentPickerVC *vc=[JuDocumentPickerVC initDocumentPickWithType:mediaTypes handle:^(id  _Nullable reslut) {
        NSString *fileUrl=reslut;
        if (isNewPath) {
            fileUrl=[NSString juSwitchFilePath:reslut];
        }
        [weakSelf juFinishFile:fileUrl];
    }];
    vc.ju_cancel = self.ju_cancel;
    return vc;
}

//相机
-(UIViewController *)juCameraPick:(BOOL)allowsEditing
                        albumType:(JuPhotoAlbumType)albumType
                        complete:(JuImageHandle)complete{
    _ju_imageHandle=complete;
    __weak typeof(self) weakSelf=self;
    JuImagePickerVC *vc=[JuImagePickerVC initCameraPick:allowsEditing mediaType:albumType handle:^(id  _Nullable result) {
        [weakSelf juFinishFile:result];
    }];
    vc.ju_cancel = self.ju_cancel;
    return vc;
}

//系统相册
-(UIViewController *)juLibraryPick:(BOOL)allowsEditing
                          complete:(JuImageHandle)complete{
    _ju_imageHandle=complete;
    __weak typeof(self) weakSelf=self;
    JuImagePickerVC *vc=[JuImagePickerVC initImagePickType:UIImagePickerControllerSourceTypePhotoLibrary
                                             allowsEditing:allowsEditing
                                                    handle:^(id  _Nullable result) {
        [weakSelf juFinishFile:result];
    }];
    vc.ju_cancel = self.ju_cancel;
    return vc;
}

//相册
-(UIViewController *)juAlbumPick:(JuPhotoAlbumType)albumType
                          maxNum:(NSInteger)maxNum
                        complete:(JuImageHandle)complete{
    _ju_imageHandle=complete;
    if ([JuImagePickerVC isPhotoLibraryAvailable]){
        JuPhotoPickerVC  *vc=(JuPhotoPickerVC *)[JuPhotoPickerVC initWitDelegate:self maxSelectNum:maxNum];
        vc.ju_mediaType=albumType;
        return vc;
    }
    return nil;
}

-(void)juFinishFile:(id)images{
    [self juFinishImage:images];
}
    
-(void)juCacelSelect{
    [self juFinishImage:nil];
}

-(void)juPresentViewController:(UIViewController *)vc{
    
    if (!vc)  return;
    
    UIViewController *supVC=self.presentController;
    vc.modalPresentationStyle=UIModalPresentationFullScreen;
    dispatch_async(dispatch_get_main_queue(), ^{
        [supVC presentViewController:vc animated:YES completion:nil];
    });
}

#pragma mark PreviewDelegate 完成预览
-(void)juFinishSelectImage:(id)arrImg{
    NSMutableArray *arrResult=[NSMutableArray array];
    [arrResult addObjectsFromArray:_ju_Assets];
    [arrResult addObjectsFromArray:arrImg];
    [self juFinishImage:arrResult];
}

-(void)juFinishImage:(id)images{
    if (self.ju_imageHandle) {
        self.ju_imageHandle(images);
        self.ju_imageHandle = nil;
    }
}

-(NSInteger)juImageCount{
    return ju_mArrAsset.count+_ju_Assets.count;
}

- (void)juPhotosDidCancelController:(UIViewController *)pickerController {
    [self juCacelSelect];
}

- (void)juPhotosDidFinishController:(UIViewController *)pickerController didSelectAssets:(NSArray *)arrList{
    [self juFinishSelectImage:arrList];
    [pickerController dismissViewControllerAnimated:YES completion:nil];
}

-(void)juDidReceiveMemoryWarning{
//    ju_photoGropVC=nil;
}
@end
