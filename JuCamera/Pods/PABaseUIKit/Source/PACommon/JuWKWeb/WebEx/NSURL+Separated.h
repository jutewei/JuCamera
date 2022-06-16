//
//  URL+Separated.h
//  JuCycleScroll
//
//  Created by Juvid on 2018/12/14.
//  Copyright © 2018年 Juvid(zhutianwei). All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface NSURL (Separated)

-(NSDictionary *)shSeparatedByString;

-(NSDictionary *)shSeparatedByString:(NSString *)string;

-(NSDictionary *)mtUrlJumpParam;

@end

NS_ASSUME_NONNULL_END
