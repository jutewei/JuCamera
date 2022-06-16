//
//  PABaseCollectVC.h
//  PABase
//
//  Created by Juvid on 2021/4/19.
//

#import "PABaseScrollVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface PABaseCollectVC : PABaseScrollVC<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>{
    
    __weak  UICollectionView *zl_collectView;
    UICollectionViewFlowLayout *zl_flowLayout;
    
}

@property (weak, nonatomic  ) IBOutlet UICollectionView      *zl_collectView;

@property (nonatomic        ) BOOL             isTextInput;///< 是否编辑

-(void)zlSetCollectFrame;

-(BOOL)collectviewCellWillHighlight;

-(void)zlInitCollectionLayout;

-(void)zlScrollSection:(NSIndexPath *)indexPath;

-(void)zlReloadAtIndexPath:(NSIndexPath*)indexPath;

@end

NS_ASSUME_NONNULL_END
