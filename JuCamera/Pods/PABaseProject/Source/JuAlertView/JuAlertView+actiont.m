//
//  JuAlertView+actiont.m
//  PABase
//
//  Created by Juvid on 2017/8/24.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import "JuAlertView+actiont.h"
//#import "JuSharedInstance.h"
#import "JuSystemDefine.h"

@implementation JuAlertView (actiont)

+(UIAlertController *)juAlertControll:(NSString *)title
                           message:(NSString *)message{
    return [self juAlertControll:title message:message actionItems:@[@"确定"] handler:nil];
}
/**
 多个自定义按钮
 */
+(UIAlertController *)juAlertControll:(NSString *)title
                           message:(NSString *)message
                       actionItems:(NSArray *)items
                           handler:(void (^)(UIAlertAction *action))handler{
    return [self juAlertControllTitle:title message:message actionItems:items
                               withVC:self.topViewcontrol
                       preferredStyle:UIAlertControllerStyleAlert
                              handler:handler];
}

+(UIAlertController *)juAlertControll:(NSString *)title
                           message:(NSString *)message
                       actionItems:(NSArray *)items
                               withVC:(UIViewController *)vc
                              handler:(void (^)(UIAlertAction *action))handler{
    return [self juAlertControllTitle:title message:message actionItems:items
                               withVC:vc preferredStyle:UIAlertControllerStyleAlert handler:handler];
}

+(UIAlertController *)juSheetControll:(NSString *)title
                       actionItems:(NSArray *)items
                           handler:(void (^)(UIAlertAction *action))handler{
    return [self juAlertControllTitle:title message:nil actionItems:items
                               withVC:self.topViewcontrol
                       preferredStyle:UIAlertControllerStyleActionSheet handler:handler];
}

+(UIAlertController *)juSheetControll:(NSString *)title
                       actionItems:(NSArray *)items
                               withVC:(UIViewController *)vc
                           handler:(void (^)(UIAlertAction *action))handler{
    return [self juAlertControllTitle:title message:nil actionItems:items withVC:vc
                       preferredStyle:UIAlertControllerStyleActionSheet handler:handler];
}

+(UIAlertController *)juAlertControllTitle:(NSString *)title
                                     message:(NSString *)message
                                 actionItems:(NSArray *)items
                                      withVC:(UIViewController *)vc
                              preferredStyle:(UIAlertControllerStyle)preferredStyle
                                     handler:(void (^)(UIAlertAction *action))handle{
    UIAlertController *alertControll=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    NSInteger allCount=items.count;
    for (int i=0; i<allCount; i++) {
        //        NSInteger cancleNum=allCount-2;///< 多个按钮第一个为取消
        NSString *itemTitle=items[i];
        UIAlertAction *alertCancle=[UIAlertAction actionWithTitle:itemTitle style:[itemTitle isEqual:@"取消"]?UIAlertActionStyleCancel:([itemTitle isEqual:@"删除"]?UIAlertActionStyleDestructive:UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            if (handle)handle(action);
        }];
        [alertControll addAction:alertCancle];
    }
    UIPopoverPresentationController *popover=alertControll.popoverPresentationController;
    if (popover) {
        popover.sourceView=self.topViewcontrol.view;
        popover.sourceRect=CGRectMake(Screen_Width/2-100,Screen_Height/2-100, 200, 200);
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [vc presentViewController:alertControll animated:YES completion:nil];
    });
    
    return alertControll;
}



+(UIViewController *)topViewcontrol{
//    if (Ju_Share.topViewcontrol) {
//        return  Ju_Share.topViewcontrol;
//    }
    return [self mainWindow].rootViewController;
}

+(UIWindow *)mainWindow{
    UIWindow *window=[UIApplication sharedApplication].delegate.window;
    if (!window) {
        window=[UIApplication sharedApplication].windows.firstObject;
    }
    return window;
}
@end
