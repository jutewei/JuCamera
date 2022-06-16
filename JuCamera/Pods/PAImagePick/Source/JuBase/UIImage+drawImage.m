//
//  UIImage+Color.m
//  PABase
//
//  Created by Juvid on 2017/8/23.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import "UIImage+drawImage.h"

@implementation UIImage (draw)

+ (UIImage *)juImageWithColor:(UIColor *)color{
    return [self juImageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)juImageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(UIImage *)juStretchableImg:(NSString *)imgName leftW:(float)width topH:(float)height{
    UIImage *stretchImg = [[UIImage imageNamed:imgName] stretchableImageWithLeftCapWidth:width  topCapHeight:height];
    return stretchImg;
}

+ (UIImage *)juWaterImageWithImage:(UIImage *)image text:(NSAttributedString *)text textPoint:(CGPoint)point{
    //1.开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //2.绘制图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //添加水印文字
    [text drawAtPoint:point];
    //3.从上下文中获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //4.关闭图形上下文
    UIGraphicsEndImageContext();
    //返回图片
    return newImage;
}

+ (UIImage *)screenView:(UIView *)view {
    if (view == nil)  return nil;

    CGRect rect = view.frame;
//    CGSize size=CGSizeMake(CGRectGetWidth(rect)*Screen_Scale, CGRectGetHeight(rect)*Screen_Scale);
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
/*以下方法暂时未使用*/
static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw, fh;

    if (ovalWidth == 0 || ovalHeight == 0)
    {
        CGContextAddRect(context, rect);
        return;
    }

    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;

    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right

    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+ (UIImage *)createRoundedRectImage:(UIImage*)image withKey:(NSString *)key
{

    //根据key判断是否绘制圆角
    if (key && [key hasPrefix:[NSString stringWithFormat:@"%@",DSRoundImagePreString]]) {

        NSArray *preArray = [key componentsSeparatedByString:[NSString stringWithFormat:@"%@",DSRoundImagePreString]];
        CGSize imageSize;

        if ([preArray count]>2) {  //key里有传宽高信息
            NSString *sizeStr = [preArray objectAtIndex:1];
            NSArray *sizeArray = [sizeStr componentsSeparatedByString:@"x"];
            float width = [[sizeArray objectAtIndex:0] floatValue];
            float height = [[sizeArray objectAtIndex:1] floatValue];
            if (width > 0 && height > 0) {
                if (width>height) {
                    imageSize = CGSizeMake(width*2, width*2);
                }else{
                    imageSize = CGSizeMake(height*2, height*2);
                }
            }else{
                imageSize = CGSizeMake(160, 160);
            }
        }else{

            if (image.size.height > image.size.width) {
                imageSize = CGSizeMake(image.size.height, image.size.height);
            }else{
                imageSize = CGSizeMake(image.size.width, image.size.width);
            }
            if (imageSize.height>160) {
                imageSize = CGSizeMake(160, 160);
            }
        }

        //得到size跟image开始绘制
        int w = imageSize.width;
        int h = imageSize.height;
        int radius = imageSize.width/2;

        UIImage *img = image;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
        CGRect rect = CGRectMake(0, 0, w, h);

        CGContextBeginPath(context);
        addRoundedRectToPath(context, rect, radius, radius);
        CGContextClosePath(context);
        CGContextClip(context);
        CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
        CGImageRef imageMasked = CGBitmapContextCreateImage(context);
        img = [UIImage imageWithCGImage:imageMasked];

        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        CGImageRelease(imageMasked);
        return img;
    }else{
        return image;
    }
}

+ (UIImage *)createRoundedRectImage:(UIImage *)image size:(CGSize)size radius:(int)radius{

    size = CGSizeMake(size.width*2, size.height*2);
    radius = radius*2;

    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 4 * size.width, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);

    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, radius, radius);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];

    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    return img;
}

@end


@implementation UIColor (Image)
-(UIImage *)image{
    return [UIImage juImageWithColor:self size:CGSizeMake(3, 3)];
}
@end
