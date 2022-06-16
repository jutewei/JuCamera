//
//  NSString+easy.m
//  PABaseProject
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2022/6/13.
//

#import "NSString+easy.h"

@implementation NSString (easy)

-(NSString *)juPathForUrl{
    if ([self hasPrefix:@"file://"]) {
        return   [[self stringByReplacingOccurrencesOfString:@"file://" withString:@""] stringByRemovingPercentEncoding];
    }
    return self;
}

@end
