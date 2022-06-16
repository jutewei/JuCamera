//
//  PABaseTableCell.m
//  PABase
//
//  Created by Juvid on 2021/4/19.
//

#import "PABaseTableCell.h"
#import "NSObject+JuEasy.h"
#import "UIView+Frame.h"
@implementation PABaseTableCell

@synthesize zl_indexPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    NSString *strClassName=NSStringFromClass([self class]);
    self = [super initWithStyle:style reuseIdentifier:strClassName];
    if (self) {
        [self zlSetSubViews];
    }
    return self;
}

/**
 无NIB的时候初始化使用
 */
-(void)zlSetSubViews{}

+(instancetype )zlRegisterNib:(UITableView *)tableView {
    return [self zlRegisterCell:tableView isNib:YES];
}

+(instancetype )zlRegisterClass:(UITableView *)tableView{
    return [self zlRegisterCell:tableView isNib:NO];
}

/**注册Cell（包括class和Nib）**/
#pragma mark private method
+(instancetype)zlRegisterCell:(UITableView *)tableView isNib:(BOOL)isNib{
    NSString *cellReuseIdentifier=NSStringFromClass([self class]);
    if (!tableView.payloadObject) tableView.payloadObject=[NSMutableSet set];
    if (![tableView.payloadObject containsObject:cellReuseIdentifier]) {
        if (isNib) {
            [tableView registerNib:[UINib nibWithNibName:cellReuseIdentifier bundle:nil] forCellReuseIdentifier:cellReuseIdentifier];
        }else{
            [tableView registerClass:[self class] forCellReuseIdentifier:cellReuseIdentifier];
        }
        [tableView.payloadObject addObject:cellReuseIdentifier];
    }
    PABaseTableCell *cell=[tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    [cell zlSetTableView:tableView];
    return cell;
}

/**Nib多个cell使用**/
+(instancetype )zlReuseIdentifier:(UITableView *)tableView index:(NSInteger)index{
    static NSString *reuseIdentifier= @"PABaseTableCell";
    PABaseTableCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell==nil) {
        NSArray *arrCell=[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        cell = [arrCell objectAtIndex:index];
        if(!cell.tag) cell.tag=index;
        [cell setClipsToBounds:YES];
        [cell zlSetTableView:tableView];
    }
    return cell;
}

-(void)zlSetTableView:(UITableView *)tableView{
    self.zl_tableView=tableView;
}


-(void)zlSetCellTitle:(id)indexPath{}
//-(void)shSetCellTitle:(id)content indexPath:(NSIndexPath *)indexPath{}

-(void)zlSetCellContent:(id)content{}
-(void)zlSetCellContent:(id)content indexPath:(NSIndexPath *)indexPath{}

#pragma mark 下划线
-(void)zlSetCellLine{
    [self zlSetCellLeft:0.01 right:-50];
}


-(void)zlSetCellLeft:(CGFloat)lead right:(CGFloat)trail{
    if (!_zl_CellLine) {
        JuCellLine *leCellLine=[[JuCellLine alloc]init];
        [self addSubview:leCellLine];
        self.zl_CellLine = leCellLine;
        self.zl_CellLine.juEdgeH(JuEdgeHMake(lead,trail,-0.01,0.5));
    }
}

-(void)setZl_cellSelectColor:(UIColor *)sh_CellSelectColor{
    _zl_cellSelectColor=sh_CellSelectColor;
    self.selectedBackgroundView=[UIView new];
    self.selectedBackgroundView.backgroundColor=_zl_cellSelectColor;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
