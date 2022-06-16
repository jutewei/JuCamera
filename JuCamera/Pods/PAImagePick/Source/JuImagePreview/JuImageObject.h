//
//  JuImageObject.h
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//
// 网络图片大图到小图时显示
//图片来源类型


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef NS_ENUM(NSInteger,JuImageType){
    JuImageTypeImage,
    JuImageTypeUrl,
    JuImageTypeAsset,
};
@interface JuImageObject : NSObject
@property (nonatomic,copy) NSString *ju_imageUrl;///< 图片地址
@property (nonatomic,copy) NSString *ju_iobsKey;///< 关键key
@property (nonatomic,copy) NSString  *ju_thumbImageUrl;/// 缩略图地址
@property (nonatomic,assign)CGSize  ju_thumbSize; /// 缩略图尺寸
@property (nonatomic,copy) UIImage  *ju_image;/// 图片
@property (nonatomic,copy) PHAsset  *ju_asset;/// 相册
@property (nonatomic,assign) CGFloat  ju_progress;///< 图片下载进度
@property (nonatomic,assign) JuImageType  ju_imageType;///< 图片类型
@property (nonatomic,assign) BOOL ju_isNoSelect;///<

+(NSArray *)juSwithObject:(NSArray *)arrList size:(CGSize)size;

@end

