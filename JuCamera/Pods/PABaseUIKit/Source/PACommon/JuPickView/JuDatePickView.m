//
//  JuDataPickView.m
//  PABase
//
//  Created by Juvid on 2018/12/5.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuDatePickView.h"
#import "UIView+Frame.h"

@implementation JuDatePickView

-(void)juSetPickView{
    [self setJu_navTitle:@"请选择时间"];
//    self.ju_timeFormat=@"HH:mm";
    UIDatePicker *datePick=[[UIDatePicker alloc]init];
    datePick.locale=[NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    datePick.datePickerMode=UIDatePickerModeDate;
    if (@available(iOS 13.4, *)) {
        datePick.preferredDatePickerStyle=UIDatePickerStyleWheels;
    }

//    datePick.date=[NSDate date];
    [self addSubview:datePick];
    datePick.juFrame(CGRectMake(0.01, -0.01, 0, self.juPickHeight-51));
    _juPickDate=datePick;
}
-(CGFloat)juPickHeight{
    return 220;
}
-(void)setJuDatePickerMode:(UIDatePickerMode)juDatePickerMode{
    self.juPickDate.datePickerMode=juDatePickerMode;
    if (juDatePickerMode==UIDatePickerModeTime) {
        //设置为24小时制
    //    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
        _juPickDate.locale =  [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
        _juPickDate.backgroundColor=[UIColor whiteColor];
    }
}
-(void)juShowPick{
    [super juShowPick];
    if (self.juDataSelectType == JuDataSelectLater) {
        self.juPickDate.minimumDate = [NSDate date];
    }else if(self.juDataSelectType==JuDataSelectBefore){
        self.juPickDate.maximumDate=[NSDate date];
    }
}

-(void)juWillFinishData{
    NSDate *date=self.juPickDate.date;
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    dateformatter.locale=[NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    if (_ju_timeFormat) {
        [dateformatter setDateFormat:_ju_timeFormat];
    }
    else if (self.juPickDate.datePickerMode == UIDatePickerModeDate) {
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
    }
    else if (self.juPickDate.datePickerMode == UIDatePickerModeDateAndTime) {
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }else {
        [dateformatter setDateFormat:@"HH:mm"];
    }
    ju_outputModel.juDetail=date;
    ju_outputModel.juPostId=[NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    ju_outputModel.juShowValue=[dateformatter stringFromDate:date];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
