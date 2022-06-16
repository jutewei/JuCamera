//
//  JuAlbumPreviewVC.h
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JuPhotoConfig.h"
//#import "PABaseVC.h"

@interface JuAlbumPreviewVC : UIViewController


/// 预览相册所有图片
/// @param arrList 图片数组
/// @param selectList 已选择图片列表
/// @param index 第几个
/// @param haldle 回调
+(instancetype)juInitPreAll:(NSArray *)arrList
                 selectList:(NSArray *)selectList
               currentIndex:(NSInteger)index
                     finish:(JuEditFinish)haldle;

/// 预览已选择的图片
/// @param arrList 已选择图片列表
/// @param index 第几个
/// @param haldle 回调
+(instancetype)juInitPreSelect:(NSArray *)arrList
                currentIndex:(NSInteger)index
                    finish:(JuEditFinish)haldle;

@property (nonatomic,copy) JuAssetHandle ju_assetHandle;

@property (nonatomic, assign) NSUInteger ju_maxNumSelection;

@property (nonatomic,assign)  NSInteger  ju_allowVideo;

@end
