//
//  JuLableImageView.m
//  JuRefresh
//
//  Created by Juvid on 16/8/11.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JuImageButtonView.h"
#import "JuLayoutFrame.h"
#import "UIView+textBounds.h"
@implementation JuImageButtonView{
    NSLayoutConstraint *ju_spaceCons;
}
@synthesize ju_imageView;

-(instancetype)init{
    self=[super init];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self initView];
}

-(void)initView{
    _centerSpace=2;
    _badgeSpace=0;
    self.userInteractionEnabled=NO;
    if (self.imageView.image) {
        self.image=self.imageView.image;
        [self setImage:nil forState:UIControlStateNormal];
    }
}

-(void)setCenterSpace:(CGFloat)HSpace{
    _centerSpace=HSpace;
    ju_spaceCons.constant=HSpace;
}

-(void)setTitleText:(NSString *)titleText{
    [self setTitle:titleText forState:UIControlStateNormal];
}

-(void)setImageString:(NSString *)imageString{
    UIImage *image=[UIImage imageNamed:imageString];
    if (image) {
        self.image=image;
    }
}

-(void)setImage:(UIImage *)image{
    if (!ju_imageView) {
        ju_imageView=[[UIImageView alloc]init];
        [self addSubview:ju_imageView];
    }
    ju_imageView.image=image;
    self.imageAlignment=JuImageAlignmentLeft;
}

-(void)setBadgeSpace:(CGFloat)badgeSpace{
    _badgeSpace=badgeSpace;
    self.imageAlignment=_imageAlignment;
}

-(void)setImageAlignment:(JuImageAlignment)imageAlignment{
    _imageAlignment=imageAlignment;
    if (!ju_imageView) return;
    
    [ju_imageView juRemoveAllConstraints];

    CGSize size=ju_imageView.image.size;
    UIEdgeInsets insets=self.contentEdgeInsets;
    
    if (imageAlignment==JuImageAlignmentLeft) {
        ju_imageView.juLead.equal(_badgeSpace);
        if (insets.left==0) {
            insets.left+=size.width;
        }
        insets.left+=_centerSpace;
    }else if(imageAlignment==JuImageAlignmentRight){
        ju_imageView.juTrail.equal(_badgeSpace);
        if (insets.right==0) {
            insets.right+=size.width;
        }
        insets.right+=_centerSpace;
    }else if(imageAlignment==JuImageAlignmentTop){
        ju_imageView.juTop.equal(_badgeSpace);
        if (insets.top==0) {
            insets.top+=size.height;
        }
        insets.top+=_centerSpace;
    }else if(imageAlignment==JuImageAlignmentBottom){
        insets.bottom=_centerSpace+size.height;
        ju_imageView.juBottom.equal(_badgeSpace);
        if (insets.bottom==0) {
            insets.bottom+=size.height;
        }
        insets.bottom+=_centerSpace;
    }
    self.contentEdgeInsets=insets;
    if (imageAlignment<2) {
        ju_imageView.juCenterY.equal(0);
    }else{
        ju_imageView.juCenterX.equal(0);
    }
}


@end
