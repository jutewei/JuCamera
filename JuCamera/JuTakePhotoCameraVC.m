//
//  JuTakePhotoVC.m
//  JuCamera
//
//  Created by Juvid on 2017/10/20.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import "JuTakePhotoCameraVC.h"

@interface JuTakePhotoCameraVC ()<AVCaptureVideoDataOutputSampleBufferDelegate>{
}
@property (nonatomic, retain) UIImageView *imageView;

@end

@implementation JuTakePhotoCameraVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)juInitCamera{
    [super juInitCamera];
    juVideoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    juVideoDataOutput.alwaysDiscardsLateVideoFrames = YES;
    // captureOutput.minFrameDuration = CMTimeMake(1, 10);
    
    dispatch_queue_t queue = dispatch_queue_create("cameraQueue", NULL);
    [juVideoDataOutput setSampleBufferDelegate:self queue:queue];
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [juVideoDataOutput setVideoSettings:videoSettings];
    
    
    juStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [juStillImageOutput setOutputSettings:outputSettings];
    
    
    if ([juCaptureSession  canAddOutput:juVideoDataOutput]) {
        [juCaptureSession addOutput:juVideoDataOutput];
    }
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
    
}
- (IBAction)shTakePhoto:(id)sender {
    
    AVCaptureConnection *stillImageConnection = [juStillImageOutput   connectionWithMediaType:AVMediaTypeVideo];
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
