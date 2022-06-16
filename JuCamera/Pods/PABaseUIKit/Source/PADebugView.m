//
//  PADebugView.m
//  PAImagePick
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2022/5/10.
//

#import "PADebugView.h"
#define PADebugItemW 50

@implementation PADebugView{
    BOOL isMove;
    dispatch_block_t zl_handle;
}

+ (instancetype) sharedInstance{
    static PADebugView *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PADebugView alloc] init];
    });
    return sharedInstance;

}

-(instancetype)init{
    self=[super init];
    if (self) {
        [self addTarget:self action:@selector(zlTcouh) forControlEvents:UIControlEventTouchUpInside];
        [self.layer setCornerRadius:PADebugItemW/2.0];
//        self.backgroundColor=[UIColor greenColor];
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, PADebugItemW, PADebugItemW)];
        lab.text=@"👽";
        lab.font=[UIFont systemFontOfSize:43];
        lab.textAlignment=NSTextAlignmentCenter;
        [self addSubview:lab];
        UIWindow *window=[UIApplication sharedApplication].delegate.window;
//        CGFloat winWidth=CGRectGetWidth(window.frame);
        CGFloat winHeight=CGRectGetHeight(window.frame);
        self.frame=CGRectMake(0, winHeight-150, PADebugItemW, PADebugItemW);
    }
    return self;
}

+(void)zlShowView:(dispatch_block_t)handle{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[PADebugView sharedInstance] zlShowView:handle];
    });
}

-(void)zlTcouh{
    if (!isMove&&zl_handle) {
        zl_handle();
    }
}

-(void)zlShowView:(dispatch_block_t)handle{
    zl_handle=handle;
    UIWindow *window=[UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    self.alpha=0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=0.9;
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    isMove=NO;
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];// 某一个手指
    CGPoint currentPoint = [touch locationInView:self.superview]; // 自己相对于父视图的坐标
    CGPoint previousPoint = [touch previousLocationInView:self.superview];
    CGFloat dltX = currentPoint.x - previousPoint.x;
    CGFloat dltY = currentPoint.y - previousPoint.y;
    CGPoint center = self.center;
    CGPoint newCenter = CGPointMake(center.x + dltX, center.y + dltY);
    self.center = newCenter;
    CGRect frame=self.frame;
    CGFloat statusHeight=[UIApplication sharedApplication].statusBarFrame.size.height;
    if (frame.origin.x<0) {
        frame.origin.x=0;
    }
    if (frame.origin.y<statusHeight) {
        frame.origin.y=statusHeight;
    }
    CGFloat winWidth=CGRectGetWidth(self.superview.frame);
    CGFloat winHeight=CGRectGetHeight(self.superview.frame);
    if (CGRectGetMaxX(frame)>winWidth) {
        frame.origin.x=winWidth-PADebugItemW;
    }
    if (CGRectGetMaxY(frame)>winHeight) {
        frame.origin.y=winHeight-PADebugItemW;
    }
    self.frame=frame;
    isMove=YES;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    CGFloat centerX=CGRectGetMidX(self.frame);
//    CGFloat centerY=CGRectGetMidY(self.frame);
    CGFloat winWidth=CGRectGetWidth(self.superview.frame);
//    CGFloat winHeight=CGRectGetHeight(self.superview.frame);
    CGRect frame=self.frame;
    if (centerX>winWidth/2.0) {
        frame.origin.x=winWidth-PADebugItemW;
    }else{
        frame.origin.x=0;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.frame=frame;
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
