//
//  PFBButtonCode.h
//  JuCycleScroll
//
//  Created by Juvid on 16/7/6.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JuButton.h"
@interface JuButtonCode : JuButton{
    NSTimer *ju_timerCD;
    NSInteger ju_timeTotal;
}
/**
 *倒计时开始
 */
-(void)juStartCountDownWithTimeCount:(NSInteger)timeCount;

-(void)juStartCountDown;

-(void)juStopCountdown;

@end
