//
//  PABaseUserModel.m
//  PANetService
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2022/3/25.
//

#import "PABaseUserModel.h"

@implementation PABaseUserModel{
    NSDictionary *_zl_userInfo;
}

-(NSString *)zl_zuulToken{
    return _zl_token;
}

+(PABaseUserModel *)zlSetUserInfo:(NSDictionary *)userInfo{
    PABaseUserModel *userM=[PABaseUserModel juInitM];
    [userM zlSetUserInfo:userInfo];
    return userM;
}

-(void)zlSetUserInfo:(NSDictionary *)userInfo{
    if (!userInfo||userInfo.count==0) {
//        [self mtDestroyDealloc];
        _zl_userInfo=[PABaseUserModel juToDictionary:self];
    }else{
        _zl_userInfo=userInfo;
//        [self juToModel:_zl_userInfo];
    }
}

-(NSDictionary *)zl_userInfo{
    return _zl_userInfo;
}
@end
