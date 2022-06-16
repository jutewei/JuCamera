//
//  AVAsset+compress.h
//  PAImagePick
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2022/4/12.
//

#import <AVFoundation/AVFoundation.h>
#import "JuPhotoConfig.h"
NS_ASSUME_NONNULL_BEGIN


@interface AVAsset (Export)
/// 视频获取路径（系统方法）
/// @param presetName 质量值
/// @param handle 回调
- (void)juExportWithPreset:(NSString *)presetName
                  progress:(JuProgresHandle)progress
                    handle:(JuVideoHandle)handle;

@end

@interface AVAsset (compress)

/// 视频压缩
/// @param path 路径
/// @param presetName 质量值
/// @param handle 回调
+(void)juCompressWithPath:(NSString *)path
                   preset:(NSString*)presetName
                 progress:(JuProgresHandle)progress
                   handle:(JuVideoHandle)handle;

/// 视频压缩
/// @param presetName 质量值
/// @param handle 回调
-(void)juCompressWithAsset:(NSString*)presetName
                  progress:(JuProgresHandle)progress
                    handle:(JuVideoHandle)handle;

@end



NS_ASSUME_NONNULL_END
