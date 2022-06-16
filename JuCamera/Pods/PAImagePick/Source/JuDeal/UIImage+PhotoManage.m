//
//  NSObject+PhotoManage.m
//  MTSkinPublic
//
//  Created by Juvid on 2016/11/18.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "UIImage+PhotoManage.h"
#import "JuPhotoAlert.h"
#import "JuAlbumManage.h"
#import "PHAsset+juDeal.h"
#import "PAImageDeal.h"

static NSString * const JuCollectionName = @"平安车管家";
@implementation NSObject (PhotoManage)

-(void)juGetDefault:(void(^)(UIImage *image))imageHandle{
    [self juGetDefault:0 handle:imageHandle];
}

-(void)juGetDefault:(CGFloat)side handle:(void(^)(UIImage *image))imageHandle{
    CGFloat lastSide=side>0?side:PAImageDefaultWid;
    [self juGetImageWithSize:CGSizeMake(lastSide, lastSide) handle:imageHandle];

}

//**略缩图*/
-(void)juGetRatioThumbnail:(void(^)(UIImage *image))imageHandle{
    [self juGetImageWithSize:CGSizeMake(150, 150) handle:imageHandle];
}
//**预览图*/
-(void)juGetPreFullImage:(void(^)(UIImage *image))imageHandle{
    [self juGetImageWithSize:CGSizeMake(350, 350) handle:imageHandle];
}

//**原图上传使用返回data*/
-(void)juGetfullScreenImage:(void(^)(UIImage *image))imageHandle{
    [self juGetImageWithSize:CGSizeZero  handle:imageHandle];
}

//同步获取图片异步回调
-(void)juGetImageWithSize:(CGSize)size handle:(void(^)(UIImage *image))imageHandle{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),^{
        [self juGetImageWithSize:size isAsyn:NO handle:^(UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (imageHandle)  imageHandle(image);
            });
        }];
    });
}

-(void)juGetImageWithSize:(CGSize)size
                   isAsyn:(BOOL)isAsyn
                   handle:(void(^)(UIImage *image))imageHandle{
    if([self isKindOfClass:[PHAsset class]]){
        PHAsset *asset=(PHAsset *)self;
        if (CGSizeEqualToSize(size,CGSizeZero)||(asset.isOriginal&&size.width>=PAImageDefaultWid)) {
            size= CGSizeMake(asset.pixelWidth, asset.pixelHeight);
        }
        [asset juRequestImageSize:size  isAsyn:isAsyn handle:imageHandle];
    }else if([self isKindOfClass:[UIImage class]]){
        imageHandle((UIImage *)self);
    }
}

-(void)juCompressModel:(PAImageDealModel *)cModel
                handle:(void(^)(NSDictionary *result))imageHandle{
    PHAsset *asset=(PHAsset *)self;
    if (!cModel) {
        cModel=[PAImageDealModel zlDefaultWithImage:nil];
    }
    [self juGetDefault:PAImageDefaultWid handle:^(UIImage *image) {
        if ([self isKindOfClass:[PHAsset class]]&&asset.isOriginal) {
            cModel.zl_type=PAImageCompressTypeHigh;
        }
        cModel.zl_image=image;
        NSData *data=[PAImageDeal zlCompressImage:cModel];
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        [dic setValue:data forKey:@"src"];
        [dic setValue:@(data.length) forKey:@"size"];
        [dic setValue:@(image.size.width) forKey:@"width"];
        [dic setValue:@(image.size.height) forKey:@"height"];
        if (imageHandle) {
            imageHandle(dic);
        }
    }];
}

@end

@implementation UIImage (imageSave)

+(UIImage *)imageWithBase64:(NSString *)base64{
    if (![base64 isKindOfClass:[NSString class]]) return nil;
    NSData *data=[[NSData alloc]initWithBase64EncodedString:[base64 stringByReplacingOccurrencesOfString:@"data:image/jpeg;base64," withString:@""] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    if (!data) return nil;
    return [UIImage imageWithData:data];
}

+(void)juSaveImage:(UIImage *)image handle:(void(^)(PHAsset * asset))imageHandle{
    if (image) {
        [image juSaveRHAssetPhoto:imageHandle];
    }else{
        if (imageHandle) {
            imageHandle(nil);
        }
    }
}

-(void)juSaveRHAssetPhoto:(void(^)(PHAsset * asset))imageHandle{
    // 判断授权状态
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) {
            if (status==PHAuthorizationStatusDenied||status==PHAuthorizationStatusRestricted) {
                [self juShowArlert:@"无法使用iPhone相册" message:@"请在iPhone的“设置-隐私-照片”中允许访问相册"  handle:imageHandle];
            }
            return;
        }
        NSError *error = nil;
        // 保存相片到相机胶卷
        __block PHObjectPlaceholder *savePlaceholder = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            savePlaceholder = [PHAssetCreationRequest creationRequestForAssetFromImage:self].placeholderForCreatedAsset;
        } error:&error];
                
        if (error||savePlaceholder==nil) {
            [self juShowArlert:@"保存失败" message:error.domain  handle:imageHandle];
            return;
        }
        // 拿到自定义的相册对象
        PHAssetCollection *customAsset = [self juCollection];
        __block PHFetchResult *fetchResult = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            fetchResult=[PHAsset fetchAssetsWithLocalIdentifiers:@[savePlaceholder.localIdentifier] options:nil];
            if (customAsset) {
                [[PHAssetCollectionChangeRequest changeRequestForAssetCollection:customAsset] insertAssets:@[savePlaceholder] atIndexes:[NSIndexSet indexSetWithIndex:0]];
            }
        } error:&error];
        
        dispatch_async(dispatch_get_main_queue(),^{
            if (imageHandle) {
                imageHandle(fetchResult.lastObject);
            }
        });
    }];
}
-(void)juShowArlert:(NSString *)title message:(NSString *)message handle:(void(^)(PHAsset * Asset))imageHandle{
    dispatch_async(dispatch_get_main_queue(),^{
        [JuPhotoAlert juAlertTitle:title message:message];
        if (imageHandle) {
            imageHandle(nil);
        }
    });
}
-(PHAssetCollection *)juCollection{
    // 先从已存在相册中找到自定义相册对象
    PHFetchResult<PHAssetCollection *> *collectionResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in collectionResult) {
        if ([collection.localizedTitle isEqualToString:JuCollectionName]) {
            return collection;
        }
    }

    // 新建自定义相册
    __block NSString *collectionId = nil;
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        collectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:JuCollectionName].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];

    if (error) {
        NSLog(@"获取相册【%@】失败", JuCollectionName);
        return nil;
    }

    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectionId] options:nil].lastObject;
}



@end

