//
//  PABaseTableView.m
//  PABase
//
//  Created by Juvid on 2021/4/20.
//

#import "PABaseTableView.h"

@implementation PABaseTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self=[super initWithFrame:frame style:style];{
        [self zlConfig];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)coder{
    self=[super initWithCoder:coder];
    if (self) {
        [self zlConfig];
    }
    return self;
}
//-(void)awakeFromNib{
//    [super awakeFromNib];
//    [self zlConfig];
//}
+(id)zlInitTableWithStyle:(UITableViewStyle )style{
    PABaseTableView *table=[[PABaseTableView alloc]initWithFrame:CGRectZero style:style];
    return table;
}
-(void)zlConfig{
  self.rowHeight=50;
  self.estimatedSectionFooterHeight=0;
  self.estimatedRowHeight=0;
  self.estimatedSectionHeaderHeight=0;
  self.backgroundColor=PAColor_Background;
  self.separatorColor=JUColor_Separator;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
