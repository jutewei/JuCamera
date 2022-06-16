//
//  JuAlbumPreFootView.h
//  PAImagePick
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/7/15.
//

#import <UIKit/UIKit.h>
#import "JuPhotoConfig.h"
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface JuAlbumPreToolBar : UIView

@property(nonatomic,strong) NSArray *ju_arrImage;

@property (nonatomic,assign)NSInteger ju_currentIndex;

@property (nonatomic,copy)JuHandleIndex ju_hanlleIndex;

@property (nonatomic,copy)dispatch_block_t ju_hanlleDone;

-(void)setDoneCount:(NSInteger)count;

-(void)setHide:(BOOL)hide;

@end




@interface JuAlbumSelectCell : UICollectionViewCell

-(void)setCurrentIndex:(BOOL)isSelect;

-(void)setCellContent:(PHAsset *)ju_asset;

@end

NS_ASSUME_NONNULL_END
