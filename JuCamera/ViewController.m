//
//  ViewController.m
//  JuCamera
//
//  Created by Juvid on 2017/10/18.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import "ViewController.h"
#import "JuTakePhotoCameraVC.h"
#import "JuRichScanCameraVC.h"
#import "JuPlayVoice.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController (){
    JuPlayVoice *ju_playVoice;
}
@property (weak, nonatomic) IBOutlet UIImageView *juImageView;
@property (nonatomic, strong) AVAudioPlayer *player;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self shSetNew:2|1|3];
    // Do any additional setup after loading the view, typically from a nib.
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
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (IBAction)JuTakePhotos:(UIButton *)sender {
    if (sender.tag==1) {
        JuRichScanCameraVC *vc=[[JuRichScanCameraVC alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        JuTakePhotoCameraVC *vc=[[JuTakePhotoCameraVC alloc]init];
        vc.juCaptureType=JuCaptureOutputStillImage;
        [self presentViewController:vc animated:YES completion:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
