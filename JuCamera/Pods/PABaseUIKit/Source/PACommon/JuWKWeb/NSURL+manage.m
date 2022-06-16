//
//  NSURL+manage.m
//  JuTestTest
//
//  Created by Juvid on 2018/10/15.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "NSURL+manage.h"

@implementation NSURL (manage)
-(NSDictionary *)componentsSeparatedByString{
    NSMutableDictionary *dicPara=[NSMutableDictionary dictionary];

    NSString *parameterString=[self.query stringByRemovingPercentEncoding];
    // 多个参数，分割参数
    NSArray *urlComponents = [parameterString componentsSeparatedByString:@"&"];
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

@end
