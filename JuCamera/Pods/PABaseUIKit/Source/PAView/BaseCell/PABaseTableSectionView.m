//
//  PABaseTableSectionView.m
//  PABase
//
//  Created by Juvid on 2021/4/19.
//

#import "PABaseTableSectionView.h"
#import "NSObject+JuEasy.h"
@implementation PABaseTableSectionView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self zlSetSubViews];
    }
    return self;
}
-(void)zlSetSubViews{}

-(void)zlSetCellContent:(id)content{}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
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
            [tableView registerNib:[UINib nibWithNibName:cellReuseIdentifier bundle:nil] forHeaderFooterViewReuseIdentifier:cellReuseIdentifier];
        }else{
            [tableView registerClass:[self class] forHeaderFooterViewReuseIdentifier:cellReuseIdentifier];
        }
        [tableView.payloadObject addObject:cellReuseIdentifier];
    }
    PABaseTableSectionView *head=[tableView dequeueReusableHeaderFooterViewWithIdentifier:cellReuseIdentifier];
    head.zl_tableView=tableView;
    return head;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
