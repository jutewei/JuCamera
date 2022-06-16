//
//  JuPlayerAlbumItem.h
//  PAImagePick
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2022/3/31.
//

#import <UIKit/UIKit.h>
#import "JuPhotoConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface JuPlayerAlbumCell : UICollectionViewCell

@property (nonatomic,copy)JuTouchHider ju_tapHandle;

-(void)juSetImage:(id)imageData;

-(BOOL)juReSetPlay;

@end


NS_ASSUME_NONNULL_END
