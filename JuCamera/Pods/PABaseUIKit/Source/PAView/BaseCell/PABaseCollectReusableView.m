//
//  PABaseReusableView.m
//  PABase
//
//  Created by Juvid on 2021/4/19.
//

#import "PABaseCollectReusableView.h"
#import "UIView+Frame.h"
#import "NSObject+JuEasy.h"
#ifdef __IPHONE_11_0
@interface CustomLayer : CALayer

@end
#endif
#ifdef __IPHONE_11_0
@implementation CustomLayer

- (CGFloat) zPosition {
    return 0;
}

@end
#endif


@implementation PABaseLayerReusableView

@end


@implementation PABaseCollectReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self zlSetSubViews];
    }
    return self;
}
-(void)zlSetSubViews{}

+(instancetype )zlRegisterNib:(UICollectionView *)collectView forIndexPath:(NSIndexPath *)indexPath isHeader:(BOOL)isHead{
    return [self zlRegisterCell:collectView isNib:YES forIndexPath:indexPath isHeader:isHead];
}
+(instancetype )zlRegisterClass:(UICollectionView *)collectView forIndexPath:(NSIndexPath *)indexPath isHeader:(BOOL)isHead{
    return [self zlRegisterCell:collectView isNib:NO forIndexPath:indexPath isHeader:isHead];
}
/**注册Cell（包括class和Nib）**/
#pragma mark private method
+(instancetype)zlRegisterCell:(UICollectionView *)collectView isNib:(BOOL)isNib forIndexPath:(NSIndexPath *)indexPath isHeader:(BOOL)ishead{
    NSString *cellReuseIdentifier=NSStringFromClass([self class]);
    NSString *collectionElementKind=ishead?UICollectionElementKindSectionHeader:UICollectionElementKindSectionFooter;
    if (!collectView.payloadObject) collectView.payloadObject=[NSMutableSet set];
    if (![collectView.payloadObject containsObject:cellReuseIdentifier]) {
        if (isNib) {
            [collectView registerNib:[UINib nibWithNibName:cellReuseIdentifier bundle:nil] forSupplementaryViewOfKind:collectionElementKind withReuseIdentifier:cellReuseIdentifier];
        }else{
            [collectView registerClass:[self class]  forSupplementaryViewOfKind:collectionElementKind withReuseIdentifier:cellReuseIdentifier];
        }
        [collectView.payloadObject addObject:cellReuseIdentifier];
    }
    PABaseCollectReusableView *reusableView = [collectView dequeueReusableSupplementaryViewOfKind:ishead?UICollectionElementKindSectionHeader:UICollectionElementKindSectionFooter withReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    reusableView.zl_collectView=collectView;
    reusableView.zl_indexPath=indexPath;
    return reusableView;
}
-(void)zlSetViewContent:(id)content{}
#ifdef __IPHONE_11_0
+ (Class)layerClass {
    return [CustomLayer class];
}
#endif

@end


@implementation PABaseCollectHeadView
+(instancetype )zlRegisterNib:(UICollectionView *)collectView forIndexPath:(NSIndexPath *)indexPath{
    return [self zlRegisterNib:collectView forIndexPath:indexPath isHeader:YES];
}
+(instancetype )zlRegisterClass:(UICollectionView *)collectView forIndexPath:(NSIndexPath *)indexPath{
    return [self zlRegisterClass:collectView forIndexPath:indexPath isHeader:YES];
}
@end


@implementation PABaseCollectFootView
+(instancetype )zlRegisterNib:(UICollectionView *)collectView forIndexPath:(NSIndexPath *)indexPath{
    return [self zlRegisterNib:collectView forIndexPath:indexPath isHeader:NO];
}
+(instancetype )zlRegisterClass:(UICollectionView *)collectView forIndexPath:(NSIndexPath *)indexPath{
    return [self zlRegisterClass:collectView forIndexPath:indexPath isHeader:NO];
}
@end
