//
//  PFBBaseCycleScrollDdapter.m
//  JuCycleScroll
//
//  Created by Juvid on 2018/10/25.
//  Copyright © 2018年 Juvid(zhutianwei). All rights reserved.
//

#import "JuCycleScrollAdapter.h"

@implementation JuCycleScrollAdapter
+(id)initWithData:(id)data{
    JuCycleScrollAdapter * dapter=[[self alloc]init];
    dapter.juData=data;
    return dapter;
}

-(NSString *)juImageUrl:(CGSize)size{
    return self.juData[@"imagUrl"];
}

-(NSString *)juDefuleImage{
    return @"test_banner";
}

@end
