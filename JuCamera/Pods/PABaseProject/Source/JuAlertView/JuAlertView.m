//
//  JuAlertView.m
//  PABase
//
//  Created by Juvid on 2017/8/24.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import "JuAlertView.h"
//#import "JuStringsManager.h"
//#import "NSAttributedString+style.h"
#import "JuSystemDefine.h"

@implementation JuAlertView

// 新方法
/**
 单个按钮无回调
 */
+(JuAlertView *)juAlertTitle:(NSString *)title
                       message:(NSString *)message{
    return  [self juAlertTitle:title message:message handler:nil];
}
+(JuAlertView *)juAlertTitle:(NSString *)title message:(NSString *)message handler:(JuActionHandle)handler{
    return [self juAlertTitle:title message:message actionItems:@[@"确定"] handler:handler];
}
/**
 默认【确定】有回调【取消】有回调
 
 */
+(JuAlertView *)juDoubleAlert:(NSString *)title
                        message:(NSString *)message
                        handler:(JuActionHandle)handler{
    return [self juAlertTitle:title message:message actionItems:@[@"取消",@"确定"] handler:handler];
}

+(JuAlertView *)juAlertTitle:(NSString *)title
                       message:(NSString *)message
                   actionItems:(NSArray *)items
                       handler:(JuActionHandle)handler{
    return [self shAlertTitle:title message:message actionItems:items delegate:nil handler:handler];
}

+(JuAlertView *)shAlertTitle:(NSString *)title
                       message:(NSString *)message
                   actionItems:(NSArray *)items
                      delegate:(id<UIAlertViewDelegate>)delegate{
    return [self shAlertTitle:title message:message actionItems:items delegate:delegate handler:nil];
}

//+(JuAlertView *)juWarnAlert:(NSString *)keyName
//                      handler:(JuActionHandle)handler{
//    NSDictionary *dic=MTDiagLogWord(keyName);
//    return [JuAlertView juAlertTitle:dic[@"title"] message:dic[@"message"] actionItems:dic[@"action"] handler:handler];
//}

+(JuAlertView *)juAlertTitle:(NSString *)title
                  messageAttri:(NSAttributedString *)message
                   actionItems:(NSArray *)items
                       handler:(JuActionHandle)handler{
    JuAlertView *sh_alert=[self juAlertTitle:title message:message.string actionItems:items handler:handler];
//    NSMutableParagraphStyle * style = [NSAttributedString juParagraphLineSpace:5];
//    style.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString * mutableMessage = [[NSMutableAttributedString alloc] initWithAttributedString:message];
//    [mutableMessage addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, mutableMessage.length-1)] ;
    UILabel * messageLabel  = [sh_alert valueForKeyPath:@"alertController.view.messageLabel"];
    messageLabel.attributedText = mutableMessage ;
    return sh_alert;
}
+(JuAlertView *)shAlertTitle:(NSString *)title
                       message:(NSString *)message
                   actionItems:(NSArray *)items
                      delegate:(id<UIAlertViewDelegate>)delegate
                       handler:(JuActionHandle)handler{
    if (items.count==0)return nil;
    NSString *cancle =nil;
    NSMutableArray *arrButton=[NSMutableArray arrayWithArray:items];
    if ([arrButton containsObject:@"取消"]) {
        cancle=@"取消";
        [arrButton removeObject:cancle];
    }
    JuAlertView * alertview = [[JuAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancle otherButtonTitles:nil];
    if(handler){
        alertview.delegate=alertview;
        alertview.handler=handler;
    }
    for (int i=0; i<arrButton.count; i++) {
        [alertview addButtonWithTitle:arrButton[i]];
    }
    [alertview show];
    return alertview;
}
/**
 代理回调
 */
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (self.handler) {
        self.handler([JuAlertAction juSetTitle:[alertView buttonTitleAtIndex:buttonIndex] clickedIndex:buttonIndex]);
    }
    //    if(buttonIndex==alertView.cancelButtonIndex){
    //       if (self.callbackCancle) self.callbackCancle();
    //    }else if(buttonIndex==alertView.firstOtherButtonIndex){
    //        if (self.callbackOther) self.callbackOther();
    //    }
}



@end

@implementation JuActionSheet

+(JuActionSheet *)juSheetTitle:(NSString *)title
                   actionItems:(NSArray *)items
                      withView:(UIView *)view
                       handler:(JuActionHandle)handler{
    NSString *cancle =nil;
    NSString *destructive =nil;
    NSMutableArray *otherButton=[NSMutableArray arrayWithArray:items];
    if ([otherButton containsObject:@"取消"]) {
        cancle=@"取消";
        [otherButton removeObject:cancle];
    }
    if ([otherButton containsObject:@"删除"]) {
        destructive=@"删除";
        [otherButton removeObject:destructive];
    }
    JuActionSheet *sheet=[[JuActionSheet alloc]initWithTitle:title delegate:nil cancelButtonTitle:cancle destructiveButtonTitle:destructive otherButtonTitles:nil];
    
    if (handler) {
        sheet.handler=handler;
        sheet.delegate=sheet;
    }
    for (int i=0; i<otherButton.count; i++) {
        [sheet addButtonWithTitle:otherButton[i]];
    }
    
    [sheet showInView:view];
    return sheet;
}

+(id)juSheetTitle:(NSString *)title
      actionItems:(NSArray *)items
          handler:(JuActionHandle)handler{
    if (IS_ON_IPAD) {
        return  [JuAlertView juAlertTitle:title message:nil actionItems:items  handler:handler];
    }else{
        return [self juSheetTitle:title actionItems:items withView:[UIApplication sharedApplication].keyWindow handler:handler];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (self.handler) {
        if (IS_ON_IPAD) {
            __weak typeof(self) weakSelf = self;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                weakSelf.handler([JuAlertAction juSetTitle:[actionSheet buttonTitleAtIndex:buttonIndex] clickedIndex:buttonIndex]);
            }];
        }else{
            self.handler([JuAlertAction juSetTitle:[actionSheet buttonTitleAtIndex:buttonIndex] clickedIndex:buttonIndex]);
        }
    }
}

@end


@implementation JuAlertAction

+(id)juSetTitle:(NSString *)title clickedIndex:(NSInteger)buttonIndex{
    JuAlertAction *action=[JuAlertAction new];
    action.ju_title=title;
    action.ju_index=buttonIndex;
    return action;
}
-(BOOL)cancelButton{
    if ([self.ju_title isEqual:@"取消"]) {
        return YES;
    }
    return NO;
}
-(BOOL)otherButton{
    if (![self.ju_title isEqual:@"取消"]) {
        return YES;
    }
    return NO;
}
-(BOOL)confirmButton{
    if ([self.ju_title isEqual:@"确定"]) {
        return YES;
    }
    return NO;
}
-(BOOL)firstButton{
    if (self.ju_index==0) {
        return YES;
    }
    return NO;
}
@end


