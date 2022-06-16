//
//  JuInputDataAdapter.h
//  PABase
//
//  Created by Juvid on 2018/12/5.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JuDataProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface JuInputDataAdapter : NSObject<JuDataProtocol>
@property (nonatomic, weak) id juData;
- (instancetype)initWithData:(id)data;
@end

NS_ASSUME_NONNULL_END
