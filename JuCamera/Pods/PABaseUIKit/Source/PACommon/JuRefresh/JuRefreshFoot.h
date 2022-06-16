//
//  JuLoadMore.h
//  JuRefresh
//
//  Created by Juvid on 16/9/7.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JuRefreshBase.h"
typedef void(^JuLoadMoreHandle)(BOOL isNextPage);//下拉回调
typedef NS_ENUM(NSInteger,JuLoadStatus) {
    JuLoadStatusIng,
    JuLoadStatusSuccess,
    JuLoadStatusFailure,
    JuLoadStatusFinish,

};
@interface JuRefreshFoot : JuRefreshBase

+(instancetype)juFootWithhandle:(JuLoadMoreHandle)handle;
@property (nonatomic,assign) JuLoadStatus ju_LoadStatus;

@property BOOL isAutoLoad;      ///< 是否加载更多，内部触发上拉加载
@property BOOL isNoDataHide;    ///< 没有任何数据隐藏
-(void)juDidLoadMore;
-(void)juLoadMoreStatus:(JuLoadStatus)status;
@end
