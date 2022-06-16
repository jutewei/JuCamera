//
//  NSObject+PhotoManage.h
//  MTSkinPublic
//
//  Created by Juvid on 2016/11/18.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@class PAImageDealModel;
@interface NSObject (PhotoManage)

/**
 默认图 最小边1200

 @param imageHandle 图片
 */
-(void)juGetDefault:(void(^)(UIImage *image))imageHandle;


/// 获取默认图
/// @param side 最小边
/// @param imageHandle 回调
-(void)juGetDefault:(CGFloat)side handle:(void(^)(UIImage *image))imageHandle;
/**
 中图

 @param imageHandle 图片
 */
-(void)juGetRatioThumbnail:(void(^)(UIImage *image))imageHandle;

//**预览图*/
-(void)juGetPreFullImage:(void(^)(UIImage *image))imageHandle;
/**
 原图

 @param imageHandle 图片
 */
-(void)juGetfullScreenImage:(void(^)(UIImage *image))imageHandle;


/// 获取指定尺寸图片
/// @param size 尺寸
/// @param isAsyn 同步或异步
/// @param imageHandle 回调
-(void)juGetImageWithSize:(CGSize)size
                   isAsyn:(BOOL)isAsyn
                   handle:(void(^)(UIImage *image))imageHandle;

/// 获取压缩图片
/// @param cModel 压缩模型
/// @param imageHandle 回调
-(void)juCompressModel:(PAImageDealModel *)cModel
                handle:(void(^)(NSDictionary *result))imageHandle;

@end


@interface UIImage (imageSave)

/// base64转图片
/// @param base64 base64文本
+(UIImage *)imageWithBase64:(NSString *)base64;

/**
 保存相册 photos 框架

 @param imageHandle 照片源
 */
-(void)juSaveRHAssetPhoto:(void(^)(PHAsset * asset))imageHandle;

+(void)juSaveImage:(UIImage *)image handle:(void(^)(PHAsset * asset))imageHandle;

@end
