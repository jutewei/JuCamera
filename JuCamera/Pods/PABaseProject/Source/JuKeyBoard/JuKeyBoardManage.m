//
//  JuKeyBoardManage.m
//  PABase
//
//  Created by Juvid on 2018/9/20.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuKeyBoardManage.h"
#import "UIView+keyBoard.h"
#import "JuSystemDefine.h"

@implementation JuKeyBoardManage{
    __weak UIView *ju_textView;
    CGRect ju_moveVieRect;
    CGRect ju_textRect;
}
+ (instancetype) sharedInstance
{
    static JuKeyBoardManage *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];

    });
    return sharedInstance;
}
-(instancetype)init{
    self=[super init];
    if (self) {
    }
    return self;
}

-(void)juKeyboardStatus{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardFrame:)
                                                name:UIKeyboardWillChangeFrameNotification
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardHide:)
                                                name:UIKeyboardWillHideNotification
                                              object:nil];
    [self juDidBeginEditingNotificationName:UITextFieldTextDidBeginEditingNotification
                               didEndEditingNotificationName:UITextFieldTextDidEndEditingNotification];

    [self juDidBeginEditingNotificationName:UITextViewTextDidBeginEditingNotification
                        didEndEditingNotificationName:UITextViewTextDidEndEditingNotification];
               //  Registering for UITextView notification.
}

-(void)juDidBeginEditingNotificationName:(nonnull NSString *)didBeginEditingNotificationName
                     didEndEditingNotificationName:(nonnull NSString *)didEndEditingNotificationName
{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(juTextFieldViewDidBeginEditing:) name:didBeginEditingNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(juTextFieldViewDidEndEditing:) name:didEndEditingNotificationName object:nil];

}

-(void)juTextFieldViewDidBeginEditing:(NSNotification*)notification
{
    if (!_ju_moveView) return;
    ju_textView=notification.object;
    ju_textRect=[ju_textView convertRect:ju_textView.frame toView:ju_textView.window];
}

-(void)juTextFieldViewDidEndEditing:(NSNotification*)notification
{
    ju_textView=nil;
    ju_textRect=CGRectZero;
}

-(void)setJu_moveView:(UIView *)ju_moveView{
    if (ju_moveView) {
        [self juKeyboardStatus];
    }else{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
     ju_moveVieRect=CGRectZero;
     _ju_moveView=ju_moveView;
}

-(void)keyboardFrame:(NSNotification *)notification{

    if (!_ju_moveView) return;

    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardEndFrame;
    NSTimeInterval animationDuration;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    if (ju_moveVieRect.size.height==0) {
        ju_moveVieRect=_ju_moveView.frame;
        if (CGRectGetHeight(ju_moveVieRect)>Screen_Height-100) {///移动的视图高度大于屏幕高-100
            _isFullScreen=NO;
        }else{
            _isFullScreen=YES;
        }
    }
    CGRect moveViewframe=ju_moveVieRect;
    CGFloat keyboardHeight=keyboardEndFrame.size.height;
    if (_isFullScreen) {//整个视图移动（弹框视图）
        if (Screen_Height-CGRectGetMaxY(ju_moveVieRect)<keyboardHeight) {///< 移动到最底
            moveViewframe.origin.y=Screen_Height-keyboardHeight-CGRectGetHeight(ju_moveVieRect);
            _ju_moveView.frame=moveViewframe;
        }
        return;
    }
    if (CGRectGetMaxY(ju_textRect)>Screen_Height-keyboardHeight) {///< 文本框在键盘下方，移动到文本框位置
        moveViewframe.origin.y=moveViewframe.origin.y-(CGRectGetMaxY(ju_textRect)-(Screen_Height-keyboardHeight))-80;
        _ju_moveView.frame=moveViewframe;
    }
}
-(void)keyboardHide:(NSNotification *)notification{
    _ju_moveView.frame=ju_moveVieRect;
}

@end


