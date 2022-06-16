//
//  PHAsset+deal.h
//  PAImagePick
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2022/3/31.
//
/**
 iOS获取视频文件大小和时长
 1 、获取网络链接的视频大小和时长
 AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];// url：网络视频的连接
     NSArray *arr = [asset tracksWithMediaType:AVMediaTypeVideo];// 项目中是明确媒体类型为视频，其他没试过
     CGSize videoSize =CGSizeZero;
     for (AVAssetTrack *track in arr) {
      if([track.mediaType isEqualToString:AVMediaTypeVideo])
      {
         if (track.totalSampleDataLength >= 1048576) {//1048576bt = 1M  小于1m的显示KB 大于1m显示M
             lable.text = [NSString stringWithFormat:@"%.2lldM",track.totalSampleDataLength/1024/1024];
         } else {
             lable.text = [NSString stringWithFormat:@"%.1lldKB",track.totalSampleDataLength/1024];
         }
            videoSize = track.naturalSize;
       }
     }
 2 、获取保存在你app沙盒中的视频文件
 导入 #import <AVFoundation/AVFoundation.h>
  * @method
  *
  * @brief 根据路径获取视频时长和大小
  * @param path       视频路径
  * @return    字典    @"size"－－文件大小   @"duration"－－视频时长
 - (NSDictionary *)getVideoInfoWithSourcePath:(NSString *)path{
     AVURLAsset * asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
     CMTime   time = [asset duration];
     int seconds = ceil(time.value/time.timescale);
     NSInteger   fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
     return @{@"size" : @(fileSize),
              @"duration" : @(seconds)};
 }
 3 、获取PHAsset 文件大小
  PHAssetResource *resource = [[PHAssetResource assetResourcesForAsset:asset] firstObject];
     long long size = [[resource valueForKey:@"fileSize"] longLongValue];
 和
  PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
     options.version = PHVideoRequestOptionsVersionOriginal;
     [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
         if ([asset isKindOfClass:[AVURLAsset class]]) {
             AVURLAsset* urlAsset = (AVURLAsset*)asset;
             NSNumber *size;
             [urlAsset.URL getResourceValue:&size forKey:NSURLFileSizeKey error:nil];
             dispatch_async(dispatch_get_main_queue(), ^{
                  
             });
         } else {
             imageLable.text = [NSString stringWithFormat:@"0KB"];

         }
     }];
 */
#import <Photos/Photos.h>
#import "JuPhotoConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface PHAsset (juDeal)

@property(nonatomic,assign) BOOL isOriginal;//原图
@property(nonatomic,assign) BOOL isSelect;//选择
//是否iCloud资源
- (BOOL)isNetwork;

/// 获取图片
/// @param targetSize 尺寸
/// @param imageHandle 回调
-(void)juRequestImageSize:(CGSize)targetSize
                   handle:(void(^)(UIImage *image))imageHandle;

//请求data
-(void)juRequestData:(PHAssetVideoProgressHandler)progress
              handle:(void (^)(NSData *result))handle;
/// 获取图片
/// @param targetSize 尺寸
/// @param synchronous 是否网络异步
/// @param imageHandle 回调
-(void)juRequestImageSize:(CGSize)targetSize
                   isAsyn:(BOOL)synchronous
                   handle:(void(^)(UIImage *image))imageHandle;

/// 获取视频路径（720P）
/// @param handle 回调
-(void)juRequestVideo:(BOOL)isFast
             progress:(JuProgresHandle)progress
               handle:(JuVideoHandle)handle;


/// 获取视频本地路径
/// @param presetName 质量值
/// @param handle 回调
-(void)juRequestVideoPreset:(NSString*)presetName
                       isFast:(BOOL)isFast
                   progress:(JuProgresHandle)progress
                     handle:(JuVideoHandle)handle;


/// 获取视频播放对象
/// @param progress 进度
/// @param handle 回调
-(void)juRequestPlayer:(PHAssetVideoProgressHandler)progress
                handle:(void (^)(AVPlayerItem *result))handle;

-(NSString *)juGetTime;


@end


@interface AVAsset (juDeal)
/*
AVAssetExportPreset640x480,
AVAssetExportPreset960x540,
AVAssetExportPreset1280x720,
AVAssetExportPreset1920x1080,
AVAssetExportPreset3840x2160,
AVAssetExportPresetAppleM4A,
AVAssetExportPresetHEVC1920x1080,
AVAssetExportPresetHEVC3840x2160,

AVAssetExportPresetHighestQuality,
AVAssetExportPresetLowQuality,
AVAssetExportPresetMediumQuality
 */

/// 根据录制视频获取本地路径
/// @param movUrl mov地址
/// @param presetName 质量
/// @param handle 回调
+(void)juGetVideoPathWithURL:(NSURL *)movUrl
                  presetName:(NSString *)presetName
                      isFast:(BOOL)isFast
                    progress:(JuProgresHandle)progress
                      handle:(JuVideoHandle)handle;


- (void)juExportWithPreset:(NSString *)presetName
                     isFast:(BOOL)isFast
                  progress:(JuProgresHandle)progress
                     handle:(JuVideoHandle)handle;

@end

@interface NSObject (file)

/// 转换为沙盒路径
/// @param strUrl 原路径
+(NSString *)juSwitchFilePath:(NSString *)strUrl;


/// 获取Tmp路径
/// @param pathExtension 后缀名
+(NSString *)juGetTmpPath:(NSString *)pathExtension;


+(CGFloat)juGetFileSize:(NSString *)path;


@end

@interface NSString (file)

-(NSString *)juGetUrlPath;

-(NSString *)juGetTmpPath;

@end

NS_ASSUME_NONNULL_END
