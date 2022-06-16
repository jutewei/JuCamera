//
//  JuDataManage.h
//  PABase
//
//  Created by Juvid on 2019/12/9.
//  Copyright © 2019 Juvid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JuDataStatusView.h"
#import "PAPageModel.h"
#import "JuBaseConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface JuDataManage : NSObject

@property (nonatomic ,assign)JUShowHintType  zl_showFailHint;
@property (nonatomic ,assign)JUShowHintType  zl_showNoDataHint;

@property (nonatomic ,strong)NSString * _Nullable zl_noDataText;
@property (nonatomic ,strong)NSString * _Nullable zl_failText;

@property (nonatomic ,strong)NSString * _Nullable zl_imageName;
@property (nonatomic ,strong)NSString * _Nullable zl_actName;

@property (nonatomic,strong) JuDataStatusView *_Nullable zl_vieStatus;
@property (nonatomic,strong) UIView *_Nullable zl_statusSupview;

//@property (nonatomic,strong) PAPageModel        *zl_pageSize;   ///< 分页
+(JuDataManage *)zlSowMessage:(NSString *)message;
-(void)zlSetDataHint:(BOOL)isNoData;
-(void)zlShowErrorStatus:(JUDataLoadStatus)status;
@end

NS_ASSUME_NONNULL_END
