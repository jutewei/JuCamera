//
//  UIImage+watermark.h
//  PAImageEdit
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/7/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (watermark)

-(UIImage *)juWaterWithImage:(UIImage *)image;

//加水印
-(UIImage *)zlWaterWithTexts:(NSArray *)texts;

//加水印
-(UIImage *)zlWaterWithText:(NSAttributedString *)attribute
                      point:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
