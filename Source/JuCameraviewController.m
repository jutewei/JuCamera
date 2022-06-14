//
//  JuCameraVC.m
//  JuCamera
//
//  Created by Juvid on 2017/10/19.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import "JuCameraviewController.h"

@interface JuCameraviewController ()

@end

@implementation JuCameraviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    juDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(juDevice) [self juInitSession];
    });

    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self juStartRunning:YES];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self juStartRunning:NO];
}
-(void)setJuSessionPreset:(AVCaptureSessionPreset)juSessionPreset{
     juCaptureSession.sessionPreset=juSessionPreset;
}
-(void)juStartRunning:(BOOL)isStart{
    if (juCaptureSession) {
        if (isStart&&!_isTakePhoto) {
            [juCaptureSession startRunning];
        }else{
            [juCaptureSession stopRunning];
        }
    }
}
-(void)setIsTakePhoto:(BOOL)isTakePhoto{
    _isTakePhoto=isTakePhoto;
    [self juStartRunning:!isTakePhoto];
}
-(void)juReTakePhoto{
    _isTakePhoto=NO;
    [self juStartRunning:YES];
}
/**
 * 初始化摄像头
 */
- (void)juInitSession{
    if (!juCaptureSession) {
        juCaptureSession = [[AVCaptureSession alloc] init];
        [juCaptureSession beginConfiguration];
        juCaptureInput = [AVCaptureDeviceInput deviceInputWithDevice:juDevice  error:nil];
//        juCaptureSession.sessionPreset=AVCaptureSessionPresetHigh;
        if ([juCaptureSession canAddInput:juCaptureInput]) {
             [juCaptureSession addInput:juCaptureInput];
        }
        [self juInitCaptureOutput];
        [juCaptureSession commitConfiguration];
        [self juStartRunning:YES];
    }
}

-(void)juInitCaptureOutput{
    juVideoPrevLayer = [AVCaptureVideoPreviewLayer layerWithSession: juCaptureSession];
    juVideoPrevLayer.frame = self.view.bounds;
    juVideoPrevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:juVideoPrevLayer];
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
