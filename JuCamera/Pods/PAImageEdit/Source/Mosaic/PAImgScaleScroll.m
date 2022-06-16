//
//  JuZoomScaleImageView.m
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "PAImgScaleScroll.h"
#import "PAImgMosaicView.h"
#import "JuLayoutFrame.h"
#import <Photos/Photos.h>
/// 当前宽高
@implementation PAImgScaleScroll
@synthesize ju_zoomView;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        ju_scrollView=[[UIScrollView alloc]init];
        [self addSubview:ju_scrollView];
        ju_scrollView.juEdge(UIEdgeInsetsZero);
        ju_scrollView.showsHorizontalScrollIndicator = NO;
        ju_scrollView.showsVerticalScrollIndicator   = NO;
        ju_scrollView.backgroundColor                = [UIColor clearColor];
        ju_scrollView.delegate                       = self;
        ju_scrollView.maximumZoomScale               = 2;
        ju_scrollView.bouncesZoom                    = YES;
        ju_scrollView.minimumZoomScale               = 1.0;
        ju_scrollView.scrollEnabled=NO;
        if (@available(iOS 11.0, *)) {
            ju_scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return self;
}
-(void)setIsEdit:(BOOL)isEdit{
    _isEdit=isEdit;
    ju_scrollView.scrollEnabled=!isEdit;
}
/**
 设置图片
 */
//设置图片展开
- (void)setImage:(UIImage *)image{
    if (image){
        ju_scrollView.zoomScale=1;
        CGSize imgSize = image.size;
        //判断首先缩放的值
        float scaleX = Window_Width/imgSize.width;
        float scaleY = Window_Height/imgSize.height;
        //倍数小的，先到边缘
        if (scaleX > scaleY){
            //Y方向先到边缘
            float imgViewWidth = imgSize.width*scaleY;
            ju_scrollView.maximumZoomScale =MAX(2.5, Window_Width/imgViewWidth) ;
            ju_originRect = (CGRect){Window_Width/2-imgViewWidth/2,0,imgViewWidth,Window_Height};
        }
        else{
            //X先到边缘
            float imgViewHeight = imgSize.height*scaleX;
            ju_scrollView.maximumZoomScale =MAX(2.5, Window_Height/imgViewHeight) ;
            ju_originRect = (CGRect){0,Window_Height/2-imgViewHeight/2,Window_Width,imgViewHeight};
        }
        ju_scrollView.contentSize=ju_originRect.size;
    }
}


#pragma mark -
#pragma mark - scroll delegate
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return ju_zoomView;
}
//捏合缩放动画
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imgFrame = ju_zoomView.frame;
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
    ju_zoomView.center = centerPoint;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view {
    if (_isEdit) {
        ju_scrollView.scrollEnabled=YES;
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale{
    if (_isEdit) {
        ju_scrollView.scrollEnabled=NO;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]&&_isEdit) {
        switch (gestureRecognizer.state) {
            case UIGestureRecognizerStateBegan:
                ju_zoomView.userInteractionEnabled=NO;
                break;
            default:
                ju_zoomView.userInteractionEnabled=YES;
                break;
        }
    }
    return YES;
}

@end
