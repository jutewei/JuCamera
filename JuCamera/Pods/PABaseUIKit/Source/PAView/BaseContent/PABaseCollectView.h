//
//  PABaseCollectView.h
//  PABase
//
//  Created by Juvid on 2021/4/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^zlHeightHandle)(CGFloat height);             //下步操作后有跟新数据

@interface PABaseCollectView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    CGFloat zl_contentHeight;
    UICollectionViewFlowLayout *zl_flowLayout;
    NSIndexPath *zl_selectIndexPath;
}
@property (nonatomic,copy  ) zlHeightHandle zl_heightHandle;
@property (nonatomic,assign  ) CGFloat zl_miniHeight;
-(UICollectionViewFlowLayout *)zlLayout;
-(void)zlSetCollentView;
@property (nonatomic,strong) NSMutableArray *zl_mArrList;
@end

NS_ASSUME_NONNULL_END
