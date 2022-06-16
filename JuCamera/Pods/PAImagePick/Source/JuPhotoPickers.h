//
//  SHGetPhotos.h
//  SHBaseProject
//
//  Created by Juvid on 15/11/4.
//  Copyright © 2015年 Juvid(zhutianwei). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JuPhotoConfig.h"
//#import "JuPhotoGroupTVC.h"

//显示的控制器类型
typedef NS_ENUM(NSInteger, JuPhotoPickType) {
    JuPhotoPickTypeImage    = 0,    // 图片
    JuPhotoPickTypeCamera,          ///相机
    JuPhotoPickTypeLibrary,         ///系统相册
    JuPhotoPickTypeFile,            // 文件
//    JuPhotoPickTypeDocument,        // 文档文件
//    JuPhotoPickTypeVideo,           //视频文件
    JuPhotoPickTypeAll              // 所有
};

@protocol JUChoosePhotoDelegate;
NS_ASSUME_NONNULL_BEGIN
@interface JuPhotoPickers : NSObject<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
}

@property (nonatomic,strong) NSMutableArray* _Nullable ju_Assets;

@property BOOL allowsEditing;//允许编辑

/** 以下是新方法***/
+ (instancetype _Nullable ) sharedInstance;


/// 自带弹框选择控制
/// @param pickType 控制器类型
/// @param albumType 相册类型
/// @param maxNum 最大数
/// @param vc sup控制器
/// @param handle 回调
-(void)juSheetWithType:(JuPhotoPickType)pickType
             albumType:(JuPhotoAlbumType)albumType
                    maxNum:(NSInteger)maxNum
                    withVC:(nullable UIViewController *)vc
                    handle:(JuImageHandle)handle;


/// 文件选择器组合
/// @param pickType 控制器类型
/// @param albumType 相册内容类型
/// @param maxNum 最大数量
/// @param vc sup控制器
/// @param handle 回调
-(UIViewController*)juPickVcWithType:(JuPhotoPickType)pickType
                           albumType:(JuPhotoAlbumType)albumType
                              maxNum:(NSInteger)maxNum
                               supVC:(nullable UIViewController *)vc
                              handle:(JuImageHandle)handle;


/// 附件
/// @param mediaTypes 附件类型
/// @param complete 回调
-(UIViewController *)juFilePickTypes:(NSArray *)mediaTypes
                            complete:(JuImageHandle)complete;

-(UIViewController *)juFilePickTypes:(NSArray *)mediaTypes
                           isNewPath:(BOOL)isNewPath
                            complete:(JuImageHandle)complete;
/// 相机
/// @param allowsEditing 是否可以编辑
/// @param albumType 类型
/// @param complete 回调
-(UIViewController *)juCameraPick:(BOOL)allowsEditing
                        albumType:(JuPhotoAlbumType)albumType
                         complete:(JuImageHandle)complete;

//系统相册
-(UIViewController *)juLibraryPick:(BOOL)allowsEditing
                          complete:(JuImageHandle)complet;
/// 相册
/// @param albumType 类型
/// @param maxNum 最多数量
/// @param complete 回调
-(UIViewController *)juAlbumPick:(JuPhotoAlbumType)albumType
                          maxNum:(NSInteger)maxNum
                        complete:(JuImageHandle)complete;
/**
 是否预览完直接上传图片
 */
@property BOOL isUpLoad;

@end
NS_ASSUME_NONNULL_END

@protocol JUChoosePhotoDelegate <NSObject>
/**
 *获取照片回调
 */
@optional
-(void)fbFinishImage:(id _Nullable )imageData;

@end
