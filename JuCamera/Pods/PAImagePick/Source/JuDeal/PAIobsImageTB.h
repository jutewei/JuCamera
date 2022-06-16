//
//  PAIobsImageTB.h
//  FMDB
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/9/8.
//

#import "JuBaseDBModel.h"
#import "SDImageCache.h"

NS_ASSUME_NONNULL_BEGIN

@interface PAIobsImageTB : JuBaseDBModel

@property (nonatomic,copy)NSString *zl_requestId;
@property (nonatomic,copy)NSString *zl_url;
@property (nonatomic,copy)NSString *zl_userId;

+(id)zlSelectWithID:(NSString *)requestId;

+(BOOL)zlInsertWithID:(NSString *)requestId withUrl:(NSString *)url;

@end
NS_ASSUME_NONNULL_END
