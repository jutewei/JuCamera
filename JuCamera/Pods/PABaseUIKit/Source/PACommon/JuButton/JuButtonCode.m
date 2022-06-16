//
//  PFBButtonCode.m
//  JuCycleScroll
//
//  Created by Juvid on 16/7/6.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JuButtonCode.h"

@implementation JuButtonCode
-(void)awakeFromNib{
    [super awakeFromNib];
    self.titleLabel.font=[UIFont systemFontOfSize:14];
    [self setTitleColor:PAColor_MainColor forState:UIControlStateNormal];
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
//    [self setTitle:@"重新发送" forState:UIControlStateNormal];
//    self.backgroundColor=MFColor_White;
//    [self fbSelect];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }

    return self;
}
-(void)juStartCountDownWithTimeCount:(NSInteger)timeCount{
//    [self fbUnSelect];
    self.isEnable=NO;
    ju_timeTotal=timeCount;
    ju_timerCD =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fbPopCountDown) userInfo:nil repeats:YES];
}
-(void)juStartCountDown{
    [self juStartCountDownWithTimeCount:120];
}
//倒计时
-(void)fbPopCountDown{
    if (ju_timeTotal==0) {
        [ju_timerCD invalidate];
        ju_timerCD=nil;
//        [self fbSelect];
        self.isEnable=YES;
        [self  setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self setTitleColor:PAColor_MainColor forState:UIControlStateNormal];
    }
    else {
        [self  setTitle:[NSString stringWithFormat:@"%@s重新获取",@(ju_timeTotal)] forState:UIControlStateNormal];
         [self setTitleColor:MFColor_LightGray forState:UIControlStateNormal];
        ju_timeTotal--;
    }

}
-(void)juStopCountdown{
    ju_timeTotal=0;
}
-(void)dealloc{
    [ju_timerCD invalidate];
    ju_timerCD=nil;
}
@end
