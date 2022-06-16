//
//  SHPopView.m
//  SHBaseProject
//
//  Created by Juvid on 16/5/17.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JuBasePopView.h"
#import "UIView+Frame.h"

@interface JuBasePopView (){
   
}
@property (nonatomic,strong)UIView *ju_view;
@end

@implementation JuBasePopView
@synthesize vieBox;

+(instancetype)initView:(UIView *)view{
    JuBasePopView *popView=[[self alloc]init];
    [popView juSetBaseView:view];
    return popView;
}

+(instancetype)initView{
  return   [self initView:nil];
}

-(void)juSetBaseView:(UIView *)view{
    self.backgroundColor=[UIColor clearColor];
    if (view) {
        self.ju_view=view;
    }
    vieBox=[[UIView alloc]init];
    vieBox.backgroundColor=JUColor_ContentWhite;
    [self addSubview:vieBox];
    [self juSetContentView];
    
}
-(void)juSetContentView{}

-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    if (self.superview) {
        self.juEdge(UIEdgeInsetsMake(0, 0, 0, 0));
    }
}

-(void)juShowView{
    if (self.ju_view) {
        [_ju_view addSubview:self];
    }else{
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
    }
}

-(void)juHideView{
   
}

- (void)juTouchBtnHandler:(UIButton *)sender {
    if (self.ju_callHandle) {
        self.ju_callHandle(sender.currentTitle);
    }
    [self juHideView];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end


@implementation JuBaseAlertView


+(instancetype)initView:(UIView *)view{
    JuBaseAlertView *popView=[[self alloc]init];
    [popView juSetBaseView:view];
    return popView;
}

+(instancetype)initView{
  return   [self initView:nil];
}

-(void)juSetContentView{
    [self.vieBox.layer setCornerRadius:10];
    [self.vieBox.layer setMasksToBounds:YES];
    self.vieBox.juOrigin(CGPointMake(0, 0));
    self.vieBox.juHeight.greaterEqual(80);
    self.vieBox.juWidth.equal(self.diaglogWidth);
}
-(CGFloat)diaglogWidth{
    return juDiaglog_Width;
}

-(void)setJu_Radius:(CGFloat)sh_Radius{
    [self.vieBox.layer setCornerRadius:sh_Radius];
}

-(void)juShowView{
    [super juShowView];
    self.vieBox.transform = CGAffineTransformMakeScale(1.1, 1.1);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.vieBox.transform = CGAffineTransformMakeScale(1, 1);
        self.backgroundColor=JUDarkBothColor(UINormalColorHexA(0x000000, 0.3), UINormalColorHexA(0x111111, 0.5));
    } completion:^(BOOL finished) {
        
    }];
}

-(void)juHideView{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@end

@implementation JuBaseSheetView

-(void)juSetContentView{
    self.vieBox.juHeight.greaterEqual(50);
    self.vieBox.juLead.equal(0);
    self.vieBox.juTrail.equal(0);
    self.vieBox.juBottom.equal(0);
}

-(void)juShowView{
    [super juShowView];
    self.vieBox.transform = CGAffineTransformMakeTranslation(0, self.ju_boxHeight+10);
    [UIView animateWithDuration:0.3 animations:^{
        self.vieBox.transform = CGAffineTransformMakeTranslation(0, 0);
        self.backgroundColor=JUDarkBothColor(UINormalColorHexA(0x000000, 0.3), UINormalColorHexA(0x111111, 0.5));
    } completion:^(BOOL finished) {
        
    }];
}
-(void)juHideView{
   
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor=[UIColor clearColor];
        self.vieBox.transform = CGAffineTransformMakeTranslation(0, self.ju_boxHeight+50);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    UIView *view=touches.anyObject.view;
    if ([view isEqual:self]) {
        [self juHideView];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
