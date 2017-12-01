//
//  JuTakePhotoVC.h
//  JuCamera
//
//  Created by Juvid on 2017/10/20.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import "JuCameraviewController.h"
typedef NS_ENUM(NSInteger,JuCaptureOutputType){///< 订单状态
    JuCaptureOutputStillImage   =1,///< 拍照
    JuCaptureOutputVideoData    =2,///< 实时视频
    JuCaptureOutputMovieFile    =3,///< 音视频
};
@interface JuTakePhotoCameraVC : JuCameraviewController

@property (nonatomic,assign) JuCaptureOutputType juCaptureType;

@property (nonatomic,assign) AVCaptureDevicePosition juPosition;

@property (nonatomic,assign) AVCaptureFlashMode   juCaptureFlashModel;

-(void)focusActionPoint:(CGPoint)point success:(void (^)(void))succ fail:(void (^)(NSError *))fail;
//拍照
- (void)shTakePhoto:(void (^)(UIImage *image))handle;
@end
