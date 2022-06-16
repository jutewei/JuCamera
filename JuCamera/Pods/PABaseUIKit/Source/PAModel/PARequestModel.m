//
//  MTCreatRequestModel.m
//  PABase
//
//  Created by Juvid on 2017/7/27.
//  Copyright © 2017年 Juvid(zhutianwei). All rights reserved.
//

#import "PARequestModel.h"
#import <NSObject+Safety.h>


@implementation PARequestModel

+(NSMutableArray *)zlRowPlistResource:(NSString *)fileName{
    return (id)[self zlPlistResource:fileName];
}

+(NSMutableArray *)zlSectionPlistResource:(NSString *)fileName{
    return [self zlPlistResource:fileName];
}

+(NSMutableArray *)zlPlistResource:(NSString *)fileName{
    NSArray *arrFile=[JuFileManage juPlistResource:fileName];
    NSString *json=[arrFile juStringWithJsonObject];
    NSMutableArray *arrM=[NSMutableArray array];
    for (id object in arrFile) {
        if ([object isKindOfClass:[NSArray class]] ) {
            [arrM addObject:[self juToModelArr:object]];
        }else{
          [arrM addObject:[self juToModel:object]];
        }
    }
    return arrM;
}

-(void)setPostValue:(id)value{
    [self setPostValue:value showValue:value];
}
-(void)setPostValue:(id)postValue showValue:(id)showValue{
    self.zl_postVaule=postValue;
    self.zl_showVaule=showValue;
}
+(PARequestModel *)zlInitTitle:(NSString *)title{
    PARequestModel *model=[PARequestModel juInitM];
    model.zl_title=title;
    [model setPostValue:@""];
    return model;
}
+(BOOL)zlCheckEmpty:(NSArray *)list{
    for (id object in list) {
        if ([object isKindOfClass:[NSArray class]]) {
            if([self zlCheckEmpty:object]) return YES;
        }else{
            PARequestModel *model=object;
            if (!model.zl_canEmpty&&![model.zl_postVaule notEmpty]) {
                [MBProgressHUD juShowHUDCenter:[NSString stringWithFormat:@"%@不能为空",model.zl_title]];
                return YES;
            }
        }
    }
    return NO;
}

+(NSMutableDictionary *)zlGetRequestPara:(NSArray *)arrlist{
    NSMutableDictionary *parameter=[NSMutableDictionary dictionary];
    for (id object in arrlist) {
        if ([object isKindOfClass:[NSArray class]]) {
             [parameter addEntriesFromDictionary:[self zlGetRequestPara:object]];
        }else if([object isKindOfClass:[PARequestModel class]]){
            PARequestModel *model = object;
            if ([model.zl_postVaule notEmpty]) {
                [parameter setValue:model.zl_postVaule forKey:model.zl_key];
            }
        }
    }
    return parameter;
}
@end
