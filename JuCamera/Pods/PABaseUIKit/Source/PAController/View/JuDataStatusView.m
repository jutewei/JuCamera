//
//  JuDataStatusView.m
//  PABase
//
//  Created by Juvid on 2017/8/23.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import "JuDataStatusView.h"
#import "JuLayoutFrame.h"
#import "NSAttributedString+style.h"

@interface JuDataStatusView ()
@property (nonatomic ,strong)UIView *ju_View;
@end


@implementation JuDataStatusView
@synthesize ju_ImgView,ju_LabWarm,ju_btnFinish,ju_VieBox;


+(instancetype)initView:(UIView *)view{
    JuDataStatusView *sh_ViewSelf=[[JuDataStatusView alloc] init];
    [sh_ViewSelf shSetView:view];
    return sh_ViewSelf;
    
}
+(instancetype)initView{
    return [self initView:nil];
}
-(void)shSetView:(UIView *)view{
    if (view) {
        _ju_View=view;
        [_ju_View addSubview:self];
        self.juFrame(CGRectMake(0, 0, 0, 0));
    }
    self.userInteractionEnabled=NO;
    self.backgroundColor=[UIColor clearColor];
    _ju_boxY=CGRectGetHeight(self.frame)*0.01;
    ju_VieBox=[[UIView alloc]init];
    [self addSubview:ju_VieBox];
    ju_VieBox.juFrame(CGRectMake(0, _ju_boxY, 0, 100));
}
-(void)setJu_boxY:(CGFloat)sh_BoxY{
    ju_VieBox.ju_Top.constant=sh_BoxY;
}

-(void)juSetStatusView:(NSString *)message{
    [self juSetStatusView:message Image:nil withAction:nil];
}
-(void)juSetStatusView:(NSString *)message
                 Image:(NSString *)imageName{
    [self juSetStatusView:message Image:imageName withAction:nil];
}

-(void)juSetStatusView:(NSString *_Nullable)message
                 Image:(NSString *_Nullable)imageName
            withAction:(NSString *_Nullable)actName{
    
    if (self.hidden) return;
    [ju_LabWarm removeFromSuperview];
    [ju_btnFinish removeFromSuperview];
    [ju_ImgView removeFromSuperview];
    
    ju_VieBox.ju_Top.constant=_ju_boxY;
    if (imageName) {
        [self juSetImageView:actName];
        UIImage *image=[UIImage imageNamed:imageName];
        ju_ImgView.juSize(image.size);
        [ju_ImgView setImage:image];
    }
    if (message) {
        [self juSetWarmView:imageName withAction:actName];
        ju_LabWarm.attributedText=[NSMutableAttributedString  juGetSpaceString:message];
        ju_LabWarm.textAlignment=NSTextAlignmentCenter;
    }
    if (actName) {
        [self juSetButton];
        [ju_btnFinish setTitle:actName forState:UIControlStateNormal];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    ju_VieBox.ju_Height.constant=(MIN(CGRectGetHeight(self.frame), 300));
}
//图片说明
-(void)juSetImageView:(NSString *)actName{
    if (!ju_ImgView) {
        ju_ImgView =[[UIImageView alloc]init];
        ju_ImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
     [ju_VieBox addSubview:ju_ImgView];
    
    ju_ImgView.juCenterX.equal(0);
    ju_ImgView.juCenterY.equal(actName?-75:-45);
}
// 文字说明
-(void)juSetWarmView:(NSString *)imageName  withAction:(NSString *)actName{
    
    if (!ju_LabWarm) {
        ju_LabWarm=[[UILabel alloc]init];
        ju_LabWarm.textColor= JUDarkColorHex(0x888888);
        ju_LabWarm.numberOfLines=0;
    }
    
    [ju_VieBox addSubview:ju_LabWarm];
    
    ju_LabWarm.juLead.lessEqual(15);
    ju_LabWarm.juCenterX.equal(0);
    if (imageName) {
        ju_LabWarm.font=PAFFont_TitleText;
        ju_LabWarm.juTopSpace.toView(ju_ImgView).equal(16);
    }else{
        ju_LabWarm.font=PAFFont_TitleText;
        ju_LabWarm.juCenterY.equal(actName?-60:(imageName?-30:0));
    }
    
}
//事件
-(void)juSetButton{
    if (!ju_btnFinish) {
        self.userInteractionEnabled=YES;
        self.backgroundColor=JUColor_DarkWhite;
        ju_btnFinish=[UIButton buttonWithType:UIButtonTypeSystem];
        [ju_btnFinish addTarget:self action:@selector(juTouchFinish:) forControlEvents:UIControlEventTouchUpInside];
        ju_btnFinish.backgroundColor=UINormalColorHex(0xFF6633);
        [ju_btnFinish setTitleColor:PAColor_White forState:UIControlStateNormal];
        [ju_btnFinish.layer setCornerRadius:2];
        [ju_btnFinish.layer setMasksToBounds:YES];
        ju_btnFinish.contentEdgeInsets=UIEdgeInsetsMake(0, 14, 0, 14);
        ju_btnFinish.titleLabel.font=PAFFont_TitleText;
       
    }
   
    [ju_VieBox addSubview:ju_btnFinish];
    {
        ju_btnFinish.juCenterX.equal(0);
        ju_btnFinish.juHeight.equal(44);
        ju_btnFinish.juWidth.equal(165);
        ju_btnFinish.juTopSpace.toView(ju_LabWarm).equal(18);
    }
}
-(void)setJu_reLoad:(BOOL)sh_reLoad{
    _ju_reLoad=sh_reLoad;
    self.hidden=NO;
    self.userInteractionEnabled=YES;
}
//-(void)setSh_fail:(BOOL)sh_fail{
//    _sh_reLoad=sh_fail;
//    self.hidden=NO;
//    [self shSetStatusView:@"加载失败，请稍后重试"];
//}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self juReloadData];

}
//-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [super touchesEnded:touches withEvent:event];
//    [self juReloadData];
//}

-(void)juTouchFinish:(UIButton *)sender{
    if (self.ju_reLoad) {
        [self juReloadData];
        return;
    }
//    if(self.sh_CallFinish)
//        self.sh_CallFinish();
    if (self.ju_touchHandle) {
        self.ju_touchHandle(1);
    }
}
-(void)juReloadData{
    if (self.ju_reLoad) {
        self.ju_reLoad=NO;
        self.hidden=YES;
        self.userInteractionEnabled=NO;
        if (self.ju_touchHandle) {
            self.ju_touchHandle(0);
        }
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
