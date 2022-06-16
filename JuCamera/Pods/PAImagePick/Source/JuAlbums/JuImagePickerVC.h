//
//  JuSystemPictureVC.h
//  TestImage
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/4/26.
//

#import <UIKit/UIKit.h>
#import "JuPhotoConfig.h"
NS_ASSUME_NONNULL_BEGIN
//调用系统相册，用于获取一张图片
@interface JuImagePickerVC : UIImagePickerController

@property (nonatomic,assign) BOOL isNotSave;

@property (nonatomic,copy)dispatch_block_t ju_cancel;


/// 系统相册和相机
/// @param sourceType 类型（相机或相册）
/// @param allowsEditing 是否可以编辑
/// @param handle 回调
+(instancetype)initImagePickType:(UIImagePickerControllerSourceType)sourceType
                   allowsEditing:(BOOL)allowsEditing
                          handle:(JuImageHandle)handle;

/// 系统相机（包括视频）
/// @param allowsEditing 是否可以编辑
/// @param type 类型
/// @param maximum 视频最大时间
/// @param handle 回调
+(instancetype)initCameraPick:(BOOL)allowsEditing
                    mediaType:(JuPhotoAlbumType)type
                      handle:(JuImageHandle)handle;

//照片库
+ (BOOL) isPhotoLibraryAvailable;
@end

NS_ASSUME_NONNULL_END
