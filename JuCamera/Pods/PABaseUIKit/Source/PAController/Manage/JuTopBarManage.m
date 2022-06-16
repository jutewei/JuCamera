//
//  JuBaseDataManage.m
//  PABase
//
//  Created by Juvid on 2019/12/5.
//  Copyright © 2019 Juvid. All rights reserved.
//

#import "JuTopBarManage.h"

@implementation JuTopBarManage

@synthesize zl_topBarView=_zl_topBarView;

-(instancetype)init{
    self=[super init];
    if (self) {
        self.zl_barLeftImage=@"main_NavBarBack";
        self.zl_barCloseImage=@"main_navBarClose";
        self.zl_barLeftLightImg=@"navbarBackWhite";
        self.zl_barAlpha=1;
        self.zl_barItemFont=JUFont_NaviTitleM;
//        self.mt_topBarColor=JUColor_ContentWhite;
    }
    return self;
}

-(UIColor *)zl_barLineColor{
    if (_zl_barLineColor) {
        return _zl_barLineColor;
    }
    return [UIColor clearColor];
}

-(UIColor *)zl_barItemColor{
    if (_zl_barItemColor) {
        return _zl_barItemColor;
    }
    return self.zl_barStatus==JuNavBarStatusClear?JuColor_WhiteGray:UINormalColorHex(0x333333);
}

-(void)setZl_changeBarPoint:(CGFloat)mt_changeBarPoint{
    _zl_changeBarPoint=mt_changeBarPoint;
    if (_zl_changeBarPoint>0&&self.zl_barStatus==JuNavBarStatusNone) {
        self.zl_barStatus=JuNavBarStatusClear;
    }
}
-(JUStatusBarStyle)zl_statusBarStyle{
    if (_zl_statusBarStyle) {
        return _zl_statusBarStyle;
    }
//    透明色直接用白色状态栏
    if (self.zl_barStatus==JuNavBarStatusClear) {
        return JUStatusBarStyleLight;
    }
    return self.zl_barStatus>=JuNavBarStatusHidden&&self.zl_barAlpha<0.7;
}
-(BOOL)isLightStyle{
//    未赋值导航栏透明时未白色
    return self.zl_statusBarStyle==JUStatusBarStyleLight;
}

-(UILabel *)titleView{
//    if (!_titleView) {
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Screen_Width-100, 44)];
    [titleView setTextColor:self.zl_barTitleColor];
    titleView.textAlignment=NSTextAlignmentCenter;
    titleView.font = self.zl_barItemFont;
//    }
    return titleView;
}

-(void)setZl_barAlpha:(CGFloat)mt_barAlpha{
    _zl_barAlpha=mt_barAlpha;
    self.zl_topBarView.ju_alpha=mt_barAlpha;
}

-(void)zlTopBarView:(UIViewController *)supvc{
    if (!_zl_topBarView) {
        _zl_topBarView=[JuTopBarView initWithVC:supvc];
//        [_zl_topBarView setLargeTitles:_zl_largeTitles withHeight:_zl_largeTitleHeight];
        _zl_topBarView.ju_showColor=self.zl_barLineColor;
        if (self.zl_topBarImage) {
            _zl_topBarView.ju_backImage=self.zl_topBarImage;
        }else if (self.zl_topBarColor) {
            _zl_topBarView.ju_backColor=self.zl_topBarColor;
        }
 
        if (self.zl_cunstomTitleView) {
            _zl_topBarView.ju_titleView=self.zl_cunstomTitleView;
        }
        if (self.zl_barStatus==JuNavBarStatusClear||self.zl_barStatus==JuNavBarStatusHidden) {
            self.zl_barAlpha=0;
        }
    }
}

-(void)zlResetTopbar{
    [_zl_topBarView removeFromSuperview];
    _zl_topBarView=nil;
}

-(UIColor *)zl_barTitleColor{
    if (_zl_barTitleColor) {
        return _zl_barTitleColor;
    }else if (self.zl_barStatus==JuNavBarStatusLarge){
        return JUColor_BlackBlack;
    }
    return  JUColor_DarkWhite;
}

-(void)setZl_largeTitles:(id)ju_largeTitles{
    _zl_largeTitles=ju_largeTitles;
    self.zl_barStatus=JuNavBarStatusLarge;
}

-(void)dealloc{
    ;
}

@end


@implementation NSString (image)

- (UIImage *)image{
    return [UIImage imageNamed:self];
}
@end
