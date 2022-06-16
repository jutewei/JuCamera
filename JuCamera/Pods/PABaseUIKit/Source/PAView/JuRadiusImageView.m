//
//  JuRadiusImageView.m
//  JuAllTest
//
//  Created by Juvid on 2018/6/5.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuRadiusImageView.h"

@implementation JuRadiusImageView
-(void)layoutSubviews{
    [super layoutSubviews];
    if (!self.layer.mask) {
        CGRect sBounds=self.bounds;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:sBounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(CGRectGetWidth(sBounds)/2,CGRectGetHeight(sBounds)/2)];
        //创建 layer
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = sBounds;
        //赋值
        maskLayer.path = maskPath.CGPath;
        self.layer.mask=maskLayer;
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

@implementation JuCornerImageView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self.layer setCornerRadius:self.frame.size.height/2];
    [self setClipsToBounds:YES];
}
-(void)didMoveToSuperview{
    [super didMoveToSuperview];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.layer setCornerRadius:self.frame.size.height/2];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation JuIconImageView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.layer setCornerRadius:18];
    [self.layer setMasksToBounds:YES];
    [self.layer setBorderColor:[UIColor colorWithWhite:0.7 alpha:0.25].CGColor];
    [self.layer setBorderWidth:0.5];
}

-(void)juLongInBorderColor:(UIColor *)color{
    [self.layer setBorderColor:color.CGColor];
    [self.layer setBorderWidth:2.5];
    [self.layer setCornerRadius:15];
}

@end

