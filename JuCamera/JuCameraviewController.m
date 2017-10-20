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
//    [self juInitCamera];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (juCaptureSession) {
        [juCaptureSession startRunning];
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (juCaptureSession) {
        [juCaptureSession stopRunning];
    }
}
-(void)setJuSessionPreset:(NSString *)juSessionPreset{
     juCaptureSession.sessionPreset=juSessionPreset;
}

/**
 * 初始化摄像头
 */
- (void)juInitCamera {
    if (!juCaptureSession) {
        juDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        juCaptureInput = [AVCaptureDeviceInput deviceInputWithDevice:juDevice  error:nil];
        
        juCaptureSession = [[AVCaptureSession alloc] init];
        juCaptureSession.sessionPreset=AVCaptureSessionPresetPhoto;
        [juCaptureSession addInput:juCaptureInput];
        //    [juPrevLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
        
        [self juSetLayer];
        
        UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 60, 30)];
        [back setTitle:@"back" forState:UIControlStateNormal];
        [back setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

        [self.view addSubview:back];
        [back addTarget:self action:@selector(juBack:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)juSetLayer{}

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
