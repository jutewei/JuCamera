//
//  UIScrollView+JuRefresh.m
//  JuRefresh
//
//  Created by Juvid on 16/9/7.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "UIScrollView+JuRefresh.h"
#import <objc/runtime.h>

static const char* juLoadMore="load_more";;
@implementation UIScrollView (JuRefresh)

-(void)setJu_RefreshFoot:(JuRefreshFoot *)ju_RefreshFoot{
    if (ju_RefreshFoot!=self.ju_RefreshFoot) {
        if (self.ju_RefreshFoot) {
            [self.ju_RefreshFoot removeFromSuperview];
        }
        if (ju_RefreshFoot)[self insertSubview:ju_RefreshFoot atIndex:0];
        objc_setAssociatedObject(self, &juLoadMore, ju_RefreshFoot,OBJC_ASSOCIATION_ASSIGN);
    }

}

-(JuRefreshFoot *)ju_RefreshFoot{
    return objc_getAssociatedObject(self, &juLoadMore);
}

-(void)setJu_RefreshHead:(JuRefreshHead *)ju_RefreshHead{
    if (ju_RefreshHead!=self.ju_RefreshHead) {
        if (self.ju_RefreshHead) {
            [self.ju_RefreshHead removeFromSuperview];
        }
        if (ju_RefreshHead)[self insertSubview:ju_RefreshHead atIndex:0];
        objc_setAssociatedObject(self, @selector(ju_RefreshHead), ju_RefreshHead,OBJC_ASSOCIATION_ASSIGN);
    }
}

-(JuRefreshHead *)ju_RefreshHead{
    return objc_getAssociatedObject(self, @selector(ju_RefreshHead));
}

-(void)juStartRefresh{
    self.ju_RefreshHead.hidden=NO;
    [self.ju_RefreshHead juStartRefresh];
}

-(void)juSetRefeshType:(JuRefreshType)refeshType
                  head:(dispatch_block_t)headHandle
                  foot:(JuLoadMoreHandle)footHandle{
    
    [self juSetRefeshType:refeshType topSpace:0 head:headHandle foot:footHandle];
}
-(void)juSetRefeshType:(JuRefreshType)refeshType
              topSpace:(CGFloat)space
                  head:(dispatch_block_t)headHandle
                  foot:(JuLoadMoreHandle)footHandle{
    if (refeshType==JuRefreshTypeHide) {
        [self.ju_RefreshHead juEndRefresh];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.ju_RefreshHead.hidden=YES;
        });
        if (self.ju_RefreshFoot) self.ju_RefreshFoot.hidden=YES;
    }else{
        /// 下拉刷新初始化
        if (!self.ju_RefreshHead) {
            self.ju_RefreshHead=[JuRefreshHead juHeadWithhandle:headHandle];
            self.ju_RefreshHead.ju_topSpace=space;
//            zl_scrollView.ju_RefreshHead.ju_customImage=@"loading_small";
        }
        ///<  上拉加载更多初始化
        if (refeshType==JuRefreshTypeMore&&!self.ju_RefreshFoot) {
            self.ju_RefreshFoot=[JuRefreshFoot juFootWithhandle:footHandle];
            self.ju_RefreshFoot.isAutoLoad=YES;
        }
    }
    if (refeshType==JuRefreshTypeAuto||refeshType==JuRefreshTypeMore) {
        [self juStartRefresh];
    }
}
-(void)zlScrollTop:(BOOL)isDouble{
    CGFloat insetsTpo=-self.contentInset.top;
    if (@available(iOS 11.0, *)) {
        insetsTpo=-self.adjustedContentInset.top;
    }
    if (isDouble) {
        [self setContentOffset:CGPointMake(0, insetsTpo)];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.025 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self juStartRefresh];
        });
    }else{
         [self setContentOffset:CGPointMake(0, insetsTpo) animated:YES];
    }
}


//-(JuLoadPageType)juLoadMorePage{
//    if (self.ju_RefreshFoot&&!self.ju_RefreshFoot.hidden&&self.contentOffset.y>=self.contentSize.height-self.frame.size.height&&self.contentOffset.y>0) {
//        if (self.ju_RefreshFoot.ju_LoadStatus==JuLoadStatusIng||self.ju_RefreshFoot.ju_LoadStatus==JuLoadStatusFinish) return JuLoadPageNone;
//        else {
//
//            if (self.ju_RefreshFoot.ju_LoadStatus==JuLoadStatusSuccess) {
//                return JuLoadPageNext;
//            }else{
//                return JuLoadPageCurrent;
//            }
//
//        }
//    }
//    return JuLoadPageNone;
//}
@end
