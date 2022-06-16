//
//  PFBTabBar.m
//  PABase
//
//  Created by Juvid on 2017/10/12.
//  Copyright © 2017年 Juvid(zhutianwei). All rights reserved.
//

#import "PATabBar.h"
//#import "JuBadgeLable.h"
#import "JUEasyUse.h"
//#import <UIImageView+ModCache.h>


@implementation PATabBar



-(void)layoutSubviews{
    [super layoutSubviews];
    if (!_sh_arrBage) {
        _sh_arrBage=[NSMutableArray array];
        for (UIView *subView in self.subviews) {
            if ([NSStringFromClass([subView class]) isEqual:@"UITabBarButton"]) {
//                JuBadgeLable *view=[[JuBadgeLable alloc]initWithFrame:CGRectMake(CGRectGetMidX(subView.frame)+6, 4, 18, 18)];
//                [view.layer setBorderColor:[UIColor whiteColor].CGColor];
//                [view.layer setBorderWidth:1];
//                view.font=[UIFont systemFontOfSize:10];
////                view.image=[UIImage imageNamed:@"bottom_bar_red"];
//                view.backgroundColor=[UIColor redColor];
//                [view setContentMode:UIViewContentModeScaleAspectFit];
//                [subView.superview addSubview:view];
////                view.hidden=YES;
//                [_sh_arrBage addObject:view];
//                view.backgroundColor=PAColor_MessageRed;
            }
        }
//        [self shUpdateMessageBadge];
    }
}

-(void)shUpdateMessageBadge:(NSInteger)num{
//    JuBadgeLable *view=_sh_arrBage[2];
//    [view juSetTitle:[NSString stringWithFormat:@"%ld",(long)num]];
//    UIView *badgeView=_sh_arrBage.lastObject;

}

+(PATabBar *)juTabbar{
    return (PATabBar *)JUEasyUse.juRootWindowVC.tabBar;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
