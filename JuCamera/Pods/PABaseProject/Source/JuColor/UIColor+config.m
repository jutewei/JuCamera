//
//  UIColor+config.m
//  PABase
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/5/31.
//

#import "UIColor+config.h"
#import "JuFontColor.h"
#import "JuSystemDefine.h"
#import "PAFontColor.h"

@implementation UIColor (config)

+(UIColor *)zlWhite{
    return [UIColor whiteColor];///<
}
+(UIColor *)zlBackground{
    return JUColor_Background;///<
}
+(UIColor *)zlBlackText{
    return JUDarkColorHex(0x000000);///<
}
+(UIColor *)zlBlack{
    return JUDarkColorHex(0x2C2E2F);// JUDarkBothColor(UINormalColorHex(0x2C2E2F),UINormalColorHex(0xffffff))///<
}
+(UIColor *)zlBlackGray{
    return JUDarkColorHex(0x333333);///< JUDarkBothColor(UINormalColorHex(0x333333),UINormalColorHex(0xffffff))///<
}
+(UIColor *)zlDark{
    return JUDarkColorHex(0x666666);///< JUDarkBothColor(UINormalColorHex(0x666666),UINormalColorHex(0xcccccc
}
+(UIColor *)zlLightGray{
    return JUDarkColorHex(0x999999);///< JUDarkBothColor(UINormalColorHex(0x999999),UINormalColorHex(0xaaaaaa))///<;
}
+(UIColor *)zlWhiteGray{
    return JUDarkColorHex(0xb5b5b5);///< ;
}
+(UIColor *)zlLoginBlue{
    return JUDarkColorHex(0x757CD6);///< ;
}
+(UIColor *)zlMain{
    return JUDarkColorHex(0xFD792A);///< ;
}
+(UIColor *)zlMessageRed{
    return JUDarkColorHex(0xff0000);///< ;
}

+(UIColor *)zlStarYellow{
    return JUDarkColorHex(0xFF870E);///< ;
}

+(UIColor *)zlStatusBack{
    return JUDarkColorHex(0xFFF8E7);///< ;
}
+(UIColor *)zlStarContent{
    return JUDarkColorHex(0x5E470E);///< ;
}
+(UIColor *)zlChatBack{
    return JUDarkColorHex(0xf0f0f0);///< ;
}
+(UIColor *)zlImageBack{
    return JUDarkColorHex(0xf0f4f7);///< ;
}

@end


@implementation UIFont (config)

+(UIFont *)zlTopBarTitle:(BOOL)isMedium{
    return [UIFont systemFontOfSize:Adjust_SIZE(17) weight:isMedium?UIFontWeightMedium:UIFontWeightRegular];
}
+(UIFont *)zlTitleText:(BOOL)isMedium{
    return [UIFont systemFontOfSize:Adjust_SIZE(16) weight:isMedium?UIFontWeightMedium:UIFontWeightRegular];
}
+(UIFont *)zlSecondText:(BOOL)isMedium{
    return [UIFont systemFontOfSize:Adjust_SIZE(15) weight:isMedium?UIFontWeightMedium:UIFontWeightRegular];
}
+(UIFont *)zlNormalText:(BOOL)isMedium{
    return [UIFont systemFontOfSize:Adjust_SIZE(14) weight:isMedium?UIFontWeightMedium:UIFontWeightRegular];
}
+(UIFont *)zlNormal2Text:(BOOL)isMedium{
    return [UIFont systemFontOfSize:Adjust_SIZE(13) weight:isMedium?UIFontWeightMedium:UIFontWeightRegular];
}
+(UIFont *)zlLittleText:(BOOL)isMedium{
    return [UIFont systemFontOfSize:Adjust_SIZE(12) weight:isMedium?UIFontWeightMedium:UIFontWeightRegular];
}
+(UIFont *)zlLittleText0:(BOOL)isMedium{
    return [UIFont systemFontOfSize:Adjust_SIZE(11) weight:isMedium?UIFontWeightMedium:UIFontWeightRegular];
}
+(UIFont *)zlSmallText:(BOOL)isMedium{
    return [UIFont systemFontOfSize:Adjust_SIZE(10) weight:isMedium?UIFontWeightMedium:UIFontWeightRegular];
}

@end
