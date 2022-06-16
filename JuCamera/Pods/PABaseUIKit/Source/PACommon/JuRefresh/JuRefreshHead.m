//
//  JuRRefresh.m
//  JuRefresh
//
//  Created by Juvid on 16/9/1.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JuRefreshHead.h"
#import "JuLayoutFrame.h"
//#define InsetH   65  //(MAX(20,[[UIApplication sharedApplication] statusBarFrame].size.height)+45)
@interface JuRefreshHead (){
    BOOL isDidRefresh;///< 即将开始刷新
    UIImageView *imageView;
    BOOL isRefreshing;
    BOOL isDrag;
    CGFloat ju_refreshH;
}
@property (nonatomic,copy  ) dispatch_block_t ju_StartRefresh;//开始刷新
@end

@implementation JuRefreshHead

+(instancetype)juHeadWithhandle:(dispatch_block_t)handle{
    JuRefreshHead *refresh=[[self alloc]init];
    refresh.ju_StartRefresh=handle;
    return refresh;
}

-(void)juSetView{
    [super juSetView];
    ju_refreshH=64;
    _ju_statusMsg=@[JuRefreshBegin,JuRefreshIng,JuRefreshPulling];
    self.frame=CGRectMake(0, -ju_refreshH, [[UIScreen mainScreen] bounds].size.width, ju_refreshH);
    self.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin;
    self.labTitle.text=_ju_statusMsg[0];
    imageView=[[UIImageView alloc]init];
    imageView.image=[UIImage imageNamed:@"arrow"];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:imageView];

    self.labTitle.ju_CenterY.constant=6;
    imageView.juTraSpace.toView(self.labTitle).equal(10);
    imageView.juCenterY.toView(self.labTitle).equal(0);

    self.alpha=0.01;
}
-(void)setJu_customImage:(NSString *)ju_customImage{
    [super setJu_customImage:ju_customImage];
    imageView.image=[UIImage imageNamed:ju_customImage];
}
-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    if (self.superview) {
        if (@available(iOS 11.0, *)) {
//            无导航栏时加上状态栏高度
            if (scrollView.contentInsetAdjustmentBehavior==UIScrollViewContentInsetAdjustmentNever) {
                ju_refreshH=[[UIApplication sharedApplication] statusBarFrame].size.height+44;
//                ju_insetH=ju_refreshH+1;
            }
        }
    }
}
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    CGPoint pointNew=[change[@"new"] CGPointValue];
    CGPoint pointOld=[change[@"old"] CGPointValue];
    [self juWillRefresh:pointNew];
    if (!scrollView.isDragging) { // 如果正在拖拽
        BOOL isNotRefresh=isRefreshing||pointOld.y==0||!isDrag;
        if (!isNotRefresh) {
            if (pointOld.y < -(self.juRefreshH)) {
                [self juStartRefresh];
            }
        }
        isDrag=NO;
    }else{
        isDrag=YES;
    }
}
-(void)didMoveToWindow{
    [super didMoveToWindow];
    if (self.window) {
        [self juDidRefresh];
    }
}
-(void)juWillRefresh:(CGPoint)contentOffset{
    if (isRefreshing) return;
    self.alpha=contentOffset.y<-(ju_contentInsetTop+self.adjustedInsetTop+10)?1:0.01;
    if (contentOffset.y<-(self.juRefreshH)) {
        self.labTitle.text=_ju_statusMsg[2];
    }else{
        self.labTitle.text=_ju_statusMsg[0];
    }
    [self juStartAnimation:contentOffset.y];
}
-(void)juDidRefresh{

    if (!scrollView||self.hidden) return;

    if (!self.window||!isDidRefresh) return;

//    [scrollView setContentOffset:CGPointMake(0, 0)];

    ju_RefreshOffsetH = ju_refreshH + self.ju_topSpace;

    isRefreshing=YES;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.025 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self juStartLoad:YES];

    UIEdgeInsets contentInset= scrollView.contentInset;
    contentInset.top=ju_RefreshOffsetH+ju_contentInsetTop;

    [UIView animateWithDuration:.3 animations:^{
        scrollView.contentInset = contentInset;
        CGFloat offsetY=self.adjustedInsetTop?:contentInset.top;
        [scrollView setContentOffset:CGPointMake(0, -(offsetY+2))];
    }];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(self.ju_StartRefresh)  self.ju_StartRefresh();
    });
    isDidRefresh=NO;
//    });
}

-(void)juStartRefresh{
    isDidRefresh=YES;
    [self juDidRefresh];
}
-(void)juEndRefresh{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIEdgeInsets contentInset= scrollView.contentInset;
        contentInset.top=ju_contentInsetTop;
        [UIView animateWithDuration:0.35 animations:^{
            scrollView.contentInset=contentInset;
        } completion:^(BOOL finished) {
            isRefreshing=NO;
            [self juStartLoad:NO];
        }];
    });
}

/**拖拽动画**/
- (void)juStartAnimation:(CGFloat)refreshY{
    CGFloat transForm =0;
    if (self.ju_customImage) {
        transForm = -(refreshY/30*M_PI);
    }else{
        BOOL refresh=refreshY<-(self.juRefreshH);
        transForm = refresh?-M_PI:2*M_PI;
    }
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(transForm);
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        imageView.transform = endAngle;
    } completion:^(BOOL finished) {}];
}

-(CGFloat)juRefreshH{
    return ju_contentInsetTop+ju_refreshH+self.adjustedInsetTop+self.ju_topSpace;
}

//adjustedContentInset 等于ContentInset+安全区域高度
-(CGFloat)adjustedInsetTop{
    CGFloat adjustTop=0;
    if (@available(iOS 11.0, *)) {
        adjustTop=scrollView.adjustedContentInset.top;
    }
    return adjustTop;
}

/**下拉动画*/
-(void)juStartLoad:(BOOL)isStart{
    self.alpha=isStart?1:0.01;
    if (isStart) {
        self.labTitle.text=_ju_statusMsg[1];
        if (self.ju_customImage) {
            [self juRotationAnimation:isStart];
        }else{
            [self.loadingAni startAnimating];
            imageView.hidden=isRefreshing;
        }
    }else{
        self.labTitle.text=_ju_statusMsg[0];
        if (self.ju_customImage) {
            [self juRotationAnimation:isStart];
        }else{
            imageView.hidden=isRefreshing;
            [self.loadingAni stopAnimating];
        }
    }
}

/**自定义下来动画*/
-(void)juRotationAnimation:(BOOL)start{
    if (start) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
        animation.fromValue = [NSNumber numberWithFloat:0.f];
        animation.toValue = [NSNumber numberWithFloat: M_PI *2];
        animation.duration = 0.5;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.repeatCount = MAXFLOAT;
//        CABasicAnimation *rotationAnimation;rotationAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//        rotationAnimation.toValue =[NSNumber numberWithFloat: M_PI * 2.0 ];
//        rotationAnimation.duration = 0.5;
//        rotationAnimation.cumulative = YES;
//        rotationAnimation.repeatCount = MAXFLOAT;
        [imageView.layer addAnimation:animation forKey:@"rotationAnimation"];
    }else{
        [imageView.layer removeAllAnimations];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
