//
//  JuRreshen.h
//  JuRefresh
//
//  Created by Juvid on 16/9/1.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JuRefreshBase.h"

@interface JuRefreshHead : JuRefreshBase

+(instancetype)juHeadWithhandle:(dispatch_block_t)handle;
@property (nonatomic,copy)NSArray *ju_statusMsg;

@property (nonatomic,assign)CGFloat ju_topSpace;

-(void)juStartRefresh;
-(void)juEndRefresh;

@end
