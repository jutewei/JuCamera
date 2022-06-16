//
//  PABaseContentTVC.h
//  PABase
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/6/3.
//

#import "PABaseTableVC.h"
#import "JuBaseContentVM.h"
NS_ASSUME_NONNULL_BEGIN

@interface PABaseContentTVC : PABaseTableVC
-(void)zlSetPostV:(NSString *)postVale showV:(NSString *)showVale;
-(void)zlSetModel:(PARequestModel *)model postV:(NSString *)postVale showV:(NSString *)showVale;
-(JuBaseContentVM *)vModel;
@end

NS_ASSUME_NONNULL_END
