//
//  JuBasePickView.m
//  JuBasePickView
//
//  Created by Juvid on 15/12/15.
//  Copyright © 2015年 Juvid(zhutianwei). All rights reserved.
//

#import "JuBasePickView.h"
#import "UIView+borderLayer.h"
@interface JuBasePickView()

@property (nonatomic,copy)JuHandleWithData ju_handleData;
@property BOOL juIsHide;///< 是否已隐藏
@property (nonatomic,strong)UIView *ju_supView;

@end

@implementation JuBasePickView
-(id)init{
    self=[super init];
    if (self) {
        self.frame=CGRectMake(0, Screen_Height, Screen_Width, self.juPickHeight);
        self.juIsHide=YES;
        [self juSetPickBar];
        [self juSetPickView];
        ju_outputModel=[[JuOutputDataModel alloc]init];
    }
    return self;
}
-(void)juSetPickView{

}
-(void)setJuCanNoCancel:(BOOL)juCanNoCancel{
    _juCanNoCancel=juCanNoCancel;
    if (_juCanNoCancel) {
//        ju_navigationItem.leftBarButtonItem=nil;
    }
}
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view=[super hitTest:point withEvent:event];
    if (!view&&self.superview) {
        [self juHidePick];
        return self;
    }
    return view;
}
+(instancetype)initWitBackHandle:(JuHandleWithData)handleData{
    JuBasePickView *pick=[[[self class] alloc]init];
    pick.ju_handleData = handleData;
    return pick;
}

+(instancetype)initWithView:(UIView *)view backHandle:(JuHandleWithData)handleData{
    JuBasePickView *pick=[[[self class] alloc]init];
    pick.ju_handleData=handleData;
    if (view) {
        pick.ju_supView=view;
    }
    return pick;
}

+(instancetype)initWindowHandle:(JuHandleWithData)handleData{
    JuBasePickView *pick=[[[self class] alloc]init];
    pick.ju_handleData=handleData;

    UIView *view=[[UIView alloc]init];
    view.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
    [[UIApplication sharedApplication].delegate.window addSubview:view];
    view.juEdge(UIEdgeInsetsMake(0, 0, 0, 0));
    pick.ju_supView=view;
    return pick;
}

-(void)setJu_navTitle:(NSString *)ju_navTitle{
    ju_labTitle.text=ju_navTitle;
    _ju_navTitle=ju_navTitle;
}

-(CGFloat)juPickHeight{
    return 0;
}

-(void)juWillFinishData{

}

-(void)juSetPickBar{
    CGFloat navbarH=51;
    ju_navigationBar=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, navbarH)];
//    ju_navigationBar.barStyle=UIBarStyleBlackTranslucent;
    ju_navigationBar.backgroundColor=JUDarkColorHex(0xffffff);
    [self addSubview:ju_navigationBar];
    ju_labTitle=[[UILabel alloc]init];
    ju_labTitle.font=[UIFont boldSystemFontOfSize:16];
    ju_labTitle.textColor=UINormalColorHex(0x333333);
//    ju_navigationBar.titleTextAttributes= @{NSForegroundColorAttributeName: MFColorWhite(0.2,1), NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    [ju_navigationBar addSubview:ju_labTitle];

    [ju_navigationBar juSetRadii:10 byRoundingCorners:CornersDirectionTop];
    ju_labTitle.juOrigin(CGPointMake(0, 0));

    UIButton *buttonLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 62, 22)];
    buttonLeft.backgroundColor = [UIColor clearColor];
    buttonLeft.titleLabel.font = [UIFont systemFontOfSize:16];
    [buttonLeft setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [buttonLeft setTitle:@"取消" forState:UIControlStateNormal];
    [buttonLeft addTarget:self action:@selector(juPressCancle:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *buttonRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 62, 22)];
    buttonRight.backgroundColor = [UIColor clearColor];
    buttonRight.titleLabel.font = [UIFont systemFontOfSize:16];
    [buttonRight setTitleColor:PAColor_Main forState:UIControlStateNormal];
    [buttonRight setTitle:@"完成" forState:UIControlStateNormal];
    [buttonRight addTarget:self action:@selector(juPressTure:) forControlEvents:UIControlEventTouchUpInside];

    [ju_navigationBar addSubview:buttonLeft];
    buttonLeft.juFrame(CGRectMake(0.01, 0, 60, 0));
    
    [ju_navigationBar addSubview:buttonRight];
    buttonRight.juFrame(CGRectMake(-0.01, 0, 60, 0));

}

-(void)juShowPick{
    if(!self.juIsHide)return;
    _juIsHide=NO;
    if (self.ju_supView) {
        [self.ju_supView addSubview:self];
        self.juFrame(CGRectMake(0, -0.01, 0, self.juPickHeight));
        [self.ju_supView layoutIfNeeded];
        self.transform=CGAffineTransformMakeTranslation(0, self.juPickHeight);
    }
    [self.superview endEditing:YES];

    [UIView animateWithDuration:0.3 animations:^(void) {
        self.transform=CGAffineTransformMakeTranslation(0, 0);
    }];
}
-(void)juHidePick{
    if (self.ju_supView) {
        if(self.juIsHide)return;
        _juIsHide=YES;
        [UIView animateWithDuration:0.25
                         animations:^(void) {
            self.transform=CGAffineTransformMakeTranslation(0, self.juPickHeight);
                         } completion:^(BOOL finished) {
                             [self.ju_supView removeFromSuperview];
                         }];
    }
    else{
        [self.window endEditing:YES];
    }

}

-(void)juPressCancle:(UIBarButtonItem *)sender{
    [self juHidePick];
}

-(void)juPressTure:(UIBarButtonItem *)sender{
    [self juDidFinishData];
    [self juHidePick];
}

-(void)juDidFinishData{
    [self juWillFinishData];
    if (self.ju_handleData) {
        self.ju_handleData(ju_outputModel);
    }
}
@end
