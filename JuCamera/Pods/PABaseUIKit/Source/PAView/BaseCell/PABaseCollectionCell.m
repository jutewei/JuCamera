//
//  PABaseCollectionCell.m
//  PABase
//
//  Created by Juvid on 2021/4/19.
//

#import "PABaseCollectionCell.h"
#import "NSObject+JuEasy.h"

@implementation PABaseCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=JUColor_ContentWhite;
        [self zlSetSubViews];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor=JUColor_ContentWhite;
}
/**
 无NIB的时候初始化使用
 */
-(void)zlSetSubViews{}

-(void)zlSetCellContent:(id)content{}

+(instancetype )zlRegisterNib:(UICollectionView *)collectView forIndexPath:(NSIndexPath *)indexPath{
    return [self zlRegisterCell:collectView isNib:YES forIndexPath:indexPath];
}

+(instancetype )zlRegisterClass:(UICollectionView *)collectView forIndexPath:(NSIndexPath *)indexPath{
    return [self zlRegisterCell:collectView isNib:NO forIndexPath:indexPath];
}
/**注册Cell（包括class和Nib）**/
#pragma mark private method
+(instancetype)zlRegisterCell:(UICollectionView *)collectView isNib:(BOOL)isNib forIndexPath:(NSIndexPath *)indexPath{
    NSString *cellReuseIdentifier=NSStringFromClass([self class]);
    if (!collectView.payloadObject) collectView.payloadObject=[NSMutableSet set];
    if (![collectView.payloadObject containsObject:cellReuseIdentifier]) {
        if (isNib) {
            [collectView registerNib:[UINib nibWithNibName:cellReuseIdentifier bundle:nil]  forCellWithReuseIdentifier:cellReuseIdentifier];
        }else{
            [collectView registerClass:[self class] forCellWithReuseIdentifier:cellReuseIdentifier];
        }
        [collectView.payloadObject addObject:cellReuseIdentifier];
    }
    
    PABaseCollectionCell *cell=[collectView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    cell.zl_indexPath=indexPath;
    cell.zl_collectView=collectView;
    cell.contentView.backgroundColor=JUColor_ContentWhite;
    return cell;
}

+(NSIndexPath *)zlIndexPathForView:(UICollectionView *)collectView subView:(UIView *)subView{
    UIView *supView=subView.superview;
    while (![supView isKindOfClass:[UICollectionViewCell class]]) {
        supView=supView.superview;
    }
    NSIndexPath * path = [collectView indexPathForCell:(UICollectionViewCell *)supView];
    return path;
}
@end
