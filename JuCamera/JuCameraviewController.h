//
//  JuCameraVC.h
//  JuCamera
//
//  Created by Juvid on 2017/10/19.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
@interface JuCameraviewController : UIViewController{
    AVCaptureSession *juCaptureSession;
    AVCaptureDeviceInput *juCaptureInput;
    AVCaptureDevice *juDevice;
    CALayer *juCustomLayer;
    AVCaptureVideoPreviewLayer *juPrevLayer;
}
@property(nonatomic, copy) NSString *juSessionPreset;
- (void)juInitCamera;
-(void)juBack:(id)sender;
@end
