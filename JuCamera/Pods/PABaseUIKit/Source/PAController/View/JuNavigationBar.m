//
//  MTNavigationBar.m
//  JuCycleScroll
//
//  Created by Juvid on 2020/9/24.
//  Copyright © 2020 Juvid. All rights reserved.
//

#import "JuNavigationBar.h"

@implementation JuNavigationBar

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view=[super hitTest:point withEvent:event];
    if(IOS_MAX_VERSION(11)&&view&&point.y>3&&point.y<44){
        UINavigationItem *item=self.topItem;
        UIView *itemVie=nil;
        if (point.x>0&&point.x<20&&item.leftBarButtonItem) {
            itemVie=item.leftBarButtonItem.customView;
        }else if (point.x>Screen_Width-20&&point.x<Screen_Width&&item.rightBarButtonItem){
            itemVie=item.rightBarButtonItem.customView;
        }
        if (itemVie&&!itemVie.hidden) {
            return itemVie;
        }
    }
    return view;
}

//-(void)layoutSubviews{
//    [super layoutSubviews];
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation UINavigationBar (Edge)
//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    UIView *view=[super hitTest:point withEvent:event];
//    if(IOS_MAX_VERSION(11)&&view&&point.y>3&&point.y<44){
//        UINavigationItem *item=self.topItem;
//        UIView *itemVie=nil;
//        if (point.x>0&&point.x<20&&item.leftBarButtonItem) {
//            itemVie=item.leftBarButtonItem.customView;
//        }else if (point.x>Screen_Width-20&&point.x<Screen_Width&&item.rightBarButtonItem){
//            itemVie=item.rightBarButtonItem.customView;
//        }
//        if (itemVie&&!itemVie.hidden) {
//            return itemVie;
//        }
//    }
//    return view;
//}
//-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
//    CGPoint point1=point;
//    if(IOS_MAX_VERSION(13)&&point.y<44){
//        point1=CGPointMake(24, 25);
//    }
//    return [super pointInside:point1 withEvent:event];
//}
@end
