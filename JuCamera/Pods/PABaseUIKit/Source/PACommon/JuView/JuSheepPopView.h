//
//  PASheepView.h
//  PAZLChannelCar
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2022/1/18.
//  Copyright © 2022 pingan. All rights reserved.
//

#import "JuBasePopView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JuSheepPopView : JuBaseSheetView

+(JuSheepPopView *)zlSetActionItems:(NSArray *)items
                 handle:(JuCallHandle)handle;

@end

NS_ASSUME_NONNULL_END
