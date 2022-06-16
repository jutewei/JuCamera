//
//  JuLoadMore.m
//  JuRefresh
//
//  Created by Juvid on 16/9/7.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JuRefreshFoot.h"
#import "JuLayoutFrame.h"
//#import "UIImage+bundle.h"
#define LoadFootH 44

@interface JuRefreshFoot (){
    BOOL isBusy;
    UIImageView *imageView;
}
@property (nonatomic,copy  ) JuLoadMoreHandle ju_LoadMore;//开始刷新

@end


@implementation JuRefreshFoot
@synthesize ju_LoadStatus;
-(void)juSetView{
    [super juSetView];
    self.frame=CGRectMake(0, scrollView.contentSize.height, [[UIScreen mainScreen] bounds].size.width, LoadFootH);
    self.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin;
    self.labTitle.text=JuLoadMoreSuccess;
    self.hidden=YES;

    imageView=[[UIImageView alloc]init];
    imageView.image=[UIImage imageNamed:@"arrow"];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:imageView];

    imageView.juTraSpace.toView(self.labTitle).equal(10);
    imageView.juCenterY.toView(self.labTitle).equal(0);
    imageView.hidden=YES;
}

+(instancetype)juFootWithhandle:(JuLoadMoreHandle)handle{
    JuRefreshFoot *refresh=[[self alloc]init];
    refresh.ju_LoadMore=handle;
    return refresh;
}
-(void)setJu_customImage:(NSString *)ju_customImage{
    [super setJu_customImage:ju_customImage];
    imageView.image=[UIImage imageNamed:ju_customImage];
}
-(void)juLoadMoreStatus:(JuLoadStatus)status{
    if (!scrollView) return;
    ju_LoadStatus=status;
    switch (ju_LoadStatus) {
        case JuLoadStatusIng:{
            self.labTitle.text=JuLoadMoreIng;
            [self juStartLoad:YES];
//            [self.loadingAni startAnimating];
        }
            break;
        case JuLoadStatusFinish:{
            self.labTitle.text=JuLoadMoreFinish;
//             [self.loadingAni stopAnimating];
             [self juStartLoad:NO];
        }
            break;
        case JuLoadStatusSuccess:{
            self.labTitle.text=JuLoadMoreSuccess;
             [self juStartLoad:NO];
//             [self.loadingAni stopAnimating];
        }
            break;
        case JuLoadStatusFailure:{
            self.labTitle.text=juLoadMoreFaliure;
//            [self.loadingAni stopAnimating];
             [self juStartLoad:NO];
        }
            break;
        default:
            break;
    }
//    防止文字重叠
    if (ju_LoadStatus==JuLoadStatusFinish||ju_LoadStatus==JuLoadStatusSuccess) {
        CGRect frame=self.frame;
        frame.origin.y=scrollView.contentSize.height+800;
        self.frame=frame;
    }

    [self juSetScrollInset:10000];

}
/**自动刷新使用*/
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
//    scrollView.contentOffset.y>=(scrollView.contentSize.height-scrollView.frame.size.height)||
    if (scrollView.dragging&&scrollView.contentSize.height>scrollView.frame.size.height) {
        CGRect selfFrame=self.frame;
        selfFrame.origin.y=scrollView.contentSize.height;
        self.frame=selfFrame;
    }
//    内容小于一屏时
    if(scrollView.contentOffset.y>=(scrollView.contentSize.height-scrollView.frame.size.height-80)&&(int)(self.frame.origin.y)!=(int)(scrollView.contentSize.height)){
        [self juSetScrollInset:0];
    }
    if (_isAutoLoad) {
        [self juDidLoadMore];
    }
}
-(void)juSetScrollInset:(CGFloat)estimatedHight{
    
    if (isBusy) return;///< 防止重复执行
    isBusy=YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGRect selfFrame=self.frame;
        UIEdgeInsets insets= scrollView.contentInset;
        CGFloat bottom=LoadFootH;
        
        if (scrollView.contentSize.height<scrollView.frame.size.height) {
            bottom=0;
            selfFrame.origin.y=scrollView.frame.size.height-insets.top;
        }else{
            selfFrame.origin.y=scrollView.contentSize.height;
        }
        selfFrame.origin.y+=estimatedHight;
        self.frame=selfFrame;
        if(isFirstConfig){
            if (insets.bottom!=bottom&&(insets.bottom>=0&&insets.bottom<=44)) {
                insets.bottom=bottom+insets.bottom;
                scrollView.contentInset=insets;
            }
        }
        self.hidden=_isNoDataHide?_isNoDataHide:NO;
        isBusy=NO;
    });
}

/**
 开始加载更多
 */
-(void)juDidLoadMore{
    if (self.ju_LoadMore&&!self.hidden&&scrollView.contentOffset.y>=scrollView.contentSize.height-scrollView.frame.size.height-320&&scrollView.contentOffset.y>0) {
        JuLoadStatus loadStatus=self.ju_LoadStatus;
        if (loadStatus==JuLoadStatusIng||loadStatus==JuLoadStatusFinish) return;
        else {
            [self juLoadMoreStatus:JuLoadStatusIng];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{///< 刷新延迟
                if (loadStatus==JuLoadStatusSuccess) {
                    self.ju_LoadMore(YES);
                }else{
                    return  self.ju_LoadMore(NO);
                }
            });
        }
    }
}
/**上拉动画*/
-(void)juStartLoad:(BOOL)isStart{
    if (isStart) {
        if (self.ju_customImage) {
            [self juRotationAnimation:isStart];
        }else{
            [self.loadingAni startAnimating];
        }
    }else{
        if (self.ju_customImage) {
            [self juRotationAnimation:isStart];
        }else{
            [self.loadingAni stopAnimating];
        }
    }
}
/**自定义下来动画*/
-(void)juRotationAnimation:(BOOL)start{
    if (start) {
        imageView.hidden=NO;
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
        animation.fromValue = [NSNumber numberWithFloat:0.f];
        animation.toValue = [NSNumber numberWithFloat: M_PI *2];
        animation.duration = 0.5;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.repeatCount = MAXFLOAT;
        [imageView.layer addAnimation:animation forKey:@"rotationAnimation"];
    }else{
        [imageView.layer removeAllAnimations];
        imageView.hidden=YES;
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
