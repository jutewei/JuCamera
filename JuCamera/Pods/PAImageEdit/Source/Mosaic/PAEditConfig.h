//
//  PAEditConfig.h
//  Pods
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/7/9.
//

#ifndef PAEditConfig_h
#define PAEditConfig_h

#define PAEditImageBundle(value) [NSString stringWithFormat:@"PAMosaicResource.bundle/%@",value]

#define Window_Height [[UIScreen mainScreen] bounds].size.height
#define Window_Width [[UIScreen mainScreen] bounds].size.width

#define PAEditImage(value) [UIImage imageNamed:PAEditImageBundle(value)]

#define MosaicMainColor [UIColor colorWithRed:353/255.0 green:113/255.0 blue:74/255.0 alpha:1]

typedef void(^__nullable JuImageResult)(UIImage * _Nullable result);             //
typedef void(^__nullable JuMosaicStatusHandle)(BOOL   isStart);             //


#endif /* PAEditConfig_h */
