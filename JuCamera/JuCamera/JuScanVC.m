//
//  JuScanVC.m
//  JuCamera
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2022/6/16.
//  Copyright © 2022 Juvid. All rights reserved.
//

#import "JuScanVC.h"
@interface JuScanVC ()

@end

@implementation JuScanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    JuRichScanCameraVC *vc=[[JuRichScanCameraVC alloc]init];
    vc.ju_handle = ^(id  _Nullable result) {
        [weakSelf juSetReslut:result];
    };
    [self.view addSubview:vc.view];
    [self addChildViewController:vc];
    [self setBarLeftItem:[UIImage imageNamed:@"navRoundBack"]];
    // Do any additional setup after loading the view.
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
