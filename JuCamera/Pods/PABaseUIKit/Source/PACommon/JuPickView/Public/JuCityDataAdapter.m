//
//  JuCityDataAdapter.m
//  PABase
//
//  Created by Juvid on 2018/12/5.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuCityDataAdapter.h"

@implementation JuCityDataAdapter

- (NSString *)juTitle{
    return self.juData[@"name"];
}
- (NSString *)juId{
    NSString *code=self.juData[@"id"];
    if (code) {
        return  code;
    }
    return @"";
}
- (NSArray <JuInputDataAdapter *>*)juArrList{
    return self.juData[@"city"];
}

@end
