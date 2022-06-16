//
//  UIViewController+JuHud.h
//  PABase
//
//  Created by Juvid on 2017/8/23.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD+Share.h"
@interface UIViewController (Hud)
@property  NSInteger hudCount;
//@property (nonatomic, strong) MBProgressHUD *sh_VcHud;

@property(nonatomic,strong)MBProgressHUD *progressHud;

- (void)showHUD:(NSString *)info;
- (void)hideHUD;
- (void)finishHideHUD;

/**
 全屏

 @param info 提示信息
 */
- (void)showWindowHUD:(NSString *)info;
- (void)hideWindowHud;
@end
