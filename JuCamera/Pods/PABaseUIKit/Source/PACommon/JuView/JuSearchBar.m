//
//  KKSearchBar.m
//  KKSearchBar
//
//  Created by Leo on 15/6/17.
//  Copyright (c) 2015年 Juvid(zhutianwei). All rights reserved.
//

#import "JuSearchBar.h"
//#import "NSAttributedString+style.h"
#import "JuLayoutFrame.h"

#define textLeftSpace 32


@implementation JuSearchTextField{
    NSString *ju_currentText;
}

#pragma mark - Private methods

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(textLeftSpace , 0 , CGRectGetWidth(bounds) - textLeftSpace, CGRectGetHeight(bounds));
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return CGRectMake(textLeftSpace , 0 , CGRectGetWidth(bounds) - textLeftSpace-5, CGRectGetHeight(bounds));
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(textLeftSpace , 0, CGRectGetWidth(bounds) - textLeftSpace, CGRectGetHeight(bounds));
}

-(BOOL)shTextFieldDidChang:(NSNotification *)notification{
    BOOL position=self.isPosition;
    if (_searchType==JuSearchTypeNone||(_searchType==JuSearchTypeWord&&position)) {
//        if (position) {//有高亮不进行操作
        return NO;
//        }
    }
//    else if(_searchType==JuSearchTypeNone){
//        return NO;
//    }

    // 或者文本无变化
    if ([ju_currentText isEqual:self.text]) return NO;

    if (position) {
        ju_currentText=[self.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }else{
        ju_currentText=self.text;
    }

    if ([self.juDelegate respondsToSelector:@selector(juGetTextField:)]) {
        [self.juDelegate juGetTextField:ju_currentText];
    }
    return YES;
}

@end


@implementation JuSearchBar

-(void)awakeFromNib{
    [super awakeFromNib];
    [self juInitView];
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self juInitView];
    }
    return self;
}

-(void)juInitView{

    self.backgroundColor = [UIColor clearColor];
    _textField = [[JuSearchTextField alloc] init];
    _textField.juDelegate=self;
    [_textField.layer setMasksToBounds:YES];
    _textField.returnKeyType = UIReturnKeySearch;
    _textField.font = [UIFont systemFontOfSize:14];
//    _textField.tintColor=MFColor_MainGreen;
    _textField.textColor = PAColor_BlackGray;
    _textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _textField.backgroundColor = JUDarkColorWhiteA(0.96, 1);
    [self addSubview: _textField];

    _tipImageView = [[UIImageView alloc] init];
    _tipImageView.image = [UIImage imageNamed: @"search_icon"];
    [_textField addSubview: _tipImageView];

}
-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    if (self.superview) {
        _textField.juOrigin(CGPointMake(_ju_space, 0));
        _textField.juHeight.equal(self.ju_searchHeight);
        if (_showCancel==1) {
            _textField.juTrail.equal(60);
        }else{
            _textField.juTrail.equal(_ju_space);
        }
         [_btnCancel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        _tipImageView.juOrigin(CGPointMake(12, 0));
    }
    _textField.delegate = self;

}
- (void)layoutSubviews{
    [super layoutSubviews];
    [_textField.layer setMasksToBounds:YES];
    [_textField.layer setCornerRadius:2];
}

-(CGFloat)ju_space{
    if (_ju_space==0) {
        return 15;
    }
    return _ju_space;
}
-(CGFloat)ju_searchHeight{
    if (_ju_searchHeight==0) {
        return 30;
    }
    return _ju_searchHeight;
}
-(void)setIsBecomeFirstResponder:(BOOL)sh_becomeFirstResponder{
    if (sh_becomeFirstResponder) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self->_textField becomeFirstResponder];
        });
    }
    else{
         [_textField resignFirstResponder];
    }
}
-(void)setUnableEidt:(BOOL)isCanNotEidt{
    _unableEidt=isCanNotEidt;
    _textField.userInteractionEnabled=!isCanNotEidt;
}
-(void)setShowCancel:(NSInteger)isShowCancel{
    _showCancel=isShowCancel;
    if (_showCancel&&!_btnCancel) {
        _btnCancel=[[UIButton alloc]init];
        [_btnCancel setTitleColor:MFColor_LightGray forState:UIControlStateNormal];
        _btnCancel.titleLabel.font=[UIFont systemFontOfSize:16];
        [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [_btnCancel addTarget:self action:@selector(juTouchCancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnCancel];
        _btnCancel.juOrigin(CGPointMake(-15, 0));
        _btnCancel.juWidth.greaterEqual(38);
    }
    if (_showCancel==2) {
        _btnCancel.alpha=0;
    }
}

-(void)juTouchCancel{
    [_textField resignFirstResponder];
    _textField.text=@"";
    [self juSetSearchText:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_unableEidt) {
        [self juSetSearchText:nil];
    }
}
#pragma mark - Public methods
-(void)juGetTextField:(NSString *)strText{
    if ([self.juDelegate respondsToSelector:@selector(textFieldSearchResult:)]) {
        [self.juDelegate textFieldSearchResult:strText];
    }
    [self juSetSearchText:strText];
}
-(void)juSetSearchText:(NSString *)strText{
    if (_searchHandle) {
        _searchHandle(strText);
    }
}

#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [self juKeyBoardIsShow:NO];
    if ([self.juDelegate respondsToSelector:@selector(textFieldEndEditing:)]) {
        [self.juDelegate textFieldEndEditing:textField];
    }
    return true;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self juKeyBoardIsShow:YES];
    if ([self.juDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        [self.juDelegate textFieldShouldBeginEditing:textField];
    }
    [self juGetTextField:textField.text];
    return YES;
}

-(void)juKeyBoardIsShow:(BOOL)isShow{
    if (_showCancel!=2) {
        return;
    }
    if (isShow) {
        _textField.ju_Trail.constant = 60;
    }else{
        _textField.ju_Trail.constant = _ju_space;
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self->_textField.superview layoutIfNeeded];
        self->_btnCancel.alpha=isShow?1:0;
    }completion:^(BOOL finished) {
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

-(void)textFieldShouldClear{
    _textField.text=@"";
    [self textFieldShouldClear:_textField];
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    [self juGetTextField:@""];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [self juSetSearchText:textField.text];
    [textField resignFirstResponder];
    if ([self.juDelegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        [self.juDelegate textFieldShouldReturn:textField];
    }
    return YES;
}
@end
