//
//  JuKeyBoardManage.h
//  PABase
//
//  Created by Juvid on 2018/9/20.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JuKeyBoardManage : NSObject
+ (instancetype) sharedInstance;

@property BOOL isFullScreen;//是否全屏移动
@property (weak,nonatomic) UIView *ju_moveView;///< 切换不同等级的视图时需要重新设置
@end
