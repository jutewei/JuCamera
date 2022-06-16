//
//  PFBBaseCycleScrollDdapter.h
//  JuCycleScroll
//
//  Created by Juvid on 2018/10/25.
//  Copyright © 2018年 Juvid(zhutianwei). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JuCycleScrollProtocol.h"
@interface JuCycleScrollAdapter : NSObject<JuCycleScrollProtocol>
/**
 *  输入对象
 */
@property (nonatomic, weak) id juData;

+(id)initWithData:(id)data;

@end
