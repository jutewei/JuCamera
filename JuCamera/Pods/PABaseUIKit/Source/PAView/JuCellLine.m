//
//  LEViewLine.m
//  XYLEPlay
//
//  Created by Juvid on 15/6/15.
//  Copyright (c) 2015年 Juvid(zhutianwei). All rights reserved.
//

#import "JuCellLine.h"


@implementation PFBGrayLine
-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor= JUColor_Separator ;
    
}
-(instancetype)init{
    self=[super init];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}
@end

@implementation JuCellLine

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor=JUColor_Separator;
    
}
-(instancetype)init{
    self=[super init];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}
@end

//@implementation LEBackLine
//-(void)awakeFromNib{
//    [super awakeFromNib];
//    self.backgroundColor=PAColor_Background;
//    
//}
//-(instancetype)init{
//    self=[super init];
//    if (self) {
//        [self awakeFromNib];
//    }
//    return self;
//}
//
//
//
//@end


