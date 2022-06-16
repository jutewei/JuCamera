//
//  JuBaseConfig.m
//  PABase
//
//  Created by Juvid on 2020/7/28.
//  Copyright © 2020 Juvid. All rights reserved.
//

#import "JuDebugConfig.h"

@implementation JuDebugConfig

+(NSInteger)datAPI{
    static NSInteger apiDat=NSNotFound;
    if (apiDat==NSNotFound) {
        apiDat=[[[[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"api" ofType:@"dat"] encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByString:@":"] objectAtIndex:0] integerValue];
    }
    return  apiDat;
}

+(NSInteger)apiModelNum:(NSString *)strUrl{
    NSURL *url=[NSURL URLWithString:strUrl];
    if ([url.host isEqual:@"fls-afch-stg.pingan.com.cn"]) {
        return 0;
    }else if([url.host isEqual:@"fls-afch-test.pingan.com.cn"]){
        return 1;
    }else if([url.host isEqual:@"fls-afch.pingan.com.cn"]){
        return 2;
    }else{
        return 3;
    }
}

+(NSInteger)apiMainNum{
    if (self.isTest) {
        return [self apiModelNum:self.baseURLStr];
    }
    return self.datAPI;
}

+(NSString *)baseURLStr{
    if (self.isTest) {///可以通过界面切换环境
        return [NSUSER_DEFAULTS objectForKey:@"baseUrl"]?:[self basePres:0];
    }
    return [NSString stringWithFormat:@"%@",[self basePres:self.datAPI]];
}

+(BOOL)isTest{
    return self.datAPI < 0;
}
+(NSString *)basePres:(NSInteger)num{
    NSArray *arr=@[@"https://fls-afch-stg.pingan.com.cn/",@"https://fls-afch-test.pingan.com.cn/",@"https://fls-afch.pingan.com.cn/"];
    if (arr.count>num) {
        return arr[num];
    }
    return @"";
}

@end
