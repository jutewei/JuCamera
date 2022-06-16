//
//  JuScanVC.m
//  JuCamera
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2022/6/16.
//  Copyright © 2022 Juvid. All rights reserved.
//

#import "JuScanVC.h"
#import "JuPhotoPickers.h"
#import "JuDiscernQRVC.h"
#import "UIImage+PhotoManage.h"

@interface JuScanVC ()

@end

@implementation JuScanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor blackColor];
    
    __weak typeof(self) weakSelf = self;
    JuRichScanCameraVC *vc=[[JuRichScanCameraVC alloc]init];
    vc.ju_handle = ^(id  _Nullable result) {
        [weakSelf juSetReslut:result];
    };
    [self.view addSubview:vc.view];
    [self addChildViewController:vc];
    [self setBarLeftItem:[UIImage imageNamed:@"navRoundBack"]];
    [self setBarRightItem:@"相册"];
    // Do any additional setup after loading the view.
}
-(void)zlTouchRightItems:(UIButton *)sender{
    UIViewController *vc= [[JuPhotoPickers sharedInstance]juAlbumPick:JuPhotoAlbumImage maxNum:1 complete:^(NSArray *result) {
        [result.firstObject juGetDefault:^(UIImage *image) {
            [self juJumpLook:image];
        }];
      }];
    [self presentViewController:vc.parentViewController animated:YES completion:nil];
}

-(void)juJumpLook:(UIImage *)image{
    JuDiscernQRVC *vc=[JuDiscernQRVC juInitMainStoryVC];
    vc.ju_image=image;
    vc.zl_handleResult = ^(id  _Nullable result) {
        [self juSetReslut:result];
    };
    [self juPushViewController:vc];
}

-(void)juSetReslut:(NSString *)detectionString{
    if (self.ju_handle) {
        self.ju_handle(detectionString);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)zlSetManageConfig{
    [super zlSetManageConfig];
    self.ju_styleManage.zl_barStatus=JuNavBarStatusClear;
    self.ju_styleManage.zl_barItemColor=UIColor.whiteColor;
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
