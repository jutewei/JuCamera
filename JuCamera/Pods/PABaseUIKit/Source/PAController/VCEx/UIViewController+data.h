//
//  UIViewController+data.h
//  JuPublic
//
//  Created by Juvid on 2019/6/21.
//  Copyright © 2019 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JuDataManage.h"
#import "JuDataStatusView.h"
#import "JuDebugConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (data)

@property (nonatomic,strong) JuDataManage  *ju_dataManage;

-(JuDataStatusView *)ju_vieStatus;

//-(PAPageModel *)ju_pageSize;
/**默认值初始化**/
-(void)juSetDataHint:(BOOL)isNoData;

-(UIView *)ju_statusSupview;

-(void)juAddStatusView:(JuDataStatusHandle)handle status:(JUDataLoadStatus)status ;


-(void)setStatusFrame:(CGRect)frame;


@end

NS_ASSUME_NONNULL_END
