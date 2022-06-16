//
//  MTCreatRequestModel.h
//  PABase
//
//  Created by Juvid on 2017/7/27.
//  Copyright © 2017年 Juvid(zhutianwei). All rights reserved.
//

#import "PABaseModel.h"
#import "JuFileManage.h"

@interface PARequestModel : PABaseModel
@property (nonatomic,assign) NSInteger zl_type;     ///< 数据来源 0选择 1输入
@property (nonatomic,assign) NSInteger zl_lenght;     ///< 输入长度
@property (nonatomic,strong) NSString *zl_title;    ///< 标题
@property (nonatomic,strong) NSString *zl_key;       ///< 标题
//@property (nonatomic,strong) NSString *zl_image;    ///< 标题
@property (nonatomic,strong) NSString *zl_placeholder; ///< 标题
@property (nonatomic,strong) NSString *zl_pickKey;
@property (nonatomic,assign) NSInteger zl_canEmpty;    ///< 是否为空 0不可为空 1不可为空
@property (nonatomic,assign) NSInteger zl_nibNum;    ///< nib 索引
@property (nonatomic,strong) id zl_postVaule;           ///<  上传的参数值
@property (nonatomic,strong) id zl_showVaule;           ///<   显示的参数值

+(NSMutableArray *)zlRowPlistResource:(NSString *)fileName;

+(NSMutableArray *)zlSectionPlistResource:(NSString *)fileName;

-(void)setPostValue:(id)value;

-(void)setPostValue:(id)postValue showValue:(id)showValue;

+(PARequestModel *)zlInitTitle:(NSString *)title;

+(NSMutableDictionary *)zlGetRequestPara:(NSArray *)arrlist;

+(BOOL)zlCheckEmpty:(NSArray *)list;
@end
