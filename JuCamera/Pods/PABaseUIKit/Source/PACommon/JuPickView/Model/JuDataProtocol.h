//
//  JuDataProtocol.h
//  PABase
//
//  Created by Juvid on 2018/12/5.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JuDataProtocol <NSObject>
- (NSString *)juTitle;
- (NSString *)juId;
- (NSArray *)juArrList;
@end

NS_ASSUME_NONNULL_END
