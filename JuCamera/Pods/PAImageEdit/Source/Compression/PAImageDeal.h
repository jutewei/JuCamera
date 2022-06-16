//
//  PAImageDeal.h
//  PAImageEdit
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/7/22.
//

#import <UIKit/UIKit.h>
#import "UIImage+deal.h"
#import "UIImage+watermark.h"
#import "PAImageDealModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PAImageDeal : NSObject

+(NSDictionary *)zlSetImageModel:(PAImageDealModel *)imageM;

+(NSData *)zlCompressImage:(PAImageDealModel *)imageM;

+(UIImage *)zlSetImageData:(id)imageData
                      type:(PAImageCompressType)type
                  sideSize:(CGFloat)sideSize
                   quality:(CGFloat)quality;

+(NSData *)zlGetImageData:(id)imageData
                      type:(PAImageCompressType)type
                  sideSize:(CGFloat)sideSize
                   quality:(CGFloat)quality;

@end

NS_ASSUME_NONNULL_END
