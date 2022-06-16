//
//  UIViewController+JuHud.m
//  PABase
//
//  Created by Juvid on 2017/8/23.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import "UIViewController+Hud.h"
#import "MBProgressHUD+Share.h"
#import <objc/runtime.h>

@implementation UIViewController (Hud)

static const void *HudCount = &HudCount;
static const char* ProgressHud="nsobject.ProgressHud";

-(NSInteger)hudCount{
    return [objc_getAssociatedObject(self, HudCount) intValue];
}

-(void)setHudCount:(NSInteger)hudCount{
    NSNumber *number = [[NSNumber alloc] initWithInteger:hudCount];
    objc_setAssociatedObject(self, HudCount, number, OBJC_ASSOCIATION_COPY);
}

-(id)progressHud{
    return objc_getAssociatedObject(self, &ProgressHud);
}

-(void)setProgressHud:(id)sh_ProgressHud{
    objc_setAssociatedObject(self, &ProgressHud, sh_ProgressHud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHUD:(NSString *)info{
    if (!self.progressHud) {
        self.progressHud=[[MBProgressHUD alloc]initWithView:self.view];
        self.progressHud.mode=MBProgressHUDModeIndeterminate;
        self.hudCount=0;

    }
    if (self.hudCount==0) {
        self.progressHud.alpha=0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.progressHud.alpha=1;
        });
    }
    self.hudCount++;
    self.progressHud.labelText = info;
    [self.view addSubview:self.progressHud];

}

-(void)finishHideHUD{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)hideHUD{
    self.hudCount--;
    if(self.hudCount<0){
        self.hudCount=0;
    }
    if (self.hudCount==0) {
        [self.progressHud show:NO];
        [self.progressHud removeFromSuperview];
    }
}

- (void)showWindowHUD:(NSString *)info{
    UIView *view=[UIApplication sharedApplication].windows.firstObject;
    MBProgressHUD *hud=[[MBProgressHUD alloc]initWithView:view];
    hud.mode=MBProgressHUDModeIndeterminate;
    hud.labelText = info;
    [view addSubview:self.progressHud];
    [hud show:YES];
}

- (void)hideWindowHud{
    UIView *view=[UIApplication sharedApplication].windows.firstObject;
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}

@end
