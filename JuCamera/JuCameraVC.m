//
//  JuCameraVC.m
//  JuCamera
//
//  Created by Juvid on 2017/10/19.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import "JuCameraVC.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
@interface JuCameraVC ()<AVCaptureVideoDataOutputSampleBufferDelegate> {
    AVCaptureSession *_captureSession;
    UIImageView *_imageView;
    CALayer *_customLayer;
    AVCaptureVideoPreviewLayer *_prevLayer;
    AVCaptureStillImageOutput *stillImageOutput;
}
@property (nonatomic, retain) AVCaptureSession *captureSession;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) CALayer *customLayer;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *prevLayer;

@end

@implementation JuCameraVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCapture];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)shTakePhoto:(id)sender {
    
    AVCaptureConnection *stillImageConnection = [stillImageOutput   connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    [stillImageConnection setVideoScaleAndCropFactor:1];
    
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault,
                                                                    imageDataSampleBuffer,
                                                                    kCMAttachmentMode_ShouldPropagate);
        
        UIImage *image=[UIImage imageWithData:jpegData];
        self.imageView.image=image;
        NSLog(@"图片 %@",image);
        
    }];
     [self.captureSession stopRunning];
    
   
}
/**
 * 初始化摄像头
 */
- (void)initCapture {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device  error:nil];
    
//    AVCaptureMovieFileOutput
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    // captureOutput.minFrameDuration = CMTimeMake(1, 10);
    
    dispatch_queue_t queue = dispatch_queue_create("cameraQueue", NULL);
    [captureOutput setSampleBufferDelegate:self queue:queue];
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
   
    //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
  
    
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset=AVCaptureSessionPresetPhoto;
    [self.captureSession addInput:captureInput];
    [self.captureSession addOutput:captureOutput];
    if ([self.captureSession  canAddOutput:stillImageOutput]) {
        [self.captureSession addOutput:stillImageOutput];
    }
    [self.captureSession startRunning];
    
    self.customLayer = [CALayer layer];
    CGRect frame = self.view.bounds;
    frame.origin.y = 64;
    frame.size.height = frame.size.height - 64;
    
    self.customLayer.frame = frame;
    self.customLayer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI/2.0f, 0, 0, 1);
    self.customLayer.contentsGravity = kCAGravityResizeAspectFill;
    [self.view.layer addSublayer:self.customLayer];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = CGRectMake(0, 64, 100, 100);
    [self.view addSubview:self.imageView];
    
    
    self.prevLayer = [AVCaptureVideoPreviewLayer layerWithSession: self.captureSession];
    self.prevLayer.frame = CGRectMake(100, 64, 100, 100);
    self.prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer: self.prevLayer];
    
//    [self.prevLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    
    UIButton *back = [[UIButton alloc]init];
    [back setTitle:@"back" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [back sizeToFit];
    frame = back.frame;
    frame.origin.y = 25;
    back.frame = frame;
    [self.view addSubview:back];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *take = [[UIButton alloc]init];
    [take setTitle:@"拍照" forState:UIControlStateNormal];
    [take setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [take sizeToFit];
    frame = take.frame;
    frame.origin.x = 150;
    frame.origin.y = 300;
    take.frame = frame;
    [self.view addSubview:take];
    [take addTarget:self action:@selector(shTakePhoto:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)back:(id)sender{
     [self.captureSession stopRunning];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
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
    [self.customLayer performSelectorOnMainThread:@selector(setContents:) withObject: object waitUntilDone:YES];
    
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
