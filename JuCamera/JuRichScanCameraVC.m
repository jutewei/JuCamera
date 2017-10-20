//
//  JuRichScanCameraVC.m
//  JuCamera
//
//  Created by Juvid on 2017/10/20.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import "JuRichScanCameraVC.h"

@interface JuRichScanCameraVC ()<AVCaptureMetadataOutputObjectsDelegate>{
    AVCaptureVideoPreviewLayer *juPrevLayer;
    AVCaptureMetadataOutput *juMetadataOutput;
}

@end

@implementation JuRichScanCameraVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self juInitCamera];
    // Do any additional setup after loading the view.
}
- (void)juInitCamera{
    [super juInitCamera];
    if (!juMetadataOutput) {
        dispatch_queue_t queue = dispatch_queue_create("cameraQueue", NULL);
        juMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
        [juMetadataOutput setMetadataObjectsDelegate:self queue:queue];
        [juCaptureSession addOutput:juMetadataOutput];
        
        [juMetadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode]];
        
    }
}
-(void)juSetLayer{
    juPrevLayer = [AVCaptureVideoPreviewLayer layerWithSession: juCaptureSession];
    juPrevLayer.frame = self.view.bounds;
    juPrevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer: juPrevLayer];
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count>0) {
        [juCaptureSession stopRunning];
        CGRect highlightViewRect = CGRectZero;
        AVMetadataMachineReadableCodeObject *barCodeObject;
        NSString *detectionString = nil;
        NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
        
        for (AVMetadataObject *metadata in metadataObjects) {
            for (NSString *type in barCodeTypes) {
                if ([metadata.type isEqualToString:type])
                {
                    barCodeObject = (AVMetadataMachineReadableCodeObject *)[juPrevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                    highlightViewRect = barCodeObject.bounds;
                    detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                    break;
                }
            }
        }
        NSLog(@"扫描结果%@",detectionString);
        [self performSelector:@selector(juBack:) withObject:nil afterDelay:0.3];
    }
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
