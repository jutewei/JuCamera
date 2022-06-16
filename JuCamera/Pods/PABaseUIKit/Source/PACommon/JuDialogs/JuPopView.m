//
//  SHPopView.m
//  SHBaseProject
//
//  Created by Juvid on 16/5/17.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JuPopView.h"
#import "UIView+Frame.h"
@interface JuPopView (){
   
}
@property (nonatomic,strong)UIView *ju_view;
@end

@implementation JuPopView
@synthesize ju_vieBox;
+(instancetype)initView:(UIView *)view{
    JuPopView *popView=[[self alloc]init];
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
    ju_vieBox=[[UIView alloc]init];
    ju_vieBox.backgroundColor=JUColor_ContentWhite;
    [ju_vieBox.layer setCornerRadius:7];
    [ju_vieBox.layer setMasksToBounds:YES];
    [self addSubview:ju_vieBox];
    ju_vieBox.juOrigin(CGPointMake(0, 0));
    ju_vieBox.juWidth.equal(self.diaglogWidth);
    ju_vieBox.juHeight.greaterEqual(80);

}
-(CGFloat)diaglogWidth{
    return juDiaglog_Width;
}
-(void)setSh_Radius:(CGFloat)sh_Radius{
    [ju_vieBox.layer setCornerRadius:sh_Radius];
}

-(void)juShowView{
    ju_vieBox.center=self.center;
    if (self.ju_view) {
        [_ju_view addSubview:self];
    }else{
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
    }
    self.juEdge(UIEdgeInsetsMake(0, 0, 0, 0));
    [self.superview layoutIfNeeded];
    [self layoutIfNeeded];
    
    ju_vieBox.transform = CGAffineTransformMakeScale(1.1, 1.1);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        ju_vieBox.transform = CGAffineTransformMakeScale(1, 1);
        self.backgroundColor=JUDarkBothColor(UINormalColorHexA(0x000000, 0.3), UINormalColorHexA(0x111111, 0.5));
    } completion:^(BOOL finished) {
        
    }];
}
-(void)juHideView{
   
//    UIView *vieBack=[self viewWithTag:112];
//    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        vieBox.transform = CGAffineTransformMakeScale(0, 0);
//        vieBack.alpha=0;
//    } completion:^(BOOL finished) {
        [self removeFromSuperview];
//    }];
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
