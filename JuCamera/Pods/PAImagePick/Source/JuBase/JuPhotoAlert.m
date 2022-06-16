//
//  JuPhotoAlert.m
//  TestImage
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/4/27.
//

#import "JuPhotoAlert.h"

@implementation JuPhotoAlert

+(UIAlertController *)juAlertTitle:(NSString *)title
                           message:(NSString *)message{
    return [self juAlertControllTitle:title message:message actionItems:@[@"确定"] preferredStyle:UIAlertControllerStyleAlert  withVC:self.topViewControll handler:nil];
}
+(UIAlertController *)juAlertTitle:(NSString *)title
                           message:(NSString *)message
                            withVc:(UIViewController *)vc{
    return [self juAlertControllTitle:title message:message actionItems:@[@"确定"] preferredStyle:UIAlertControllerStyleAlert  withVC:vc handler:nil];

}
+(UIAlertController *)juSheetControll:(NSString *)title
                          actionItems:(NSArray *)items
                              handler:(void (^)(UIAlertAction *action))handle{
    return [self juAlertControllTitle:title message:nil actionItems:items preferredStyle:UIAlertControllerStyleActionSheet withVC:self.topViewControll  handler:handle];
}
+(UIViewController *)topViewControll{
    return [UIApplication sharedApplication].keyWindow.rootViewController;;
}
+(UIAlertController *)juAlertControllTitle:(NSString *)title
                                     message:(NSString *)message
                                 actionItems:(NSArray *)items
                              preferredStyle:(UIAlertControllerStyle)preferredStyle
                                    withVC:(UIViewController *)vc
                                     handler:(void (^)(UIAlertAction *action))handle{
    UIAlertController *alertControll=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    NSInteger allCount=items.count;
    for (int i=0; i<allCount; i++) {
        NSString *itemTitle=items[i];
        UIAlertAction *alertCancle=[UIAlertAction actionWithTitle:itemTitle style:[itemTitle isEqual:@"取消"]?UIAlertActionStyleCancel:([itemTitle isEqual:@"删除"]?UIAlertActionStyleDestructive:UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            if (handle)handle(action);
        }];
        [alertControll addAction:alertCancle];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [vc presentViewController:alertControll animated:YES completion:nil];
    });
    return alertControll;
}

@end
