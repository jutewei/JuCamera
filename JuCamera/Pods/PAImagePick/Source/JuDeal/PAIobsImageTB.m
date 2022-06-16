//
//  PAIobsImageTB.m
//  FMDB
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/9/8.
//

#import "PAIobsImageTB.h"
#import "JUFMDB.h"
@implementation PAIobsImageTB

+(id)zlSelectWithID:(NSString *)requestId{
    if (!requestId) {
        return nil;
    }
    NSArray *arr=[JUBaseDatadb juSelectTable:@"PAIobsImageTB" whereKey:@{@"requestId":requestId}];
    PAIobsImageTB *tb=nil;
    if (arr.count) {
        PAIobsImageTB *tb=[PAIobsImageTB juToModel:arr.firstObject];
        if (![SDImageCache.sharedImageCache diskImageDataExistsWithKey:tb.zl_url]){
            [JUBaseDatadb juDeteleTabData:tb];
            tb=nil;
        }
    }
    return tb;
}

+(BOOL)zlInsertWithID:(NSString *)requestId withUrl:(NSString *)url{
    if (requestId) {
        PAIobsImageTB *tb=[PAIobsImageTB juInitM];
        tb.zl_requestId=requestId;
        tb.zl_url=url;
        return [JUBaseDatadb juInsertData:tb primary:@"requestId"];
    }
    return NO;
}

+(NSArray *)juProPrefixs{
    return @[@"zl_"];
}

@end

