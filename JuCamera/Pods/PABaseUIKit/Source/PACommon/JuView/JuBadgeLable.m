//
//  JuBadgeLable.m
//  MTSkinPublic
//
//  Created by Juvid on 16/10/10.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JuBadgeLable.h"
#import "UIView+Frame.h"
#import "UIView+textBounds.h"
#define RadiusLabFont 10

@interface JuBadgeLable (){
    CGFloat labWidth;
    NSLayoutConstraint *layoutW;
}

@end

@implementation JuBadgeLable
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.layer setCornerRadius:self.frame.size.height/2];
    [self.layer setMasksToBounds:YES];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.textAlignment=NSTextAlignmentCenter;
//    [self.layer setCornerRadius:7];
    [self setClipsToBounds:YES];

    self.textColor=UIColor.whiteColor;
    self.font=[UIFont systemFontOfSize:RadiusLabFont weight:UIFontWeightMedium];
    self.backgroundColor=UIColor.redColor;
    _maxMark=99;
    self.hidden=YES;

//    labWidth=self.sizeW;
    [self juGetLayout];
}

-(void)juSetBackGround:(BOOL)red{
    if (red) {
        self.backgroundColor=UIColor.redColor;
    }
    else{
        self.backgroundColor=UINormalColorHex(0xbfbfbf);
    }
}
-(void)juSetTitle:(NSString *)title{
    [self juGetLayout];
    title=[NSString stringWithFormat:@"%@",title];
    if (title.intValue==0) {
        self.hidden=YES;
        return;
    }
    self.hidden=NO;
    if (_maxMark==0)  return;
    if (title.intValue>_maxMark) {
        title=[NSString stringWithFormat:@"%ld+",(long)_maxMark];
    }
    self.text=title;
    if (title.length) {
        CGFloat titleW=title.length>1?[self boundingWidth:28]-5:0;
        if (layoutW) {
            layoutW.constant=labWidth+titleW;
        }else{
            self.sizeW=labWidth+titleW;
        }
    }

    //    CGFloat titleW=[EasyUse WidthString:title Width:25 Font:RadiusLabFont];

}
-(void)juGetLayout{
    if (labWidth>0)  return;
    
    for (NSLayoutConstraint *layout in self.constraints) {
        if (layout.firstAttribute==NSLayoutAttributeWidth) {
            layoutW=layout;
            labWidth=layout.constant;
            break;
        }
    }
    if (labWidth==0) {
        labWidth=self.sizeW;
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
