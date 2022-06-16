//
//  PAFuncTextField.m
//  PAZLChannelCar
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2022/3/16.
//  Copyright © 2022 pingan. All rights reserved.
//

#import "PAForbidTextField.h"

@implementation PANoCopyTextField

-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        self.ju_funcType=JuFuncForbidCopy;
    }
}
//-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
//    if (action == @selector(cut:))  return NO;
//    else if (action == @selector(copy:)) return NO;
//    return [super canPerformAction:action withSender:sender];
//}

@end


@implementation PANoPasteTextField

-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        self.ju_funcType=JuFuncForbidPaste;
    }
}
//-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
//    if (action == @selector(paste:))  return NO;
//    return [super canPerformAction:action withSender:sender];
//}

@end

@implementation PANoFuncTextField

-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        self.ju_funcType=JuFuncForbidAll;
    }
}

//-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
//    return NO;
//}

@end
