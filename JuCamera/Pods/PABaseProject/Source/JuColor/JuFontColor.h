//
//  JuPublicFontColor.h
//  PABase
//
//  Created by Juvid on 2019/7/24.
//  Copyright © 2019 Juvid. All rights reserved.
//

#ifndef JuFontColor_h
#define JuFontColor_h
#import "UIColor+Dark.h"
#define SET_CELLHIGH_VALUE(value)       IPHONE5S?value:(IPHONE6?value+5:value+10)
#define SET_IMAGEHIGH_VALUE(value)      IPHONE5S?value:(IPHONE6?value+15:value+30)

#define SET_SCALEHIGH_VALUE(value)      (value*Screen_Width/320)
#define SH_SET_Hight(multiple,value)    IPHONE345?value*multiple:(IPHONE6?value*2*multiple:value*3*multiple)

#define JUFONT_VALUE(value)             IPHONE5S?[UIFont systemFontOfSize:value]:(IPHONE6?[UIFont systemFontOfSize:(value+1)]:[UIFont systemFontOfSize:(value+2)])
#define JUFONT_SIZE(value)              IPHONE345?value:(IPHONE6?value+1:value+2)

#define IPhone6PFONT_SIZE(value) IPHONE6PLUS?value+1:value

#define JUColor_DarkBlack           UINormalColorHex(0x1C1C1E)  ///< 黑色背景

#define JUColor_DarkWhite           JUDarkColorHex(0xffffff)    ///<白色 - 黑色
#define JUColor_ContentWhite        JUDarkBothColor(UINormalColorHex(0xffffff),JUColor_DarkBlack)///< 白色-深黑 背景
#define JUColor_CollectBack         JUDarkBothColor(UINormalColorHex(0xffffff),UINormalColorHex(0x090909))///< 白色-深黑 背景
#define JUColor_Background          JUDarkBothColor(UINormalColorHex(0xF5F5F5),UINormalColorHex(0x000000))///< 浅白-黑色 背景颜色
#define JUColor_Separator           JUDarkBothColor(UINormalColorHex(0xe8e8e8),UINormalColorHex(0x333333))//cell  分割线颜色

#define JUColor_NavTitleMain        JUDarkColorHex(0x333333)//JUDarkBothColor(UINormalColorHex(0x333333),UINormalColorHex(0xeeeeee))///<重要标题

#define JUColor_LightSep            JUDarkColorHex(0xF8F8F8)//普通分割线颜色
#define JUColor_SelectSecond        JUDarkColorHex(0xE5E5E5)//cell选中颜色
#define JUColor_ButtonEnable        JUDarkColorHex(0xCCCCCC)//不可点按钮
#define JuColor_WhiteGray           JUDarkColorHex(0xb5b5b5)///<(灰白)
#define JUColor_BlackBlack         JUDarkColorHex(0x2C2E2F)
//#define JUColor_RedBack             UINormalColorHex(0xff0000)///< 背景浅红

#define JUFont_NaviTitle            [UIFont systemFontOfSize:IPhone6PFONT_SIZE(17)]///<  导航栏标题
#define JUFont_NaviTitleM           [UIFont systemFontOfSize:IPhone6PFONT_SIZE(17) weight:UIFontWeightMedium]///<  导航栏标题

#endif /* JuPublicFontColor_h */
