//
//  UIImageView+CycleAdapter.h
//  JuCycleScroll
//
//  Created by Juvid on 2018/10/25.
//  Copyright © 2018年 Juvid(zhutianwei). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JuCycleScrollProtocol.h"
@interface UIImageView (CycleAdapter)
-(void)juLoadImage:(id<JuCycleScrollProtocol>)data;
@end
