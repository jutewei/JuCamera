//
//  JuBaseContentVM.h
//  PABase
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/6/3.
//

#import "JuBaseDataVM.h"
#import "PARequestModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JuBaseContentVM : JuBaseDataVM

@property (nonatomic,strong) PARequestModel *zl_currentM;   ///< 列表数据
@end

NS_ASSUME_NONNULL_END
