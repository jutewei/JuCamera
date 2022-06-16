//
//  JuInputDataAdapter.m
//  PABase
//
//  Created by Juvid on 2018/12/5.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuInputDataAdapter.h"

@implementation JuInputDataAdapter
- (instancetype)initWithData:(id)data {
    self = [super init];
    if (self) {
        self.juData = data;
    }
    return self;
}
- (NSString *)juTitle{
    return [NSString stringWithFormat:@"%@",self.juData[@"title"]];
}
- (NSString *)juId{
    return [NSString stringWithFormat:@"%@",self.juData[@"id"]];
}
- (NSArray <JuInputDataAdapter *>*)juArrList{
    return self.juData[@"list"];
}
@end
