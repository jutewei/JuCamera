//
//  SHDoublePopView.m
//  SHBaseProject
//
//  Created by Juvid on 16/5/17.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JuImgDiaglogView.h"
#import "JuCellLine.h"
#import "UIView+Frame.h"
#import "UIView+textBounds.h"
#import "UIView+drawGradient.h"
#import "PAMainColor.h"

@implementation JuImgDiaglogView{

}

-(void)juDiaglogWithKey:(NSString *)keyName
             message:(id)messae
              handle:(JuCallHandle)handle{
    NSDictionary *dic=MTDiagLogWord(keyName);
    if(!dic[@"action"])return;
    [self juDiaglogTitle:dic[@"title"] message:messae?messae:dic[@"message"]  items:dic[@"action"] handle:handle];
}

-(void)juDiaglogTitle:(NSString *)title
              message:(id)message
               handle:(JuCallHandle)handle{
    [self juDiaglogTitle:title message:message items:@[@"取消",@"确定"] handle:handle];
}

-(CGFloat)diaglogWidth{
    return 280;
}

-(void)juDiaglogTitle:(NSString *)title
              message:(id)messae
                items:(NSArray *)arrButton
               handle:(JuCallHandle)handle{
    [self juSetTitle:title];
    [self juSetContent:messae];
    [self juSetTouchItem:arrButton];
    [self juShowView];
    self.ju_callHandle=handle;
}

-(void)juDiaglogImage:(NSString *)imageName
              message:(id)messae
                items:(NSArray *)arrButton
               handle:(JuCallHandle)handle{
    [self juSetImage:imageName];
    [self juSetContent:messae];
    [self juSetTouchItem:arrButton];
    [self juShowView];
    self.ju_callHandle=handle;
}

-(void)juSetTouchItem:(NSArray *)arrTitel{
    self.ju_vieBox.backgroundColor=JUDarkBothColorHex(0xffffff, 0x252525);
    CGFloat eventH=50;
    UIView *viewBtn=[[UIView alloc]init];
    [self.ju_vieBox addSubview:viewBtn];
    CGFloat space=0;
    if ([ju_vieLast isEqual:ju_labTitel]) {
        space = 26;
    }
    viewBtn.juTopSpace.toView(ju_vieLast).equal(space);

    viewBtn.juCenterX.equal(0);
    viewBtn.juSize(CGSizeMake(0, eventH));
    viewBtn.juBottom.equal(0);

    NSInteger count=arrTitel.count;
    CGFloat itemW=self.diaglogWidth/count;

    for (int i=0; i<count; i++) {
        UIButton *btn=[[UIButton alloc]init];
        [btn setTitle:arrTitel[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(juTouchBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=i+10;
        btn.titleLabel.font=[UIFont systemFontOfSize:16];
        [viewBtn addSubview:btn];
        btn.juFrame(CGRectMake(itemW*i+0.01, 0, itemW, eventH));
       
        [btn setClipsToBounds:YES];
        if ([arrTitel[i] isEqual:@"取消"]||(count>1&&i==0)) {
            [btn setTitleColor:MFColor_LightGray forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:PAColor_MainColor forState:UIControlStateNormal];
        }
        if (i>0) {
            UIView *line = self.juLineView;
            [btn addSubview:line];
            line.juFrame(CGRectMake(0.01, 0, 0.5, 0));
        }
    }
    
    UIView *line = self.juLineView;
    [viewBtn addSubview:line];
    line.juFrame(CGRectMake(0, 0.01, 0, 0.5));
}
-(UIView *)juLineView{
    UIView *line=[[UIView alloc]init];
    line.backgroundColor=UINormalColorHex(0xDCDEE3);
    return line;
}
-(CGFloat)space{
    return 28;
}

-(void)juSetContent:(id)content{
    if (!content) {
        return;
    }
    UIScrollView *scroll=[[UIScrollView alloc]init];
    [self.ju_vieBox addSubview:scroll];
    if (ju_vieLast) {
        scroll.juTopSpace.toView(ju_vieLast).equal(16);
    }else{
        scroll.juTop.equal(22);
    }
    scroll.juCenterX.equal(0);
    scroll.juLead.equal(6);

    ju_vieLast=scroll;

    ju_labContent=[[UILabel alloc]init];
    ju_labContent.textAlignment=NSTextAlignmentCenter;
    ju_labContent.textColor=MFColor_MainBlack;
    ju_labContent.font=[UIFont systemFontOfSize:14];
    ju_labContent.numberOfLines=0;
    if ([content isKindOfClass:[NSString class]]) {
        ju_labContent.text=content;
    }else{
        ju_labContent.attributedText=content;
    }
    [scroll addSubview:ju_labContent];
    ju_labContent.juEdge(UIEdgeInsetsMake(0, 8, 16, 8));
    ju_labContent.juWidth.equal(self.diaglogWidth-32);
    CGFloat height = [ju_labContent boundingHeight:self.diaglogWidth-32]+16;
    scroll.juHeight.equal(MIN(height, 305));
    
    if (height>305) {
        UIImageView *img=[[UIImageView alloc]init];
        img.alpha=0.9;
        img.image=[UIImage juDrawGradientImage:CGSizeMake(10, 10) withColor:@[(id)UINormalColorHexA(0xffffff,0.47).CGColor,(id)UINormalColorHex(0xffffff).CGColor] startPoint:CGPointMake(5, 0)];
        [self.ju_vieBox addSubview:img];
        img.juBottom.toView(scroll).equal(0);
        img.juLead.equal(0);
        img.juCenterX.equal(0);
        img.juHeight.equal(20);
    }
}

-(void)juSetImage:(NSString *)imageName{
    ju_imageView=[[UIImageView alloc]init];
    ju_imageView.image=[UIImage imageNamed:imageName];
    [ju_imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.ju_vieBox addSubview:ju_imageView];
    ju_imageView.juTop.equal(16);
    ju_imageView.juCenterX.equal(0);
    ju_imageView.juSize(ju_imageView.image.size);
    ju_vieLast=ju_imageView;
}

-(void)juSetTitle:(NSString *)Title{
    if (!Title) {
        return;
    }
    ju_labTitel=[[UILabel alloc]init];
    ju_labTitel.numberOfLines=2;
    ju_labTitel.textAlignment=NSTextAlignmentCenter;
    ju_labTitel.textColor=MFColor_MainBlack;
    ju_labTitel.font=[UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    ju_labTitel.text=Title;
    [self.ju_vieBox addSubview:ju_labTitel];
    ju_labTitel.juTop.equal(22);
    ju_labTitel.juCenterX.equal(0);
    ju_labTitel.juLead.greaterEqual(15);
    
    ju_vieLast=ju_labTitel;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
