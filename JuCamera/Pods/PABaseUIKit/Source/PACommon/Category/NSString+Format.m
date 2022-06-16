//
//  NSString+Format.m
//  PABase
//
//  Created by Juvid on 2018/4/26.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "NSString+Format.h"

@implementation NSString (Format)

+(NSString *)juGetPrice:(NSInteger)num{
    return [NSString stringWithFormat:@"￥%@",[self juGetDecimal:num]];
}
//两位以上小数可以用循环
+(NSString *)juGetDecimal:(NSInteger)num{
    CGFloat divisor=100.0f;
    if (num/10.0-num/10>0) {///< 最后一位是否有小数
        return [NSString stringWithFormat:@"%.2f",num/divisor];
    }else if (num/100.0-num/100>0) {///< 倒数第二位是否有小数
        return [NSString stringWithFormat:@"%.1f",num/divisor];
    }else{///< 没有小数
        return [NSString stringWithFormat:@"%.0f",num/divisor];
    }
}
+(NSString *)getNum:(NSInteger)num{
    if (num>10000) {
        return [NSString stringWithFormat:@"%.1fw",num/10000.0];
    }else if (num>1000){
        return [NSString stringWithFormat:@"%.1fk",num/1000.0];
    }
    return [NSString stringWithFormat:@"%ld",(long)num];
}
+ (NSString *)juSwitchMoneyNum:(int64_t)number {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.positiveFormat = @"￥,###.##"; // 正数格式
    // 注意传入参数的数据长度，可用double
    NSString *money = [formatter stringFromNumber:@(number/100.0)];
//    money = [NSString stringWithFormat:@"￥%@", money];
    return money;
}

+(NSString *)juGetMaxPoint:(NSInteger)scale{
//    [NSString stringWithFormat:@"%.2f",round(12.1250*100)/100]
    NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:1 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *numResult1 = [NSDecimalNumber decimalNumberWithString:@"1.6350"];
    return [NSString stringWithFormat:@"%@",[numResult1 decimalNumberByRoundingAccordingToBehavior:behavior]];
}
/**
 */
+ (NSString *)juSwitchMoneyNum:(int64_t)number style:(NSNumberFormatterStyle)numberStyle {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle = numberStyle;
    // 注意传入参数的数据长度，可用double
    NSString *money = [formatter stringFromNumber:@(number/100.0)];
    return money;
}
//ios9前编码
-(NSString *)juUrlEncoding{
//    !$&'()*+,-./:;=?@_~%#[] 不编码
//    [self.sh_Url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL,kCFStringEncodingUTF8));
}
//ios9后编码
-(NSString *)juSetCharacterEncoding{
//    不过滤任何特殊字符 文本自动编码
//    [NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "] ///<只有#%^{}\"[]|\\<> 不被转码，其他都都转码
//    [NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet 反转 表示 #%^{}\"[]|\\<> 和非7-bit ASCII（英文和数字）会被转码
   return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"$"].invertedSet];
//    此方法表示只对中文和$进行编码
}

//解码
-(NSString *)juRemoveEncod{
    return [self stringByRemovingPercentEncoding];
}

//stringByRemovingPercentEncoding

- (CGFloat)getStringHeightWithTextWithfontSize:(float)fontSize lineSpace:(CGFloat)lineSpace viewWidth:(CGFloat)width {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = lineSpace;
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle};
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGSize size = [self boundingRectWithSize:maxSize options:options attributes:attrs context:nil].size;
    return  size.height;
}
@end
