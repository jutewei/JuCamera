//
//  JuZoomScaleImageView.m
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuScaleCollectItem.h"
#import "UIImageView+netImage.h"
#import "JuProgressView.h"
#import "UIView+Frame.h"

@interface JuScaleCollectItem()<UIScrollViewDelegate>{
    //缩放前大小
    CGRect ju_smallRect;
    BOOL isDrugDown,isDrugMiss,isBeginDown;
    CGPoint ju_moveBeginPoint,ju_imgBeginPoint;
    CGFloat ju_lastMoveY;
}
@property  BOOL isAnimate;
@property (nonatomic,strong) JuProgressView *sh_progressView;
@property (nonatomic,strong) UIImageView *ju_imageMove;
@property (nonatomic,weak) JuImageObject *ju_imageM;

@end

@implementation JuScaleCollectItem

//进度条
-(JuProgressView *)sh_progressView{
    if (!_sh_progressView) {
        JuProgressView *view=[[JuProgressView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        view.center=self.center;
        view.ju_progressWidth=5;
        view.ju_backWidth=5;
        view.ju_progressColor=[UIColor whiteColor];
        view.ju_backColor=[UIColor colorWithWhite:0.5 alpha:0.5];
        view.ju_Progress=0;
        _sh_progressView=view;
        [self.superview addSubview:view];
    }
    return _sh_progressView;
}
/**
 加载前的状态
 */
-(UIActivityIndicatorView *)juActivity{
    UIActivityIndicatorView *activity=(id)[self.superview viewWithTag:112];
    if (!activity) {
        activity=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activity.hidesWhenStopped = YES;
        activity.tag              = 112;
        activity.center           = self.center;
        [self.superview addSubview:activity];
    }
    return activity;
}

/**
 设置图片
 */
- (void)setItemData:(JuImageObject *)imageObject
         originalRect:(CGRect)originalRect{
    
    self.alwaysBounceVertical=YES;
    self.alwaysBounceHorizontal=YES;
    
    if (![imageObject isKindOfClass:[JuImageObject class]]) return;
    _ju_imageM=imageObject;

    if (originalRect.size.width>0) {
        _isAnimate=YES;
        self.ju_imgView.frame = originalRect;
        ju_smallRect = originalRect;
    }
    
    switch (imageObject.ju_imageType) {
        case JuImageTypeUrl:{
            if ([UIImageView diskImageDataExistsWithKey:imageObject.ju_thumbImageUrl]) {
                UIImage *lastPreviousCachedImage = [UIImageView imageFromDiskCacheForKey:imageObject.ju_thumbImageUrl];
                [self setItemData:lastPreviousCachedImage];
            }else{
                [self.juActivity startAnimating];
            }
            [self juSetFullImage];
        }
            break;
        case JuImageTypeAsset:{
            [self setItemData:imageObject.ju_asset];
            imageObject.ju_progress=1;
        }
            break;
        default:{
            [self setItemData:imageObject.ju_image];
            imageObject.ju_progress=1;
        }
            break;
    }
}

//获取大图
-(void)juSetFullImage{
    
    if (_ju_imageM.ju_imageType==JuImageTypeAsset) {
        [super juSetFullImage];
        return;
    }else if(_ju_imageM.ju_imageType==JuImageTypeImage){
        return;
    }
    
    
    if (self.juImageM.ju_progress<1) {
//        self.sh_progressView.hidden=NO;
        self.sh_progressView.ju_Progress=self.juImageM.ju_progress;
    }

    __weak typeof(self) weakSelf = self;
    NSString *imageUrl=_ju_imageM.ju_imageUrl;
    [self.ju_imgView juSetImageWithURL:imageUrl iobsKey:_ju_imageM.ju_iobsKey progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        ju_dispatch_get_main_async(^{///< 进度
            if ([imageUrl isEqual:weakSelf.juImageM.ju_imageUrl]) {
                [weakSelf juSetProgress:MAX((float)receivedSize/(float)expectedSize, 0.01)];
            }
        });
    } completed:^(UIImage * _Nullable image,BOOL finished) {
        ju_dispatch_get_main_async(^{///< 完成
            if ([imageUrl isEqual:weakSelf.juImageM.ju_imageUrl]) {
                [weakSelf juLoadFinish:image];
            }
        });
    }];
}

-(void)juSetProgress:(CGFloat)progress{
    [self.juActivity stopAnimating];
    self.juImageM.ju_progress=self.sh_progressView.ju_Progress=progress;
}

-(void)juLoadFinish:(UIImage *)image{
    [self setItemFrameWithImage:image];
    [self juSetProgress:1];
}

- (void)juSetImageFrame{
    [UIView animateWithDuration:_isAnimate?0.3:0 animations:^{
        self.self.ju_imgView.frame = self->ju_originRect;
    }completion:^(BOOL finished) {
        self.contentSize=self.self.ju_imgView.frame.size;
        self.isAnimate=NO;
    }];
}

//隐藏
-(void)juTouchTap{
    if ([self.ju_delegate respondsToSelector:@selector(juCurrentRect)]) {///< 网络图片看大图
        CGRect frame= [self.ju_delegate juCurrentRect];
        if (frame.size.width>0) {
            ju_smallRect=frame;
            _isAnimate=YES;
        }
        CGRect winFrame=self.window.frame;
        winFrame.origin.y=64;
        winFrame.size.height-=64;
        if (!CGRectIntersectsRect(winFrame, frame)) {
            _isAnimate=NO;
        }
        [self juHiddenAnimation];
    }
}

//恢复到原始zoom
- (void) juHiddenAnimation{
    if (self.isAnimate) {
        [UIView animateWithDuration:0.3 animations:^{
            self.contentOffset=CGPointMake(0, 0);
            self.contentSize=self->ju_originRect.size;
            self.self.ju_imgView.frame =self->ju_smallRect;
        }completion:^(BOOL finished) {
            self.self.ju_imgView.frame =self->ju_smallRect;
        }];
    }
    if ([self.ju_delegate respondsToSelector:@selector(juTapHidder)]) {
        [self.ju_delegate juTapHidder];
    }
}

/**
 双击缩放
 */

#pragma mark -
#pragma mark - scroll delegate
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if (self.juImageM.ju_progress<1) return nil;
    return [super viewForZoomingInScrollView:scrollView];
}

