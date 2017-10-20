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
    [self juInitCamera];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [juCaptureSession startRunning];
}

-(void)setJuSessionPreset:(NSString *)juSessionPreset{
     juCaptureSession.sessionPreset=juSessionPreset;
}

/**
 * 初始化摄像头
 */
- (void)juInitCamera {
    juDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    juCaptureInput = [AVCaptureDeviceInput deviceInputWithDevice:juDevice  error:nil];
    
    juCaptureSession = [[AVCaptureSession alloc] init];
   
    [juCaptureSession addInput:juCaptureInput];
   
    juCustomLayer = [CALayer layer];
    CGRect frame = self.view.bounds;
    frame.origin.y = 64;
    frame.size.height = frame.size.height - 64;
    
    juCustomLayer.frame = frame;
    juCustomLayer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI/2.0f, 0, 0, 1);
    juCustomLayer.contentsGravity = kCAGravityResizeAspectFill;
    [self.view.layer addSublayer:juCustomLayer];
     juCaptureSession.sessionPreset=AVCaptureSessionPresetPhoto;
    juPrevLayer = [AVCaptureVideoPreviewLayer layerWithSession: juCaptureSession];
    juPrevLayer.frame = CGRectMake(100, 64, 100, 100);
    juPrevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer: juPrevLayer];
    
//    [juPrevLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    
    UIButton *back = [[UIButton alloc]init];
    [back setTitle:@"back" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [back sizeToFit];
    frame = back.frame;
    frame.origin.y = 25;
    back.frame = frame;
    [self.view addSubview:back];
    [back addTarget:self action:@selector(juBack:) forControlEvents:UIControlEventTouchUpInside];
    
   
}

-(void)juBack:(id)sender{
    [juCaptureSession stopRunning];
    [self dismissViewControllerAnimated:true completion:nil];
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
