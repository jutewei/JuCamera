//
//  SHUITextField.m
//  PABase
//
//  Created by Juvid on 16/5/17.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JuFuncTextField.h"
#import "UIView+Frame.h"
#import "NSString+emoji.h"

//@implementation JuFuncTextField
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if ([string isEqualToString:@""]) {
//        return YES;
//    }
//    if (textField.text.length>=self.ju_maximum&&![self isPosition]) {
//        return NO;
//    }
//    return YES;
//}
//
//@end

@implementation JuForbidEmojiTextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (string.isContainsEmoji) {
        return NO;
    }
    return YES;
}

//
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.text=[textField.text juDisableEmoji];
}

@end
//

@implementation JuForbidTextField

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (self.inputView||self.ju_funcType==JuFuncForbidPaste) {
        if (action == @selector(paste:))  return NO;
    }
    else if(self.ju_funcType==JuFuncForbidCopy){
        if (action == @selector(copy:)||action == @selector(cut:)) {
            return NO;
        }
    }
    else if (self.ju_funcType==JuFuncForbidAll){
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}

@end



