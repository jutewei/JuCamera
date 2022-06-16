//
//  UIImage+ORCode.h
//  PABase
//
//  Created by Juvid on 2019/11/26.
//  Copyright © 2019 Juvid. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ORCode)
+(UIImage *)juCreatQR:(NSString *)strQR size:(CGFloat)rate;
@end

NS_ASSUME_NONNULL_END
