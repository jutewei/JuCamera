//
//  AVAssetTrack+extends.h
//  PAImagePick
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2022/5/9.
//

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AVAssetTrack (extends)

- (BOOL)isH264;

- (BOOL)isHEVC;

@end

NS_ASSUME_NONNULL_END
