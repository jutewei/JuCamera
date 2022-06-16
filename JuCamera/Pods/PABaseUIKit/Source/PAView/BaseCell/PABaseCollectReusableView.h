//
//  PABaseReusableView.h
//  PABase
//
//  Created by Juvid on 2021/4/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PABaseLayerReusableView : UICollectionReusableView

@end

@interface PABaseCollectReusableView : UICollectionReusableView
@property (nonatomic,weak) UICollectionView *zl_collectView;
@property (nonatomic,weak) NSIndexPath *zl_indexPath;
+(instancetype )zlRegisterNib:(UICollectionView *)collectView forIndexPath:(NSIndexPath *)indexPath isHeader:(BOOL)isHead;
+(instancetype )zlRegisterClass:(UICollectionView *)collectView forIndexPath:(NSIndexPath *)indexPath isHeader:(BOOL)isHead;

-(void)zlSetSubViews;
-(void)zlSetViewContent:(id)content;

@end


@interface PABaseCollectHeadView : PABaseCollectReusableView
+(instancetype )zlRegisterNib:(UICollectionView *)collectView forIndexPath:(NSIndexPath *)indexPath;
+(instancetype )zlRegisterClass:(UICollectionView *)collectView forIndexPath:(NSIndexPath *)indexPath;
@end


@interface PABaseCollectFootView : PABaseCollectReusableView
+(instancetype )zlRegisterNib:(UICollectionView *)collectView forIndexPath:(NSIndexPath *)indexPath;
+(instancetype )zlRegisterClass:(UICollectionView *)collectView forIndexPath:(NSIndexPath *)indexPath;
@end


NS_ASSUME_NONNULL_END
