//
//  JuTextField.m
//  PABase
//
//  Created by Juvid on 2020/3/2.
//  Copyright © 2020 Juvid. All rights reserved.
//

#import "JuTextField.h"
#define JuKey_pointNum @"0123456789."
@implementation JuTextField


-(instancetype)initWithCoder:(NSCoder *)coder{
    self=[super initWithCoder:coder];
    if (self) {
        self.ju_maximum=512;
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.ju_maximum=512;
    }
    return self;
}

-(void)setJu_maximum:(NSInteger)ju_maximum{
    if (ju_maximum>0) {
        _ju_maximum=ju_maximum;
    }
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    [self juSetBase];
}

-(void)juSetBase{
    self.delegate=self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(juTextFieldDidChang:) name:UITextFieldTextDidChangeNotification object:self];
}

-(BOOL)juTextFieldDidChang:(NSNotification *)notification{
    if (!self.userInteractionEnabled)   return YES;
    if (_isNumKeyboard)  return YES;

    if ([notification.object isEqual:self]) {///< 超过长度截取字符

        if ([self isPosition]) return YES;///< 判断长度忽略高光文本

        NSString *toBeString = self.text;
        NSInteger number = [toBeString length];

        if ([self.juDelegate respondsToSelector:@selector(juEnableButton:)]) {
            [self.juDelegate juEnableButton:number==_ju_maximum];
        }
        if (number > _ju_maximum) {
            self.text = [toBeString substringToIndex:_ju_maximum];
            [MBProgressHUD juShowTopHint:[NSString stringWithFormat:@"文字不得超出%ld字",(long)_ju_maximum]];
            return YES;
        }
    }
    return NO;
}

-(void)setIsNumKeyboard:(BOOL)isNumKeyboard{
    _isNumKeyboard=isNumKeyboard;
    self.keyboardType=isNumKeyboard?UIKeyboardTypeNumberPad:UIKeyboardTypeDefault;
}
-(void)setJu_pointNum:(NSInteger)ju_pointNum{
    _ju_pointNum=ju_pointNum;
    self.keyboardType=ju_pointNum?UIKeyboardTypeDecimalPad:UIKeyboardTypeNumberPad;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([self.juDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.juDelegate textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.returnKeyType!=UIReturnKeyNext) {
        [textField resignFirstResponder];
    }
    if ([self.juDelegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        [self.juDelegate textFieldShouldReturn:textField];
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (_isNumKeyboard) {
        if ([textField.text integerValue]==0&&_ju_pointNum==0&&_ju_minimum>0) {
            textField.text=[NSString stringWithFormat:@"%ld",(long)_ju_minimum];
        }
    }

    if ([self.juDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.juDelegate textFieldDidEndEditing:textField];
    }
    [self juSetText:textField.text];
}
- (BOOL)textFieldShouldClear:(UITextField *)textField;{
    [self juSetText:@""];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (_isNumKeyboard) {///数字键盘判断
        if (![string isEqualToString:@""]) {
            if (![self juPointKeyBoard:string]) {
                return NO;
            }
            NSMutableString *textStr=[NSMutableString stringWithString:textField.text];
            [textStr insertString:string atIndex:range.location];
            if ([textStr floatValue]>_ju_maximum) {///< 不能大于最大数
                return NO;
            }
            return [self isCheckPoint:textStr];

        }
        return YES;
    }
    else{

        if (range.location==0) {
            [self juSetText:string];
        }
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if (range.location >=_ju_maximum) {
            return self.isPosition;
        }
        return YES;
    }
}
//删除指定字符串
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if ([string isEqual:@""]) {
//        NSArray *arr=@[@"非常厉害",@"牛逼哄哄"];
//        for (NSString *string in arr) {
//              NSRange replaceRange = [textField.text rangeOfString:string];//查找字符串（返回一个结构体（起始位置及长度））
//            if (range.length+range.location<=replaceRange.location+replaceRange.length&&range.length+range.location>replaceRange.location) {
//                textField.text = [textField.text stringByReplacingCharactersInRange:replaceRange withString:@""];//截取子字符串方式
//                return NO;
//            }
//        }
//        return YES;
//    }
//    return YES;
//}
//// 判断是否满意要求的小数小数
-(BOOL)isCheckPoint:(NSString *)str{
    if (str.length==0)  return YES;

    NSString *Regex=nil;
    if (_ju_pointNum>0) {
        Regex=@"^[1-9]+[0-9]*$";
    }else{
//          Regex=[NSString stringWithFormat:@"^([0-9]|[0-9]\\.\\d{0,%ld}|[1-9]+[0-9]*|[1-9]+[0-9]*\\.\\d{0,%ld})$",(long)point,(long)point];
        //        第一位只能为0，y第一位为0第二位只能是小数点+小数，纯数字第一位不能为零，除数第一位不能为零，并且小数只能带小数只能是两位
        Regex=[NSString stringWithFormat:@"^[0-9](\\.?|\\.\\d{0,%ld})|[1-9]+[0-9]*(\\.?|\\.\\d{0,%ld})$",(long)_ju_pointNum,(long)_ju_pointNum];
    }
    NSPredicate *Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [Test evaluateWithObject:str];
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (_isNumKeyboard) {
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}
/**
 数字键盘
 */
-(BOOL)juPointKeyBoard:(NSString *)string{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:JuKey_pointNum] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
}
-(void)juSetText:(NSString *)string{
    if ([self.juDelegate respondsToSelector:@selector(juGetTextField:)]) {
        [self.juDelegate juGetTextField:string];
    }
}

-(BOOL)isEmptyWithTxtFld:(UITextField *)textField{
    if ([self.text isEqualToString:@""]&&![textField isEqual:self]) {
        return YES;
    }
    return NO;
}

-(BOOL)isPosition{
    UITextRange *selectedRange = [self markedTextRange];
    UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
    if (position) {
        return YES;
    }
    return NO;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation JuNumTextField

-(void)juSetBase{
    [super juSetBase];
    self.isNumKeyboard=YES;
}
@end

