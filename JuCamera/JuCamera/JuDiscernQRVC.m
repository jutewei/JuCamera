//
//  PADiscernQRVC.m
//  JuCamera
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2022/6/16.
//  Copyright © 2022 Juvid. All rights reserved.
//

#import "JuDiscernQRVC.h"
#import "MBProgressHUD+Share.h"

@interface JuDiscernQRVC ()
@property (nonatomic,weak) IBOutlet UIImageView *ju_imageView;
@end

@implementation JuDiscernQRVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=UIColor.blackColor;
    [self setBarLeftItem:[UIImage imageNamed:@"navRoundBack"]];
    _ju_imageView.image=_ju_image;

    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [self juGetQRImage:_ju_image];
}

-(void)juGetQRImage:(UIImage *)image{
    // CIDetector(CIDetector可用于人脸识别)进行图片解析，从而使我们可以便捷的从相册中获取到二维码
    // 声明一个 CIDetector，并设定识别类型 CIDetectorTypeQRCode
    // 创建图形上下文
    CIContext * context = [CIContext contextWithOptions:nil];
    // 创建自定义参数字典
    NSDictionary * param = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
    // 创建识别器对象
    CIDetector * detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:param];
    
    // 取得识别结果
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    
    if (features.count == 0) {
        [MBProgressHUD juShowHUDText:@"未发现二维码"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self zlTouchLeftItems:nil];
        });
    } else {
        NSString *resultStr = @"";
        for (int index = 0; index < [features count]; index++) {
            CIQRCodeFeature *feature = [features objectAtIndex:index];
            resultStr = feature.messageString;
            if (resultStr.length) {
                break;
            }
        }
        if (resultStr.length==0) {
            [MBProgressHUD juShowHUDText:@"未识别出内容"];
            [self zlTouchLeftItems:nil];
            return;
        }
        
        if (self.zl_handleResult) {
            self.zl_handleResult(resultStr);
        }
    }
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
