//
//  PAMosaicZoomScroll.h
//  PAImageEdit
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/7/9.
//

#import "PAImgScaleScroll.h"
#import "PAImgMosaicView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PAMosaicZoomScroll:PAImgScaleScroll

-(PAImgMosaicView *)mosaicView;

-(instancetype)initWithImage:(UIImage *)image
                      handle:(JuImageResult)handle;

@property (nonatomic,copy) JuMosaicStatusHandle statusHandle;

-(void)setIsHiddeEdit:(BOOL)isShow;
@end
@interface PAMosaicSizeButton : UIButton
-(void)setRadius:(CGFloat)radius;
-(void)setIsSelect;
@end

NS_ASSUME_NONNULL_END
