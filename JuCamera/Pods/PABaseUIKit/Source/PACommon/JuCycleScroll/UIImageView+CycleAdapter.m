//
//  UIImageView+CycleAdapter.m
//  JuCycleScroll
//
//  Created by Juvid on 2018/10/25.
//  Copyright © 2018年 Juvid(zhutianwei). All rights reserved.
//

#import "UIImageView+CycleAdapter.h"
#import "UIImageView+WebCache.h"
@implementation UIImageView (CycleAdapter)
-(void)juLoadImage:(id<JuCycleScrollProtocol>)data{
    [self.superview layoutIfNeeded];
    [self sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:[data juDefuleImage]]];
//    [self setImageWithStr:[data shImageUrl:self.frame.size] placeholderImage:[data shDefuleImage]];
}
@end
