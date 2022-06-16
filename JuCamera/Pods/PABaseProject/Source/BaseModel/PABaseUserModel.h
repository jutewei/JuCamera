//
//  PABaseUserModel.h
//  PANetService
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2022/3/25.
//

#import "PABaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PABaseUserModel : PABaseModel

@property (nonatomic,copy) NSString *zl_token;       ///<
@property (nonatomic,copy) NSString *zl_userId;      ///<
@property (nonatomic,copy) NSString *zl_preMobile;
@property (nonatomic,copy) NSString *zl_globalUserId;

+(PABaseUserModel *)zlSetUserInfo:(NSDictionary *)userInfo;

-(NSDictionary *)zl_userInfo;

@end

NS_ASSUME_NONNULL_END
