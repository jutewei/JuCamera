//
//  MBProgressHUD+Share.m
//  PABase
//
//  Created by Juvid on 2016/11/18.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "MBProgressHUD+Share.h"
@implementation MBProgressHUD (Share)
/***********************************************/
//初始化
+(MBProgressHUD *)juShowHUDShare:(UIView *)view {
    static MBProgressHUD *HUD=nil;
    static dispatch_once_t onceToken;
    if (view) {
        dispatch_once(&onceToken, ^{
            HUD=[[MBProgressHUD alloc] initWithFrame:view.frame];
        });
        if (![view isKindOfClass:[UIWindow class]]) {
            HUD.frame=view.frame;
            [HUD show:YES];
            HUD.mode=MBProgressHUDModeIndeterminate;
            [view addSubview:HUD];
        }
    }
    return HUD;
}
//自动消失弹框
+(MBProgressHUD *)juShowHUDText:(NSString *)str{
    return [self juShowHUDText:str withStaus:nil];
}
+(MBProgressHUD *)juShowHUDCenter:(NSString *)str{
    return [self juShowHUDText:str withStaus:nil afterDelay:2.5];
}

+(MBProgressHUD *)juShowHUDCenter:(NSString *)str afterDelay:(NSTimeInterval)delay{
    MBProgressHUD *HUD=[self juShowHUDText:str withStaus:nil afterDelay:delay];
    HUD.yOffset = 0;
    return HUD;
}

+(MBProgressHUD *)juShowHUDText:(NSString *)str withStaus:(NSString *)status{
    return [self juShowHUDText:str withStaus:status afterDelay:2.5];
}

+(MBProgressHUD *)juShowHUDText:(NSString *)str withStaus:(NSString *)status afterDelay:(NSTimeInterval)delay{
    __block  MBProgressHUD *HUD;
    dispatch_async(dispatch_get_main_queue(),^{
        HUD=[self juShowHUDOnMain:str withStaus:status afterDelay:delay];
    });
    return HUD;
}

+(MBProgressHUD *)juShowHUDOnMain:(NSString *)str withStaus:(NSString *)status afterDelay:(NSTimeInterval)delay{

    UIWindow* window = [UIApplication sharedApplication].windows.firstObject;
//    if (window.hidden||[NSStringFromClass([window class]) isEqual:@"JuWindow"]) {
//        window=[UIApplication sharedApplication].windows.firstObject;
//    }
    MBProgressHUD *HUD=[MBProgressHUD juShowHUDShare:window];
    HUD.userInteractionEnabled = YES;
    if (status) {
        HUD.mode=MBProgressHUDModeCustomView;
        HUD.customView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:status]];
        HUD.margin = 20.f;
        HUD.yOffset = -5.0f;
    }else{
        HUD.mode=MBProgressHUDModeText;
        HUD.margin = 10.f;
        HUD.yOffset = -60;
    }
    NSRange range = [str rangeOfString:@"\n"];//判断字符串是否包含
    if (range.location !=NSNotFound&&str){//包含
        HUD.labelText=@"";
        HUD.detailsLabelText= str;
    }else{
        if (str.length>0) {
//            if (str.length>200) {
            HUD.labelText=@"";
            HUD.detailsLabelFont=[UIFont systemFontOfSize:15];
            HUD.detailsLabelText=str;
//            }
//            else{
//                HUD.labelText=str;
//                HUD.detailsLabelText=@"";
//            }
        }
        else {
            if (str) {///< 无内容不显示HUD
                return nil;
            }else{
                HUD.labelText=@"网络异常，请稍后重试";
            }
            HUD.detailsLabelText=@"";
        }
    }
    [window addSubview:HUD];
    [HUD show:YES];
    [HUD hide:YES afterDelay:delay];
    HUD.removeFromSuperViewOnHide = YES;
    return HUD;
}
+(void )juShowWindowHUD:(NSInteger)tag{
    dispatch_async(dispatch_get_main_queue(),^{
        MBProgressHUD *hud=[[UIApplication sharedApplication].windows.firstObject viewWithTag:tag];
        if (!hud) {
            hud=[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].windows.firstObject animated:YES];
        }
        hud.color=[UIColor colorWithWhite:0.5 alpha:0.8];

        hud.removeFromSuperViewOnHide = YES;
        hud.tag=tag;
        hud.labelText=nil;
    });
}
+(void)juShowHideHUD:(NSInteger)tag{
    dispatch_async(dispatch_get_main_queue(),^{
        MBProgressHUD *hud=[[UIApplication sharedApplication].windows.firstObject viewWithTag:tag];
        if (hud) {
            [hud hide:YES];
            [hud removeFromSuperview];
        }
    });
}
//直接消失
+(void)juHideLoadHUD{
    dispatch_async(dispatch_get_main_queue(),^{
        UIWindow* window = [UIApplication sharedApplication].windows.firstObject;
        [MBProgressHUD hideAllHUDsForView:window animated:YES];
    });
}
+ (MBProgressHUD *)juShowHUDLoad:(NSString *)info{
    __block  MBProgressHUD *hud;
    dispatch_async(dispatch_get_main_queue(),^{
        UIWindow* window = [UIApplication sharedApplication].windows.firstObject;
        hud=[[MBProgressHUD alloc] initWithFrame:window.frame];;
        hud.labelText = info;
        hud.mode=MBProgressHUDModeIndeterminate;
        hud.frame=window.frame;
        hud.removeFromSuperViewOnHide = YES;
        [window addSubview:hud];
        [hud show:YES];
    });
     return hud;
}

+(MBProgressHUD *)juShowTopHint:(NSString *)str{
    if (str.length==0)   return nil;
    int count=(int)[UIApplication sharedApplication].windows.count;
    UIWindow* window = nil;
    for (int i= count-1; i>=0; i--) {
        window=[UIApplication sharedApplication].windows[i];
        if (!window.hidden) {
            break;
        }
    }
    MBProgressHUD *HUD=[[MBProgressHUD alloc] initWithFrame:window.frame];
//    HUD.yOffset = -80;
    HUD.margin=12;
    HUD.mode=MBProgressHUDModeText;
    HUD.userInteractionEnabled = NO;
    if (str.length>14) {
        HUD.labelText=@"";
        HUD.detailsLabelText=str;
    }
    else{
        HUD.labelText=str;
        HUD.detailsLabelText=@"";
    }
    [window addSubview:HUD];
    [HUD show:YES];
    [HUD hide:YES afterDelay:3];
    HUD.removeFromSuperViewOnHide = YES;
    return HUD;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.mode==MBProgressHUDModeText) {
        [self show:NO];
        [self removeFromSuperview];
    }
}
/***********************************************/
@end
