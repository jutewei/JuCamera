//
//  JuTakePhotoVC.m
//  JuCamera
//
//  Created by Juvid on 2017/10/20.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import "JuTakePhotoCameraVC.h"

@interface JuTakePhotoCameraVC ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>{
     AVCaptureFlashMode         juCurrentflashMode; // 当前闪光灯的模式
}
@property (nonatomic, retain) UIImageView *imageView;

@end

@implementation JuTakePhotoCameraVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self juInitCamera];
    // Do any additional setup after loading the view.
}
- (void)juInitCamera{
    [super juInitCamera];
    if (!self.imageView) {
        [self juSetVideoOutput];
        juStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
        NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
        [juStillImageOutput setOutputSettings:outputSettings];
        if ([juCaptureSession  canAddOutput:juStillImageOutput]) {
            [juCaptureSession addOutput:juStillImageOutput];
        }

        self.imageView = [[UIImageView alloc] init];
        self.imageView.frame = CGRectMake(0, 64, 100, 100);
        [self.view addSubview:self.imageView];
        
    
        UIButton *take = [[UIButton alloc]initWithFrame:CGRectMake(150, 300, 60, 35)];
        [take setTitle:@"拍照" forState:UIControlStateNormal];
        [take setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        [take sizeToFit];
        [self.view addSubview:take];
        [take addTarget:self action:@selector(shTakePhoto:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *switchBtn = [[UIButton alloc]initWithFrame:CGRectMake(150, 350, 60, 35)];
        [switchBtn setTitle:@"切换" forState:UIControlStateNormal];
        [switchBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.view addSubview:switchBtn];
        [switchBtn addTarget:self action:@selector(shTakeSwitch:) forControlEvents:UIControlEventTouchUpInside];
    }

}
-(void)juSetLayer{
    juCustomLayer = [CALayer layer];
    juCustomLayer.frame = self.view.bounds;
    juCustomLayer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI/2.0f, 0, 0, 1);
    juCustomLayer.contentsGravity = kCAGravityResizeAspectFill;
    [self.view.layer addSublayer:juCustomLayer];

}
-(void)setJuCaptureType:(JuCaptureOutputType)juCaptureType{
    switch (juCaptureType) {
        case JuCaptureOutputMovieFile:{
            if (!juAudioDataOutput) {
                dispatch_queue_t queue = dispatch_queue_create("cameraQueue", DISPATCH_QUEUE_SERIAL);
                juAudioDataOutput = [[AVCaptureAudioDataOutput alloc] init];
                [juAudioDataOutput setSampleBufferDelegate:self queue:queue];
                if ([juCaptureSession canAddOutput:juAudioDataOutput]){
                    [juCaptureSession addOutput:juAudioDataOutput];
                }
            }
        }
        default:
            break;
    }
}

-(void)juSetVideoOutput{
    juVideoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    juVideoDataOutput.alwaysDiscardsLateVideoFrames = YES;
    // captureOutput.minFrameDuration = CMTimeMake(1, 10);
    dispatch_queue_t queue = dispatch_queue_create("cameraQueue", DISPATCH_QUEUE_SERIAL);
    [juVideoDataOutput setSampleBufferDelegate:self queue:queue];
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [juVideoDataOutput setVideoSettings:videoSettings];
    if ([juCaptureSession  canAddOutput:juVideoDataOutput]) {
        [juCaptureSession addOutput:juVideoDataOutput];
    }
}
-(void)shTakeSwitch:(UIButton *)sender{
    self.juPosition=AVCaptureDevicePositionFront;
}
-(void)setJuPosition:(AVCaptureDevicePosition)juPosition{
    _juPosition=juPosition;
    [self juSwitchCameras];
}
- (BOOL)canSwitchCameras{
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count] > 1;
}
//旋转摄像头
-(void)juSwitchCameras{
    if ([self canSwitchCameras]) {
        [juCaptureSession beginConfiguration];
        [juCaptureSession removeInput:juCaptureInput];
        
        juDevice=[self juCameraWithPosition:_juPosition];
        juCaptureInput=[AVCaptureDeviceInput deviceInputWithDevice:juDevice error:nil];
        if ([juCaptureSession canAddInput:juCaptureInput]) {
            [juCaptureSession addInput:juCaptureInput];
            
        }
        [juCaptureSession commitConfiguration];
        
        // 如果从后置转前置，会关闭手电筒，如果之前打开的，需要通知camera更新UI
        if (juDevice.position == AVCaptureDevicePositionFront) {
            
        }
        // 闪关灯，前后摄像头的闪光灯是不一样的，所以在转换摄像头后需要重新设置闪光灯
        [self juChangeFlash:juCurrentflashMode];
        
        // 由于前置摄像头不支持视频，所以当你转换到前置摄像头时，视频输出就无效了，所以在转换回来时，需要把原来的删除了，在重新加一个新的进去
        [self juSetVideoOutput];
        
        [juCaptureSession commitConfiguration];
        
    }
}

- (AVCaptureDevice *)juCameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}
#pragma mark 闪光灯
- (id)juChangeFlash:(AVCaptureFlashMode)flashMode{
    if (![self juCameraHasFlash]) {
        NSDictionary *desc = @{NSLocalizedDescriptionKey:@"不支持闪光灯"};
        NSError *error = [NSError errorWithDomain:@"com.cc.camera" code:401 userInfo:desc];
        return error;
    }
    // 如果手电筒打开，先关闭手电筒
    if ([self juTorchMode] == AVCaptureTorchModeOn) {
        [self setTorchMode:AVCaptureTorchModeOff];
    }
    return [self setFlashMode:flashMode];
}
- (id)setTorchMode:(AVCaptureTorchMode)torchMode{
    
    if ([juDevice isTorchModeSupported:torchMode]) {
        NSError *error;
        if ([juDevice lockForConfiguration:&error]) {
            juDevice.torchMode = torchMode;
            [juDevice unlockForConfiguration];
        }
        return error;
    }
    return nil;
}
- (id)setFlashMode:(AVCaptureFlashMode)flashMode{
   
    if ([juDevice isFlashModeSupported:flashMode]) {
        NSError *error;
        if ([juDevice lockForConfiguration:&error]) {
            juDevice.flashMode = flashMode;
            [juDevice unlockForConfiguration];
            juCurrentflashMode = flashMode;
        }
        return error;
    }
    return nil;
}
- (AVCaptureTorchMode)juTorchMode {
    return [juDevice hasFlash];
}
- (BOOL)juCameraHasFlash {
    return [juDevice hasFlash];
}

