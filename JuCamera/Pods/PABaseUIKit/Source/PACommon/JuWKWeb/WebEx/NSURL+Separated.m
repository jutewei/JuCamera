//
//  URL+Separated.m
//  JuCycleScroll
//
//  Created by Juvid on 2018/12/14.
//  Copyright © 2018年 Juvid(zhutianwei). All rights reserved.
//

#import "NSURL+Separated.h"
#import "NSObject+Safety.h"

@implementation NSURL (Separated)
-(NSDictionary *)shSeparatedByString{
    return [self shSeparatedByString:@"&"];
}
//pifubaopatient://api.pifubao.com/drugdetail?url=https://wxhospital.pifubao.com.cn/info/drugdetail?id=3939&url=123456&name=juvid
-(NSDictionary *)shSeparatedByString:(NSString *)string{
    NSMutableDictionary *dicPara=[NSMutableDictionary dictionary];
    NSString *parameterString=[self.query stringByRemovingPercentEncoding];
    // 多个参数，分割参数
    NSArray *urlComponents = [parameterString componentsSeparatedByString:string];
    for (NSString *keyValue in urlComponents) {
        NSArray *pairComponents = [keyValue componentsSeparatedByString:@"="];
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSMutableArray  *value = [NSMutableArray array];
        for (int i=1; i<pairComponents.count; i++) {
            [value addObject:pairComponents[i]];
        }
        NSString *allValue=[value componentsJoinedByString:@"="];
        [dicPara setValue:allValue forKey:key];
    }
    return dicPara;
}

-(NSDictionary *)mtUrlJumpParam{
    NSString *strURL=[self.absoluteString stringByRemovingPercentEncoding];
    NSMutableArray *arrUrl=[[strURL componentsSeparatedByString:@"?"] mutableCopy];
    if (arrUrl.count>1) {
        [arrUrl removeObjectAtIndex:0];
    }

//    NSURL *obsoluteUrl=[[NSURL alloc]initWithString:strURL];
//    NSString *parameterString=[obsoluteUrl.query stringByRemovingPercentEncoding];
    NSDictionary *dicParam=[[arrUrl componentsJoinedByString:@"?"] juJSONObjectWithDataOrStr];

    NSMutableDictionary *dicAction=[NSMutableDictionary dictionary];
    [dicAction setValue:dicParam forKey:@"param"];
    if (self.path.length>0) {
        [dicAction setValue:[self.path substringFromIndex:1] forKey:@"cmd"];
    }
    return dicAction;
}


@end
