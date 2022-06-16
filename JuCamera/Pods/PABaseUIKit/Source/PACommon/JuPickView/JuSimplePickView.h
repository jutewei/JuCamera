//
//  JuSimplePickView.h
//  PABase
//
//  Created by Juvid on 2020/12/26.
//  Copyright © 2020 Juvid. All rights reserved.
//

#import "JuMultiPickView.h"

NS_ASSUME_NONNULL_BEGIN
//不联动的pickView
@interface JuSimplePickView : JuMultiPickView
-(void)juSetDataList:(NSArray *)dataList;
@end

NS_ASSUME_NONNULL_END
