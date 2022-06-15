//
//  JuTakePhotoVC.m
//  JuCamera
//
//  Created by Juvid on 2017/10/20.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import "JuTakePhotoCameraVC.h"
#import "UIImage+fixOrientation.h"

@interface JuTakePhotoCameraVC ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>{
//    AVCaptureFlashMode         juCurrentflashMode; // 当前闪光灯的模式
    AVCaptureStillImageOutput   *juStillImageOutput;
    AVCaptureVideoDataOutput    *juVideoDataOutput;
    AVCaptureAudioDataOutput    *juAudioDataOutput;
    BOOL isCheck;
    BOOL isTakeIng;
    UIView *ju_camFocus;

}
//@property (nonatomic, retain) UIImageView *imageView;

@end

@implementation JuTakePhotoCameraVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}
- (void)juInitCaptureOutput{
    [super juInitCaptureOutput];
    [self juSetVideoOutput];
    juStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [juStillImageOutput setOutputSettings:outputSettings];
    if ([juCaptureSession  canAddOutput:juStillImageOutput]) {
        [juCaptureSession addOutput:juStillImageOutput];
    }
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
    NSNumber* value = [NSNumber numberWithUnsignedLong:kCVPixelFormatType_32BGRA];
//    NSNumber* value = [NSNumber numberWithUnsignedLong:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange];

    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [juVideoDataOutput setVideoSettings:videoSettings];
    if ([juCaptureSession  canAddOutput:juVideoDataOutput]) {
        [juCaptureSession addOutput:juVideoDataOutput];
    }
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
        
//        // 闪关灯，前后摄像头的闪光灯是不一样的，所以在转换摄像头后需要重新设置闪光灯
//        [self juStartFlash:_juCaptureFlashModel];

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
- (id)juStartFlash{
    if (![juDevice hasFlash]) {
        NSDictionary *desc = @{NSLocalizedDescriptionKey:@"不支持闪光灯"};
        NSError *error = [NSError errorWithDomain:@"com.cc.camera" code:401 userInfo:desc];
        return error;
    }
    // 如果手电筒打开，先关闭手电筒
    if ( juDevice.torchMode == AVCaptureTorchModeOn) {
        [self setTorchMode:AVCaptureTorchModeOff];
    }
    //    开始闪光
    if ([juDevice isFlashModeSupported:_juCaptureFlashModel]) {
        NSError *error;
        if ([juDevice lockForConfiguration:&error]) {
            juDevice.flashMode = _juCaptureFlashModel;
            [juDevice unlockForConfiguration];
        }
        return error;
    }
    return nil;
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

//支持手电筒
- (AVCaptureTorchMode)juTorchMode {
    return [juDevice hasTorch];
}


#pragma mark - 聚焦
-(void)focusActionPoint:(CGPoint)point success:(void (^)(void))succ fail:(void (^)(NSError *))fail{
    id error = [self juFocusAtPoint:point];
    error?!fail?:fail(error):!succ?:succ();
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:touch.view];
//    BOOL allTouchesEnded = ([touches count] == [[event touchesForView:self.view] count]);
    [self juFocusAtPoint:touchPoint];
    if (!ju_camFocus) {
        ju_camFocus=[[UIView alloc]init];
        ju_camFocus.backgroundColor=[UIColor clearColor];
        ju_camFocus.userInteractionEnabled=NO;
        [ju_camFocus.layer setBorderColor:UIColor.yellowColor.CGColor];
        [ju_camFocus.layer setBorderWidth:1];
        [self.view addSubview:ju_camFocus];
    }
    ju_camFocus.alpha=1;
    ju_camFocus.frame=CGRectMake(touchPoint.x-40, touchPoint.y-40, 80, 80);
    [UIView animateWithDuration:0.5 delay:3 options:UIViewAnimationOptionCurveEaseOut  animations:^{
        ju_camFocus.alpha=0;
    } completion:^(BOOL finished) {
        
    }];
    
}
//自动对焦
- (id)juFocusAtPoint:(CGPoint)point{
    if ([juDevice isFocusPointOfInterestSupported] && [juDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus])
    {
        CGRect cameraViewRect = [[self view] bounds];
        double cameraViewWidth = cameraViewRect.size.width;
        double cameraViewHeight = cameraViewRect.size.height;
        double focus_x = point.x/cameraViewWidth;
        double focus_y = point.y/cameraViewHeight;
        CGPoint cameraViewPoint = CGPointMake(focus_x, focus_y);
        NSError *error;
        //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
        if ([juDevice lockForConfiguration:&error]) {
            juDevice.focusPointOfInterest = cameraViewPoint;
            juDevice.focusMode = AVCaptureFocusModeAutoFocus;
            if ([juDevice isExposurePointOfInterestSupported] && [juDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
                [juDevice setExposureMode:AVCaptureExposureModeAutoExpose];
                [juDevice setExposurePointOfInterest:cameraViewPoint];
            }
            [juDevice setSubjectAreaChangeMonitoringEnabled:true];
            [juDevice unlockForConfiguration];
        }
        return error;
    }
    return nil;
}


//拍照
- (void)shTakePhoto:(void (^)(UIImage *image))handle{
    
    if (!juCaptureSession.isRunning||isTakeIng)  return;
    isTakeIng=YES;

    if (_juPosition!=AVCaptureDevicePositionFront) {
        [self juStartFlash];
    }
    AVCaptureConnection *stillImageConnection = [juStillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    [stillImageConnection setVideoScaleAndCropFactor:1];
    
    [juStillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        NSLog(@"%ld",(long)curDeviceOrientation);
        if (error==nil) {
            NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image=[UIImage imageWithData:jpegData];
            image = [image juFixOrientation];
            handle(image);
        }else{
            handle(nil);
        }
        self.isTakePhoto=YES;
        isTakeIng=NO;
    }];
}

/*-(void)shTest:(CMSampleBufferRef)imageSampleBuffer{
    UIImageOrientation imgOrientation; //拍摄后获取的的图像方向

    if (juDevice.position == AVCaptureDevicePositionFront) {
        // 前置摄像头图像方向 UIImageOrientationLeftMirrored
        // IOS前置摄像头左右成像
        imgOrientation = UIImageOrientationLeftMirrored;
        NSLog(@"前置摄像头");
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
        UIImage *t_image = [UIImage imageWithData:imageData];

        UIImage *image = [[UIImage alloc]initWithCGImage:t_image.CGImage scale:1.0f orientation:imgOrientation];
    }

}*/
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{

//    [faceEngine shCheckSampleBuffer:sampleBuffer];
//
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
//    [juVideoPrevLayer performSelectorOnMainThread:@selector(setContents:) withObject: object waitUntilDone:YES];

    UIImage *image= [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationRight];
    // release
    CGImageRelease(newImage);

//    [self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];

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
