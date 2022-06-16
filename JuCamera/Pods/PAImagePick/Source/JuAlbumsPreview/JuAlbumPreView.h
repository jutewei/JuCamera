//
//  JuAlbumPreView.h
//  PAImagePick
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/7/19.
//

#import <UIKit/UIKit.h>
#import "JuPhotoConfig.h"
#import "JuScaleCollectView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JuAlbumPreView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>


@property (nonatomic,readonly)JuScaleCollectView *ju_collectView;

@property (nonatomic,assign)  NSInteger  ju_currentIndex;
@property (nonatomic,assign)  NSInteger  ju_allowVideo;

/**
 设置图片

 @param arrList arrlist可为string、JuImageObject、PHAsset、ALAsset
 @param index 当前第几张
 @param frame 小图坐标
 */
-(void)juSetImages:(NSArray *)arrList
            cIndex:(NSInteger)index
            handle:(JuHandleIndex)handelIndex;


@property (nonatomic,copy) JuTouchHider ju_tapHandle;

@end

NS_ASSUME_NONNULL_END
