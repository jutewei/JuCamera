//
//  PABaseCollectionCell.h
//  PABase
//
//  Created by Juvid on 2021/4/19.
//

#import <UIKit/UIKit.h>
#import "JuSystemDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface PABaseCollectionCell : UICollectionViewCell

@property (nonatomic,weak) UICollectionView *zl_collectView;
@property (nonatomic,copy) JuResultHandle   zl_handleResult;

@property (nonatomic,weak) NSIndexPath *zl_indexPath;

+(instancetype )zlRegisterNib:(UICollectionView *)collectView forIndexPath:(NSIndexPath *)indexPath;

+(instancetype )zlRegisterClass:(UICollectionView *)collectView forIndexPath:(NSIndexPath *)indexPath;
/**
 无NIB的时候初始化使用
 */
-(void)zlSetSubViews;

/**
 设置内容

 @param content 内容
 */
-(void)zlSetCellContent:(id)content;

+(NSIndexPath *)zlIndexPathForView:(UICollectionView *)collectView subView:(UIView *)subView;
@end

NS_ASSUME_NONNULL_END
