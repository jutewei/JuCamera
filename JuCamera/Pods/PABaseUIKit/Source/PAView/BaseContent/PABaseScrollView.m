//
//  PABaseScrollView.m
//  PABase
//
//  Created by Juvid on 2021/4/19.
//

#import "PABaseScrollView.h"

@implementation PABaseScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self];
    CGPoint location = [gestureRecognizer locationInView:self];

    if (velocity.x > 0.0f&&(int)location.x%(int)Screen_Width<60) {
        return NO;
    }
    return YES;
}
@end
