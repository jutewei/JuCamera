//
//  JuImgMosaicView.h
//  JuPhoto
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/6/29.
//

#import <UIKit/UIKit.h>
#import "PAImgScaleScroll.h"

NS_ASSUME_NONNULL_BEGIN


@interface PAImgMosaicView : UIImageView
//底图为马赛克图
@property (nonatomic, readonly) UIImage *mosaicImage;
//表图为正常图片
@property (nonatomic, strong) UIImage *originalImage;

@property (nonatomic,assign) CGFloat pixelWidth;

@property (nonatomic,assign) CGFloat scale;
@property (nonatomic,copy) JuMosaicStatusHandle statusHandle;
//上一步
-(void)juLastStep;

//重置
-(void)juReset;

//获取马赛克图片
-(UIImage *)juGetResultImage;


@end

NS_ASSUME_NONNULL_END
