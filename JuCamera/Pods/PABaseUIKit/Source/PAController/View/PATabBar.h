//
//  PFBTabBar.h
//  PABase
//
//  Created by Juvid on 2017/10/12.
//  Copyright © 2017年 Juvid(zhutianwei). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PATabBar : UITabBar
@property (nonatomic,readonly)  NSMutableArray *sh_arrBage;
-(void)shUpdateMessageBadge:(NSInteger)num;
+(PATabBar *)juTabbar;
@end
