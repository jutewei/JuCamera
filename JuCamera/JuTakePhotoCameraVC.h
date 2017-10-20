//
//  JuTakePhotoVC.h
//  JuCamera
//
//  Created by Juvid on 2017/10/20.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import "JuCameraviewController.h"
typedef NS_ENUM(NSInteger,JuAVCaptureOutputType){///< 订单状态
    JuAVCaptureOutputStillImage   =1,///< 拍照
    JuAVCaptureOutputVideoData    =2,///< 实时视频
    JuAVCaptureOutputMovieFile    =3,///< 音视频
};
@interface JuTakePhotoCameraVC : JuCameraviewController{
    AVCaptureStillImageOutput *juStillImageOutput;
    AVCaptureVideoDataOutput *juVideoDataOutput;
    AVCaptureMovieFileOutput *juVideoDataOutput;
}

@end
