//
//  NSString+emoji.h
//  PABase
//
//  Created by Juvid on 16/3/3.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (emoji)
///< 判断表情符号
- (BOOL)isContainsEmoji;
///< 过滤所有表情
- (NSString *)juDisableEmoji;
@end