/**判断是否向下拖拽*/
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat  scrollNewY = scrollView.contentOffset.y;
    if ([self.ju_delegate respondsToSelector:@selector(juNotMoveHidder)]) {
        if ([self.ju_delegate juNotMoveHidder]) {
            return;
        }
    }
    if (scrollNewY <0&&self.dragging&&isBeginDown){
        isDrugDown=YES;
    }
    if (isDrugDown) {
        [self juTouchPan:scrollView.panGestureRecognizer];
    }
}
//结束拖拽
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (isDrugDown) {
        if (isDrugMiss) {///< 达到消失临界值
            //            self.contentOffset=ju_scrollOffSet;
            self.self.ju_imgView.frame= self.ju_imageMove.frame;
            self.self.ju_imgView.hidden=NO;
            [self.ju_imageMove removeFromSuperview];
            self.ju_imageMove=nil;
            [self juTouchTap];
        }else{///< 未达到消失值恢复原始值
            isDrugDown=NO;
            ju_lastMoveY=0;
            ju_moveBeginPoint=CGPointMake(0, 0);
            [UIView animateWithDuration:0.4 animations:^{
                self.self.ju_imgView.frame=self.ju_imgMoveRect;
                self.ju_imageMove.frame=self.ju_imgMoveRect;
            }completion:^(BOOL finished) {
                self.self.ju_imgView.hidden=NO;
                [self.ju_imageMove removeFromSuperview];
                self.ju_imageMove=nil;
            }];
            if ([self.ju_delegate respondsToSelector:@selector(juChangeSacle:)]) {
                [self.ju_delegate juChangeSacle:!isDrugMiss];
            }
        }
    }
}
-(CGRect)ju_imgMoveRect{
    return self.self.ju_imgView.frame;
}
//复制一个可以移动的视图
-(UIImageView *)ju_imageMove{
    if (!_ju_imageMove) {
        _ju_imageMove=[[UIImageView alloc]init];
        _ju_imageMove.clipsToBounds = YES;
        _ju_imageMove.contentMode   = UIViewContentModeScaleAspectFill;
        _ju_imageMove.image=self.self.ju_imgView.image;
    }
    return _ju_imageMove;
}
//下滑变小
- (void)juTouchPan:(UIPanGestureRecognizer *)pan{
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStatePossible||pan.numberOfTouches != 1 ){
        ju_lastMoveY=0;
        isDrugDown=NO;
        return;
    }
    if (!self.ju_imageMove.superview) {
        self.ju_imageMove.frame=self.ju_imgMoveRect;
        [self addSubview:self.ju_imageMove];
    }
    self.self.ju_imgView.hidden=YES;
    self.ju_imageMove.hidden=NO;
    if (ju_moveBeginPoint.y==0&&ju_moveBeginPoint.x==0) {
        ju_moveBeginPoint=[pan locationInView:self];/// 记录开始移动时坐标
        ju_imgBeginPoint=[pan locationInView:_ju_imageMove];/// 记录图片移动开始的时候坐标
    }

    CGPoint movePoint = [pan locationInView:self];
    CGPoint currentPoint = CGPointMake(movePoint.x-ju_moveBeginPoint.x, movePoint.y-ju_moveBeginPoint.y);
    CGFloat changeScale;

    if (currentPoint.y>0) {
        changeScale=MAX(1-(currentPoint.y)/300.0,0.3);
    }else{
        changeScale=MAX(1+(currentPoint.y)/300.0,0.9);
    }

    _ju_imageMove.transform=CGAffineTransformMakeScale(changeScale,changeScale);
    CGFloat minusScale=1-changeScale;
    //    移动坐标由原始坐标和移动坐标已经缩放相对尺寸坐标

    CGFloat moveY=currentPoint.y+self.ju_imgMoveRect.origin.y+ju_imgBeginPoint.y*minusScale;
    CGFloat moveX=currentPoint.x+self.ju_imgMoveRect.origin.x+ju_imgBeginPoint.x*minusScale;

    isDrugMiss=moveY>ju_lastMoveY;
    ju_lastMoveY=moveY;

    self.ju_imageMove.originY=moveY;
    self.ju_imageMove.originX=moveX;

    if ([self.ju_delegate respondsToSelector:@selector(juChangeSacle:)]) {
        [self.ju_delegate juChangeSacle:MIN(0.99, changeScale)];
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint translation = [self.panGestureRecognizer translationInView:self];
    isBeginDown=(translation.y>0)&&gestureRecognizer.numberOfTouches==1;
    if (gestureRecognizer==self.panGestureRecognizer) {
        if (translation.y<0&&self.contentSize.height<self.sizeH) {
            return NO;
        }
    }
    return YES;
}

-(JuImageObject *)juImageM{
    return self.ju_imageM;
}

@end
