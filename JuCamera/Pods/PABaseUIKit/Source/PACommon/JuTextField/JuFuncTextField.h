//
//  SHUITextField.h
//  PABase
//
//  Created by Juvid on 16/5/17.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JuTextField.h"

typedef NS_ENUM(NSInteger,JuFuncForbidType) {
    JuFuncForbidNone,       ///< 正常
    JuFuncForbidPaste,     ///< 禁止粘贴
    JuFuncForbidCopy,     ///< 禁止复制
    JuFuncForbidAll,       ///< 禁止所有
};

//@interface JuFuncTextField : JuTextField
//
//@end

/////表情符号文本框
@interface JuForbidEmojiTextField : JuTextField
//
//
@end
//

@interface JuForbidTextField : JuTextField
@property JuFuncForbidType ju_funcType;
@end




