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
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *juImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)JuTakePhotos:(UIButton *)sender {
    if (sender.tag==1) {
        JuRichScanCameraVC *vc=[[JuRichScanCameraVC alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        JuTakePhotoCameraVC *vc=[[JuTakePhotoCameraVC alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
