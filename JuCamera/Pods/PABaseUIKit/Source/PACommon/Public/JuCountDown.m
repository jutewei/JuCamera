//
//  JuCountDown.m
//  JuCountDown
//
//  Created by Juvid on 2018/3/23.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuCountDown.h"

@implementation JuCountDown

-(void)juSetEndDate:(NSDate *)endData handle:(juHandleWithData)timeStr{

    NSDate *startDate = [NSDate date];
    ju_timeInterval =[endData timeIntervalSinceDate:startDate];
    if (_timer==nil) {
        if (ju_timeInterval>=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(ju_timeInterval<=0){ //倒计时结束，关闭
                    [self juDealloc];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        timeStr(self.juEndStr);
                    });
                }else{
                    NSTimeInterval dayTime=3600*24;
                    int days = (int)(ju_timeInterval/(dayTime));
                    int hours = (int)((ju_timeInterval-days*dayTime)/3600);
                    int minute = (int)(ju_timeInterval-days*dayTime-hours*3600)/60;
                    int second = ju_timeInterval-days*dayTime-hours*3600-minute*60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (days==0) {
                            // self.dayLabel.text = @"0天";
                        }else{
                            //self.dayLabel.text = [NSString stringWithFormat:@"%d天",days];
                        }
                        NSString *strDays,*strHours,*strMinute,*strSecond;
//                        int allHours=hours+days*24;
                        if (days<10) {
                            strDays = [NSString stringWithFormat:@"0%d",days];
                        }else{
                            strDays = [NSString stringWithFormat:@"%d",days];
                        }
                        if (hours<10) {
                            strHours = [NSString stringWithFormat:@"0%d",hours];
                        }else{
                            strHours = [NSString stringWithFormat:@"%d",hours];
                        }
                        if (minute<10) {
                            strMinute = [NSString stringWithFormat:@"0%d",minute];
                        }else{
                            strMinute = [NSString stringWithFormat:@"%d",minute];
                        }
                        if (second<10) {
                            strSecond = [NSString stringWithFormat:@"0%d",second];
                        }else{
                            strSecond = [NSString stringWithFormat:@"%d",second];
                        }
                        timeStr([NSString stringWithFormat:@"%@:%@:%@:%@",strDays,strHours,strMinute,strSecond]);

                    });
                    ju_timeInterval--;
                }
            });
            dispatch_resume(_timer);
        }else{
            [self juDealloc];
            timeStr(self.juEndStr);
        }
    }

}
-(NSString *)juEndStr{
    return @"00:00:00:00";
}
/**
 *  获取当天的年月日的字符串
 *  这里测试用
 *  @return 格式为年-月-日
 */
-(NSString *)getyyyymmdd{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyy-MM-dd";
    NSString *dayStr = [formatDay stringFromDate:now];
    return dayStr;
}
-(void)juDealloc{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}
-(void)dealloc{
    NSLog(@"释放了");
}
@end
