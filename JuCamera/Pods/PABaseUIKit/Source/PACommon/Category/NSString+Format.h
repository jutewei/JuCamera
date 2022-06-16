//
//  NSString+Format.h
//  PABase
//
//  Created by Juvid on 2018/4/26.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Format)

/**
 价格格式化

 @param num 原始价格
 @return 格式化价格
 */
+(NSString *)juGetPrice:(NSInteger)num;

/**
 浮点数格式化

 @param num 原始数据
 @return 格式化字符
 */
+(NSString *)juGetDecimal:(NSInteger)num;

/**￥,###.##**94,862.57**/
+ (NSString *)juSwitchMoneyNum:(int64_t)number;

+(NSString *)getNum:(NSInteger)num;
/**
 * 94863
 * NSNumberFormatterNoStyle = kCFNumberFormatterNoStyle,

 * 94,862.57
 * NSNumberFormatterDecimalStyle = kCFNumberFormatterDecimalStyle,

 * ￥94,862.57
 * NSNumberFormatterCurrencyStyle = kCFNumberFormatterCurrencyStyle,

 * 9,486,257%
 * NSNumberFormatterPercentStyle = kCFNumberFormatterPercentStyle,

 * 9.486257E4
 * NSNumberFormatterScientificStyle = kCFNumberFormatterScientificStyle,

 * 九万四千八百六十二点五七
 * NSNumberFormatterSpellOutStyle = kCFNumberFormatterSpellOutStyle
 */
+ (NSString *)juSwitchMoneyNum:(int64_t )num style:(NSNumberFormatterStyle)numberStyle;
/**
 编码

 @return 编码后字符串
 */
-(NSString *)juUrlEncoding;

-(NSString *)juSetCharacterEncoding;

-(NSString *)juRemoveEncod;
/**
 根据字符串求高度

 @param lineSpace 字符串
 @param fontSize 字号大小
 @param width 宽度
 @return 高度
 */
- (CGFloat)getStringHeightWithTextWithfontSize:(float)fontSize lineSpace:(CGFloat)lineSpace viewWidth:(CGFloat)width;
@end
