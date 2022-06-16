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

@interface JuBasePopView : UIView

@property (nonatomic,strong)UIView *vieBox;
@property (nonatomic,copy ) JuCallHandle ju_callHandle;
@property (nonatomic) CGFloat ju_Radius;
@property (nonatomic) CGFloat ju_boxHeight;

-(void)juSetContentView;

-(void)juShowView;

-(void)juHideView;

+(instancetype)initView:(UIView *)view;

+(instancetype)initView;

- (void)juTouchBtnHandler:(UIButton *)sender;


@end


@interface JuBaseAlertView : JuBasePopView

-(CGFloat)diaglogWidth;

@end

@interface JuBaseSheetView : JuBasePopView


@end
