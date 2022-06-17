//
//  ViewController.m
//  JuCamera
//
//  Created by Juvid on 2017/10/18.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import "ViewController.h"
#import "JuTakePhotoCameraVC.h"
#import "JuScanVC.h"
//#import "JuPlayVoice.h"
#import "UIImage+ORCode.h"
#import "UIImage+PhotoManage.h"
#import "MBProgressHUD+Share.h"
#import "JuScanReslutVC.h"
#import "PABaseNavigationC.h"
#import "UIImage+drawImage.h"

//#import <AVFoundation/AVFoundation.h>
@interface ViewController ()<UITextViewDelegate>{
//    JuPlayVoice *ju_playVoice;
}
@property (weak, nonatomic) IBOutlet UIImageView *juImageView;
@property (weak, nonatomic) IBOutlet UITextView *juTextView;
@property (weak, nonatomic) IBOutlet UILabel *ju_labHint;
@property (weak, nonatomic) IBOutlet UIButton *ju_btnScan;

//@property (nonatomic, strong) AVAudioPlayer *player;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithWhite:0.98 alpha:1];
    self.title = @"二维码";
    
    [self juSetView];
//    [self shSetNew:2|1|3];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)juSetView{
    _juTextView.textContainerInset=UIEdgeInsetsMake(5, 5, 5, 5);
    [_juTextView.superview.layer setCornerRadius:10];
    [_juTextView.superview.layer setMasksToBounds:YES];
    
//    [_juImageView.superview.layer setCornerRadius:5];
//    [_juImageView.superview.layer setMasksToBounds:YES];
    
    _juImageView.superview.backgroundColor=[UIColor whiteColor];
    
    [_ju_btnScan.layer setCornerRadius:5];
    [_ju_btnScan.layer setMasksToBounds:YES];

    [_ju_btnScan setBackgroundImage:[UIImage juImageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
}

- (IBAction)juTouchScan:(UIButton *)sender{
    JuScanVC *vc=[[JuScanVC alloc]init];
    PABaseNavigationC *nav=[PABaseNavigationC zlBasicNation:vc];
    vc.ju_handle = ^(id  _Nullable result) {
        JuScanReslutVC *vc=[JuScanReslutVC juInitMainStoryVC];
        vc.ju_result=result;
        [self juPushViewController:vc];
    };
    nav.modalPresentationStyle=0;
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)textViewDidChange:(UITextView *)textView{
    _ju_labHint.hidden=textView.text.length;
}

//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if ([text isEqual:@"\n"]) {
//        [textView resignFirstResponder];
//        _juImageView.image=[UIImage juCreatQR:textView.text size:260];
//        return NO;
//    }
//    return YES;
//}

- (IBAction)juTouchSave:(UIButton *)sender{

    if(sender.tag==1){
        _juImageView.image=[UIImage juCreatQR:_juTextView.text size:341];
    }else{
        
        if (_juImageView.image) {
            UIImage *image=[UIImage screenView:_juImageView.superview];
            [image juSaveRHAssetPhoto:^(PHAsset *asset) {
                if (asset) {
                    [MBProgressHUD juShowHUDText:@"保存成功"];
                }
            }];
        }
    }
}

- (IBAction)JuTakePhotos:(UIButton *)sender {
    if (sender.tag==1) {
        JuRichScanCameraVC *vc=[[JuRichScanCameraVC alloc]init];
        vc.modalPresentationStyle=0;
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        JuTakePhotoCameraVC *vc=[[JuTakePhotoCameraVC alloc]init];
        vc.modalPresentationStyle=0;
        vc.juCaptureType=JuCaptureOutputStillImage;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

-(void)shSetNew:(NSInteger)index{
    if(index&3){
        NSLog(@"3");
    }
    if (index&2){
        NSLog(@"2");
    }
    if (index&1){
        NSLog(@"1");
    }
    if (index&4){
        NSLog(@"4");
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
