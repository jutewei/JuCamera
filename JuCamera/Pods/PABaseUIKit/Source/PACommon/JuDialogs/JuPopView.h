//
//  SHPopView.h
//  SHBaseProject
//
//  Created by Juvid on 16/5/17.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import <UIKit/UIKit.h>

#define juDiaglog_Width 270
typedef void(^JuCallHandle)(id result);//操作
@interface JuPopView : UIView

@property (nonatomic,strong)UIView *ju_vieBox;
@property (nonatomic,copy ) JuCallHandle ju_callHandle;
@property (nonatomic) CGFloat sh_Radius;

-(void)juShowView;

+(instancetype)initView:(UIView *)view;

+(instancetype)initView;

- (void)juTouchBtnHandler:(UIButton *)sender;

-(CGFloat)diaglogWidth;

@end
