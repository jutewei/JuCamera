//
//  JuDataPickView.h
//  PABase
//
//  Created by Juvid on 2018/12/5.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuBasePickView.h"
//时间显示规则定义
typedef NS_ENUM(NSInteger, JuDataSelectType) {
    JuDataSelectNone,
    JuDataSelectBefore,//只显示过去的时间
    JuDataSelectLater,//只显示将来的时间
};
NS_ASSUME_NONNULL_BEGIN

@interface JuDatePickView : JuBasePickView
@property (strong,nonatomic) NSString *ju_timeFormat;
@property (readonly, nonatomic)  UIDatePicker *juPickDate;
@property (nonatomic) UIDatePickerMode juDatePickerMode; 
@property (nonatomic) JuDataSelectType juDataSelectType;

@end

NS_ASSUME_NONNULL_END
