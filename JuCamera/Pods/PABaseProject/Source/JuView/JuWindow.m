//
//  JuWindow.m
//  TestWindow
//
//  Created by Juvid on 2017/8/10.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import "JuWindow.h"

@implementation JuWindow


-(instancetype)init{
    self=[super init];
    if (self) {
        self.frame=[UIScreen mainScreen].bounds;
        self.windowLevel=UIWindowLevelNormal+1;
        self.rootViewController=[UIViewController new];
        [self setBackgroundColor:[UIColor clearColor]];
        //        [self makeKeyAndVisible];
    }
    return self;
}
+(id)juInit{
    JuWindow *window=[[JuWindow alloc]init];
    return window;
}
-(void)shShowWindow{
    self.hidden=NO;
}
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if (self.windowLevel==UIWindowLevelNormal) {
        [self juHidden];
    }
    return [super hitTest:point withEvent:event];
}
-(void)juHidden{
    self.hidden=YES;
    [self resignKeyWindow];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
