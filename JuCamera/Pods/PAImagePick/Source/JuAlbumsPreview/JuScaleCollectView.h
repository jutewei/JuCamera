//
//  JuScaleCollectView.h
//  PAImagePick
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/7/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JuScaleCollectView : UICollectionView

+(instancetype)juInitWithView:(UIView *)supView;

-(void)juSetOffsetIndex:(NSInteger)index;

-(CGSize)juGetItemSize:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
