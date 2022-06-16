//
//  UIScrollView+JuRefresh.h
//  JuRefresh
//
//  Created by Juvid on 16/9/7.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JuRefreshFoot.h"
#import "JuRefreshHead.h"

typedef NS_ENUM(NSInteger,JuRefreshType) {
    JuRefreshTypeHide,///< 隐藏刷新
    JuRefreshTypeAuto,///< 自动刷新
    JuRefreshTypeHand,///< 手动刷新
    JuRefreshTypeMore,///< 加载更多，并自动刷新
};
@interface UIScrollView (JuRefresh)

@property (nonatomic,strong) JuRefreshHead *ju_RefreshHead;///< 下拉刷新
@property (nonatomic,strong) JuRefreshFoot *ju_RefreshFoot;///< 上拉加载更多


-(void)juStartRefresh;

-(void)zlScrollTop:(BOOL)isDouble;

-(void)juSetRefeshType:(JuRefreshType)refeshType
                  head:(dispatch_block_t)headHandle
                  foot:(JuLoadMoreHandle)footHandle;

-(void)juSetRefeshType:(JuRefreshType)refeshType
              topSpace:(CGFloat)space
                  head:(dispatch_block_t)headHandle
                  foot:(JuLoadMoreHandle)footHandle;
//-(JuLoadPageType)juLoadMorePage;
@end
