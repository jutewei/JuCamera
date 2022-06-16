//
//  JuRefreshBase.h
//  JuRefresh
//
//  Created by Juvid on 16/9/7.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JuRefresh.h"
typedef void(^JuLoadMoreHandle)(BOOL isNextPage);//下步操作后有跟新数据
@interface JuRefreshBase : UIView{
   __weak UIScrollView *scrollView;
//    UIEdgeInsets scrollContentInset;
    BOOL isFirstConfig;
    CGFloat ju_contentInsetTop;///< 原始上边距
    CGFloat ju_contentInsetBottom;///< 原始下边距
    CGFloat ju_RefreshOffsetH;///< 拖动时临界点高度
}

@property(readonly, nonatomic) UIActivityIndicatorView *loadingAni;
@property(readonly, nonatomic) UILabel *labTitle;
@property (nonatomic,copy) NSString *ju_customImage;
- (void)juSetView;

@end