#pragma mark - 聚焦
-(void)focusActionPoint:(CGPoint)point success:(void (^)(void))succ fail:(void (^)(NSError *))fail{
    id error = [self juFocusAtPoint:point];
    error?!fail?:fail(error):!succ?:succ();
}

- (BOOL)cameraSupportsTapToFocus{
    return [juDevice isFocusPointOfInterestSupported];
}

- (id)juFocusAtPoint:(CGPoint)point{
    if ([self cameraSupportsTapToFocus] && [juDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus])
    {
        NSError *error;
        if ([juDevice lockForConfiguration:&error]) {
            juDevice.focusPointOfInterest = point;
            juDevice.focusMode = AVCaptureFocusModeAutoFocus;
            [juDevice unlockForConfiguration];
        }
        return error;
    }
    return nil;
}


- (void)shTakePhoto:(id)sender {
    [self juChangeFlash:AVCaptureFlashModeOn];
    AVCaptureConnection *stillImageConnection = [juStillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    [stillImageConnection setVideoScaleAndCropFactor:1];
    
    [juStillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault,
                                                                    imageDataSampleBuffer,
                                                                    kCMAttachmentMode_ShouldPropagate);
        
        UIImage *image=[UIImage imageWithData:jpegData];
        self.imageView.image=image;
        [juCaptureSession stopRunning];
        NSLog(@"图片 %@",image);
        
    }];
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace,                                                  kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    CGImageRef newImage = CGBitmapContextCreateImage(newContext);
    
    CGContextRelease(newContext);
    CGColorSpaceRelease(colorSpace);
    
    id object = (__bridge id)newImage;
    // http://www.cnblogs.com/zzltjnh/p/3885012.html
    [juCustomLayer performSelectorOnMainThread:@selector(setContents:) withObject: object waitUntilDone:YES];
    
    UIImage *image= [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationRight];
    // release
    CGImageRelease(newImage);
    
    [self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
}

-(AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    return result;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
