//
//  UIImage+ORCode.m
//  PABase
//
//  Created by Juvid on 2019/11/26.
//  Copyright © 2019 Juvid. All rights reserved.
//

#import "UIImage+ORCode.h"
#import <CoreImage/CoreImage.h>

@implementation UIImage (ORCode)
#pragma mark 二维码生成strQR为传人字符串
+(UIImage *)juCreatQR:(NSString *)strQR size:(CGFloat)size{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [strQR dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    CIImage *outputImage = [filter outputImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];
    UIImage *image = [UIImage imageWithCGImage:cgImage
                                         scale:1.
                                   orientation:UIImageOrientationUp];
    CGFloat rate=size*[UIScreen mainScreen].scale/image.size.width;
    // Resize without interpolating
    UIImage *resized = [self resizeImage:image
                             withQuality:kCGInterpolationNone
                                    rate:rate];
    CGImageRelease(cgImage);
    return resized;

}
#pragma mark - imagePrivate放大二维码
+ (UIImage *)resizeImage:(UIImage *)image
             withQuality:(CGInterpolationQuality)quality
                    rate:(CGFloat)rate
{
    UIImage *resized = nil;
    CGFloat width = image.size.width * rate;
    CGFloat height = image.size.height * rate;

    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, quality);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    resized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resized;
}



@end
