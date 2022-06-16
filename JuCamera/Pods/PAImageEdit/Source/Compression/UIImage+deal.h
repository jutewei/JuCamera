//
//  UIImage+deal.h
//  TestImage
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/5/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (deal)

/**裁剪略缩图*/
-(UIImage*)zlSetThumbnail;

/**以最小边压缩**/
-(UIImage *)zlSetMinSide :(CGFloat)newSize;

/**以最大边压缩*/
-(UIImage *)zlSetMaxSide :(CGFloat)minSize;

//按指定尺寸压缩
-(UIImage *)zlFixImage :(CGSize)fixSize;

//图片裁剪（指定区域裁剪）
- (UIImage *)zlImageFromInRect:(CGRect)rect original:(CGSize)oSize;

- (UIImage *)zlImageFromInRect:(CGRect)cropRect;

-(CGFloat)imageLenght;
@end

NS_ASSUME_NONNULL_END
