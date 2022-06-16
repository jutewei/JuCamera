//
//  UIViewController+dataStatus.m
//  PABase
//
//  Created by Juvid on 2019/6/21.
//  Copyright © 2019 Juvid. All rights reserved.
//

#import "UIViewController+data.h"
#import <objc/runtime.h>
#import "UIView+Frame.h"

@implementation UIViewController (data)

-(void)setJu_dataManage:(JuDataManage *)ju_dataManage{
    objc_setAssociatedObject(self, @selector(ju_dataManage), ju_dataManage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(JuDataManage *)ju_dataManage{
    if (!objc_getAssociatedObject(self, @selector(ju_dataManage))) {
        self.ju_dataManage=[JuDataManage zlSowMessage:@"暂无数据"];
    }
    return objc_getAssociatedObject(self, @selector(ju_dataManage));
}

-(void)setStatusFrame:(CGRect)statusFrame{
    self.ju_dataManage.zl_statusSupview=[[UIView alloc]initWithFrame:statusFrame];
}

-(JuDataStatusView *)ju_vieStatus{
    return self.ju_dataManage.zl_vieStatus;
}

-(UIView *)ju_statusSupview{
    return self.ju_dataManage.zl_statusSupview;
}

//-(PAPageModel *)ju_pageSize{
//    return self.ju_dataManage.zl_pageSize;
//}

/**默认值初始化有下拉加载或者上拉更多才初始化**/
-(void)juSetDataHint:(BOOL)isNoData{
    [self.ju_dataManage zlSetDataHint:isNoData];
}

-(void)juAddStatusView:(JuDataStatusHandle)handle status:(JUDataLoadStatus)status{
    if (status) {
        if (!self.ju_vieStatus) {
            self.ju_dataManage.zl_vieStatus=[JuDataStatusView initView];
        }
        WeakSelf
        self.ju_vieStatus.ju_touchHandle = ^(NSInteger type) {
            if (type==0) {
                [weakSelf.ju_vieStatus removeFromSuperview];
                weakSelf.ju_dataManage.zl_vieStatus=nil;
            }
            if (handle) {
                handle(type);
            }
        };
        [self.ju_vieStatus removeFromSuperview];
        [self.ju_vieStatus juRemoveAllConstraints];
        if (self.ju_statusSupview) {
            [self.ju_statusSupview addSubview:self.ju_vieStatus];
        }else{
            [self.view addSubview:self.ju_vieStatus];
        }
        self.ju_vieStatus.juEdge(UIEdgeInsetsMake(0, 0, 0, 0));
    }
    self.ju_vieStatus.hidden=(status==JUDataLoadStatusNormal);
    [self.ju_dataManage zlShowErrorStatus:status];
}


@end
