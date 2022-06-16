//
//  PAFontColor.h
//  PABase
//
//  Created by Juvid on 2021/4/19.
//

#ifndef PAFontColor_h
#define PAFontColor_h
#import "UIColor+config.h"
//字体
#define Larger_SIZE(value)       (IPHONE6PLUS?value+1:value)
#define Little_Size(value)       (IPHONE345?value-2:value)
#define SmallerSize(value)       (IPHONE6?value:(IPHONE345?value-2:value+1))
#define Adjust_SIZE(value)       (IPHONE6?value:(IPHONE345?value-1:value+1))

#define UIFontAdjustOfSize(value)               [UIFont systemFontOfSize:Adjust_SIZE(value)]
#define UIFontAdjustOfSizeWeight(value,Vw)      [UIFont systemFontOfSize:Adjust_SIZE(value) weight:Vw]

//颜色
#define PAColorWhite(wValue,aValue)   [UIColor colorWithWhite:wValue alpha:aValue]
//暗黑
#define PAColor_Background         [UIColor zlBackground]///< 背景颜色
#define PAColor_BlackText          [UIColor zlBlackText]///< 重要标题
#define PAColor_BlackBlack         [UIColor zlBlack]
#define PAColor_BlackGray          [UIColor zlBlackGray]//
#define PAColor_DarkGray           [UIColor zlDark]//
#define PAColor_LightGray          [UIColor zlLightGray]// 次要文字（浅灰）
#define PAColor_WhiteGray          [UIColor zlWhiteGray]///<(灰白)

//正常颜色
#define PAColor_White              [UIColor zlWhite]///< 重要标题
#define PAColor_LoginBlue          [UIColor zlLoginBlue]///< 登录按钮颜色
#define PAColor_Main               [UIColor zlMain]///< 主题色
#define PAColor_MessageRed         [UIColor zlMessageRed]///< 消息红
#define PAColor_StarYellow         [UIColor zlStarYellow]///< 星星黄
#define PAColor_StatusBack         [UIColor zlStatusBack]///< 星星状态背景黄
#define PAColor_StarContent        [UIColor zlStarContent]///< 状态字体颜色

#define MTColor_ChatBack           [UIColor zlChatBack]
#define MTColor_ImageBack          [UIColor zlImageBack]
/***************字体*******************/

#define PAFFont_TopbarTitle         [UIFont zlTopBarTitle:NO]///<  大M标题
#define PAFFont_TitleText           [UIFont zlTitleText:NO]///< 次要文字
#define PAFFont_SecondText          [UIFont zlSecondText:NO]///< 次要文字
#define PAFFont_NormalText          [UIFont zlNormalText:NO]///< 重要文字
#define PAFFont_Normal2Text         [UIFont zlNormal2Text:NO]///< 辅助文字
#define PAFFont_LittleText          [UIFont zlLittleText:NO]///< 辅助文字
#define PAFFont_LittleText0         [UIFont zlLittleText0:NO]///< 辅助文字
#define PAFFont_SmallText           [UIFont zlSmallText:NO]///< 辅助文字

#define PAFFont_TopbarTitleM         [UIFont zlTopBarTitle:YES]///<  大标题
#define PAFFont_TitleTextM           [UIFont zlTitleText:YES]///< 次要文字
#define PAFFont_SecondTextM          [UIFont zlSecondText:YES]///< 次要文字
#define PAFFont_NormalTextM          [UIFont zlNormalText:YES]///< 重要文字
#define PAFFont_Normal2TextM         [UIFont zlNormal2Text:YES]///< 辅助文字
#define PAFFont_LittleTextM          [UIFont zlLittleText:YES]///< 辅助文字
#define PAFFont_SmallTextM           [UIFont zlSmallText:YES]///< 辅助文字 辅助文字

#endif /* PAFontColor_h */
