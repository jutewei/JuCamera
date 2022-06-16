//
//  JuScanReslutVC.m
//  JuCamera
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2022/6/16.
//  Copyright © 2022 Juvid. All rights reserved.
//

#import "JuScanReslutVC.h"
#import "JuWebVC.h"

@interface JuScanReslutVC ()
@property (nonatomic,weak) IBOutlet UITextView *ju_textView;
@property (nonatomic,weak) IBOutlet UIButton *ju_btnNext;

@end

@implementation JuScanReslutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _ju_textView.textContainerInset=UIEdgeInsetsMake(5, 5, 5, 5);
    [_ju_textView.layer setCornerRadius:4];
    [_ju_textView.layer setMasksToBounds:YES];
    
    self.title = @"扫描结果";
    _ju_textView.text=_ju_result;
    NSURL *url=[NSURL URLWithString:_ju_result];
    if (url.scheme.length) {
        self.ju_btnNext.hidden = NO;
    }
    // Do any additional setup after loading the view.
}

- (IBAction)juTouchNext:(id)sender{
    NSURL *url=[NSURL URLWithString:_ju_result];
    if ([url.scheme hasPrefix:@"http"]) {
        JuWebVC *vc=[[JuWebVC alloc]init];
        vc.zl_url=_ju_result;
        [self juPushViewController:vc];
    }else{
        [[UIApplication sharedApplication]openURL:url];
    }
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
