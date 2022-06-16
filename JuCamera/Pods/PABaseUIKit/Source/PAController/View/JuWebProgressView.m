//
//  NJKWebViewProgressView.m
//
//  Created by Satoshi Aasanoon 11/16/13.
//  Copyright (c) 2013 Satoshi Asano. All rights reserved.
//

#import "JuWebProgressView.h"
#import "JuLayoutFrame.h"
#import "NSObject+JuEasy.h"
@implementation JuWebProgressView

+(JuWebProgressView *)juInitWithView:(UIView *)view{
    CGFloat progressBarHeight = 2.f;
         CGRect navigationBarBounds = view.bounds;
         CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
      JuWebProgressView   *_progressView = [[JuWebProgressView alloc] initWithFrame:barFrame];
         _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    return _progressView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureViews];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configureViews];
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        CGFloat progressBarHeight = 2.f;
        CGRect navigationBarBounds = newSuperview.bounds;
        CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
        self.frame=barFrame;
    }
}
-(void)configureViews{
    self.userInteractionEnabled = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _progressBarView = [[UIView alloc] initWithFrame:self.bounds];
    _progressBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//     UIColor *tintColor = [UIColor colorWithRed:22.f / 255.f green:126.f / 255.f blue:251.f / 255.f alpha:1.0]; // iOS7 Safari bar color
    UIColor *tintColor = PAColor_Main; // iOS7 Safari bar color
    if ([UIApplication.sharedApplication.delegate.window respondsToSelector:@selector(setTintColor:)] && UIApplication.sharedApplication.delegate.window.tintColor) {
        tintColor = UIApplication.sharedApplication.delegate.window.tintColor;
    }
    _progressBarView.backgroundColor = tintColor;
    [self addSubview:_progressBarView];
    
    _barAnimationDuration = 0.27f;
    _fadeAnimationDuration = 0.27f;
    _fadeOutDelay = 0.1f;
}

-(void)setProgress:(float)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    BOOL isGrowing = progress > 0.0;
    [UIView animateWithDuration:(isGrowing && animated) ? _barAnimationDuration : 0.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = _progressBarView.frame;
        frame.size.width = progress * self.bounds.size.width;
        _progressBarView.frame = frame;
    } completion:nil];

    if (progress >= 1.0) {
        [UIView animateWithDuration:animated ? _fadeAnimationDuration : 0.0 delay:_fadeOutDelay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _progressBarView.alpha = 0.0;
        } completion:^(BOOL completed){
            CGRect frame = _progressBarView.frame;
            frame.size.width = 0;
            _progressBarView.frame = frame;
        }];
    }
    else {
        [UIView animateWithDuration:animated ? _fadeAnimationDuration : 0.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _progressBarView.alpha = 1.0;
        } completion:nil];
    }
}

@end


@implementation JuWebMarkView{
    BOOL hasEdge;
    UILabel *labMark;
    __weak UIScrollView *ju_scrollView;
}

+(instancetype)initWithView:(UIScrollView *)scrollView{
    JuWebMarkView *view=[[JuWebMarkView alloc]init];
    view.ju_scrollView=scrollView;
    return view;
}

-(instancetype)init{
    self=[super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(juStatusBarFrameChange:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
        [self setClipsToBounds:YES];
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

- (void)juStatusBarFrameChange:(NSNotification *)notification{
    if (self.window) {
        self.ju_Top.constant=self.mtSafeHeight;
    }
}

-(void)setJu_scrollView:(UIScrollView *)scrollView{
    ju_scrollView=scrollView;
    [self setMarkLab];
}

-(void)setMarkLab{
    labMark=[[UILabel alloc]init];
    labMark.textAlignment=NSTextAlignmentCenter;
    [self addSubview:labMark];
    labMark.textColor=PAColor_LightGray;
    labMark.font= [UIFont systemFontOfSize:12];
    {
        labMark.juTop.equal(15);
        labMark.juCenterX.equal(0);
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.ju_Top.constant=self.mtSafeTop;
    CGFloat offsetY=-(self.mtSafeHeight+scrollView.contentOffset.y);
    if (offsetY>=0) {
        self.ju_Height.constant=offsetY;
        self.alpha=(offsetY-50)/60;
    }
}

-(void)setMt_urlHost:(NSString *)mt_urlHost{
    labMark.text=[NSString stringWithFormat:@"此网页由 %@ 提供",mt_urlHost];
}

-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    if (self.superview) {
        self.juLead.equal(0);
        self.juCenterX.equal(0);
        self.juTop.equal(self.mtSafeTop);
        self.juHeight.equal(0.01);
    }
}

-(CGFloat)mtSafeTop{
    CGFloat contentInsetTop=self.mtSafeHeight;
    UIRectEdge edge=ju_scrollView.viewController.edgesForExtendedLayout;
  //    透明导航栏
    if ((edge==UIRectEdgeAll||edge==UIRectEdgeTop)&&contentInsetTop==0) {
        return [[UIApplication sharedApplication] statusBarFrame].size.height-15;
    }
  //    有导航栏
    return contentInsetTop;
}

-(CGFloat)mtSafeHeight{
    CGFloat contentInsetTop=ju_scrollView.contentInset.top;
      if (@available(iOS 11.0, *)) {
          contentInsetTop+=ju_scrollView.adjustedContentInset.top;
      }
  //    透明导航栏
    return contentInsetTop;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
