//
//  MTPageModel.h
//  PABase
//
//  Created by Juvid on 16/7/9.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "PABaseModel.h"

@interface PAPageModel : PABaseModel
@property (nonatomic,assign) NSInteger zl_pageSize;///< 页容量
@property (nonatomic,assign) NSInteger zl_offset;///< sh_limit*sh_index
@property (nonatomic,assign) NSInteger zl_pageNum;///< 页索引
@property (nonatomic,assign) BOOL zl_isFirstPage;///< 是否第一页
@end


@interface NSMutableDictionary (page)

-(void)setValuePage:(PAPageModel *)page;

-(void)setEmptyValue:(BOOL)isEmpty;

@end
