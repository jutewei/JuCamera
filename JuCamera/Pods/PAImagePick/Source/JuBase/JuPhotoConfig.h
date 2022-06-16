//
//  JuPhotoConfig.h
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#ifndef JuPhotoConfig_h
#define JuPhotoConfig_h
#import <Photos/Photos.h>

/// 当前宽高
#define JU_Window_Height        [[UIScreen mainScreen] bounds].size.height
#define JU_Window_Width         [[UIScreen mainScreen] bounds].size.width

#define Photo_TitleColor        [UIColor whiteColor]
#define Photo_btnColor          [UIColor colorWithRed:253/255.0 green:134/255.0 blue:74/255.0 alpha:255/255.0]
#define Photo_BackColor         [UIColor colorWithRed:26/255.0 green:27/255.0 blue:28/255.0 alpha:255/255.0]
#define Photo_blackColor        [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:255/255.0]

#define Photo_lineColor         [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:255/255.0]

#define juPhotoBundle(value)    [NSString stringWithFormat:@"JuPhotoResource.bundle/%@",value]

#define juPhotoImage(value)     [UIImage imageNamed:juPhotoBundle(value)]

#define PA_IPHONE_X             (JU_Window_Height>736)  //1242x2208

typedef void(^__nullable JuImageHandle)(id  _Nullable result);
typedef void(^__nullable JuFileHandle)(id  _Nullable data,BOOL isCancel);             //
//
typedef void(^__nullable JuAlbumHandle)(id  _Nullable result);             //

typedef void(^__nullable JuVideoHandle)(BOOL success,NSString * _Nullable result);

typedef void(^__nullable JuProgresHandle)(CGFloat progress);

//打印信息设置
typedef void(^JuCompletion)(void);//回调
typedef void(^JuTouchHider)(BOOL isPlay);//隐私头回调
typedef void(^JuHandleIndex)(NSInteger index);//回调
typedef void(^JuEditFinish)(NSArray * _Nullable arrList);//预览完成
typedef void(^JuAssetHandle)(PHAsset * _Nullable asset);//选择

typedef CGRect (^JuHandle)(id _Nullable result);//坐标回调


typedef NS_ENUM(NSInteger, JuPhotoAlbumType) {
    JuPhotoAlbumImage = 0, // 图片
    JuPhotoAlbumVideo = 1, // 视频
    JuPhotoAlbumAll = 2, // 所有
};

#define ju_dispatch_get_main_async(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

#endif /* JuPhotoConfig_h */
