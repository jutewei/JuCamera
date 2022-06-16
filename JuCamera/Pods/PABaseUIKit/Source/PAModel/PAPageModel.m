//
//  MTPageModel.m
//  PABase
//
//  Created by Juvid on 16/7/9.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "PAPageModel.h"

@implementation PAPageModel
-(instancetype)init{
    self=[super init];
    if (self) {
        self.zl_isFirstPage=YES;
        self.zl_pageSize=20;
    }
    return self;
}

-(void)setZl_isFirstPage:(BOOL)sh_isFirstPage{
    _zl_isFirstPage=sh_isFirstPage;
    if (_zl_isFirstPage) {
        self.zl_pageNum=1;
    }
}
-(NSInteger)zl_offset{
    return _zl_pageNum*_zl_pageSize;
}
@end

@implementation  NSMutableDictionary (page)

-(void)setValuePage:(PAPageModel *)page{
    [self setValue:@(page.zl_pageSize) forKey:@"pageSize"];
    [self setValue:@(page.zl_pageNum) forKey:@"pageNum"];
}

-(void)setEmptyValue:(BOOL)isEmpty{
    [self setValue:@(isEmpty) forKey:@"emptyData"];
}

@end
