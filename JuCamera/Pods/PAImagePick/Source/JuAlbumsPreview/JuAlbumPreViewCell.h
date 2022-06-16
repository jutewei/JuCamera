//
//  JuAlbumPreViewCell.h
//  PAImagePick
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/7/19.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface JuAlbumPreViewCell : UICollectionViewCell

@property (nonatomic,copy)dispatch_block_t ju_tapHandle;

-(void)juSetImage:(id)imageData;

-(void)juSetFullImage;
@end

NS_ASSUME_NONNULL_END
