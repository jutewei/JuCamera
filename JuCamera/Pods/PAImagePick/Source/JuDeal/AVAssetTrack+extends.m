//
//  AVAssetTrack+extends.m
//  PAImagePick
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2022/5/9.
//

#import "AVAssetTrack+extends.h"

@implementation AVAssetTrack (extends)

- (CMFormatDescriptionRef)juCMFormatDescriptionRef
{
    NSArray *formatDescriptions = [self formatDescriptions];
    CMFormatDescriptionRef formatDescription = (__bridge CMFormatDescriptionRef)(formatDescriptions.firstObject);
    return formatDescription;
}

/// 3.从视频格式信息中获取视频编码类型
- (CMVideoCodecType)juCMVideoCodecType
{
    CMFormatDescriptionRef formatDescription = [self juCMFormatDescriptionRef];
    CMVideoCodecType codecType = CMVideoFormatDescriptionGetCodecType(formatDescription);
    return codecType;
}

- (BOOL)isH264
{
    BOOL isH264 = NO;
    CMVideoCodecType codecType = [self juCMVideoCodecType];
    isH264 = (codecType == kCMVideoCodecType_H264);
    return isH264;
}

- (BOOL)isHEVC
{
    BOOL isHEVC = NO;
    CMVideoCodecType codecType = [self juCMVideoCodecType];
    isHEVC = (codecType == kCMVideoCodecType_HEVC);
    return isHEVC;
}


@end
