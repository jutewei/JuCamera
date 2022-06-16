//
//  JuZoomScaleImageView.m
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuScaleScrollView.h"

@interface JuScaleScrollView()

@end

@implementation JuScaleScrollView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator   = NO;
        self.backgroundColor                = [UIColor clearColor];
        self.delegate                       = self;

        UITapGestureRecognizer *ju_doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(juDoubleTap:)];
        ju_doubleTap.numberOfTapsRequired    = 2;
        ju_doubleTap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:ju_doubleTap];

        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(juTouchTap)];
        gesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:gesture];
        [gesture requireGestureRecognizerToFail:ju_doubleTap];

        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(juTouchLong:)];
        [self addGestureRecognizer:longPress];
        self.maximumZoomScale               = 2;
        self.bouncesZoom                    = YES;
        self.minimumZoomScale               = 1.0;
        [self shSetImageView];
        //        屏幕旋转时重新布局
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(juStatusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return self;
}


- (void)juStatusBarOrientationChange:(NSNotification *)notification{
    if (_ju_imgView.image) {
        [self setItemFrameWithImage:_ju_imgView.image];
    }
}

-(void)shSetImageView{
    _ju_imgView               = [[UIImageView alloc] init];
    _ju_imgView.clipsToBounds = YES;
    _ju_imgView.contentMode   = UIViewContentModeScaleAspectFill;
    _ju_imgView.tag=918;
    [self addSubview:_ju_imgView];
}

//设置图片展开
- (void) setItemFrameWithImage:(UIImage *)image{
    if (image){
        self.zoomScale=1;
        _ju_imgView.image=image;
        CGSize imgSize = image.size;
        //判断首先缩放的值
        float scaleX = JU_Window_Width/imgSize.width;
        float scaleY = JU_Window_Height/imgSize.height;
        //倍数小的，先到边缘
        if (scaleX > scaleY){
            //Y方向先到边缘
            float imgViewWidth = imgSize.width*scaleY;
            self.maximumZoomScale =MAX(2.5, JU_Window_Width/imgViewWidth) ;
            ju_originRect = (CGRect){JU_Window_Width/2-imgViewWidth/2,0,imgViewWidth,JU_Window_Height};
        }
        else{
            //X先到边缘
            float imgViewHeight = imgSize.height*scaleX;
            self.maximumZoomScale =MAX(2.5, JU_Window_Height/imgViewHeight) ;
            ju_originRect = (CGRect){0,JU_Window_Height/2-imgViewHeight/2,JU_Window_Width,imgViewHeight};
        }
        [self juSetImageFrame];
    }
}

- (void)juSetImageFrame{
    self.ju_imgView.frame = self->ju_originRect;
    self.contentSize=self.ju_imgView.frame.size;
}

//隐藏
-(void)juTouchTap{

}

/**
 可实现长安保存图片
 */
-(void)juTouchLong:(id)sender{
    NSLog(@"长按");
}

/**
 双击缩放
 */
-(void)juDoubleTap:(UIGestureRecognizer *)sender{
    UIScrollView *scr=(UIScrollView *)sender.view;
    float newScale=0 ;
    if (scr.zoomScale>1.0) {
        [scr setZoomScale:1.0 animated:YES];
    }
    else{
        newScale=self.maximumZoomScale;
        CGRect zoomRect = [self juZoomRectForScale:newScale withCenter:[sender locationInView:sender.view]];
        [scr zoomToRect:zoomRect animated:YES];
    }
}
//**双击倍数*/
- (CGRect)juZoomRectForScale:(float)scale withCenter:(CGPoint)center{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}
#pragma mark -
#pragma mark - scroll delegate
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _ju_imgView;
}
//捏合缩放动画
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{

    CGSize boundsSize = scrollView.bounds.size;
    CGRect imgFrame = _ju_imgView.frame;
    CGSize contentSize = scrollView.contentSize;
    CGPoint centerPoint = CGPointMake(contentSize.width/2, contentSize.height/2);
    // center horizontally
    if (imgFrame.size.width <= boundsSize.width){
        centerPoint.x = boundsSize.width/2;
    }
    // center vertically
    if (imgFrame.size.height <= boundsSize.height){
        centerPoint.y = boundsSize.height/2;
    }
    _ju_imgView.center = centerPoint;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    _ju_imgView.image=nil;
}

@end
