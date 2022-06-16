//
//  UIImage+MUCommon.h
//  BigCalculat
//
//  Created by Juvid on 16/10/27.
//  Copyright © 2016年 Juvid . All rights reserved.
//
//

#import "UIImage+category.h"
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@implementation UIImage (category)

#pragma mark - 修正图片旋转
-(UIImage *_Nonnull)juFixOrientation{
    if (self.imageOrientation == UIImageOrientationUp)
        return self;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

-(UIImage*)juRotatingOrientation{
    //No-op if the orientation is already correct
    UIImage *image=[self juFixOrientation];

    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;

    //CGAffineTransform transform = CGAffineTransformIdentity;
    switch (self.imageOrientation) {
        case UIImageOrientationUp:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, self.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;

        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, self.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }

    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);

    CGContextScaleCTM(context, scaleX, scaleY);

    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    UIImage*newPic = UIGraphicsGetImageFromCurrentImageContext();
    return newPic;
}

//马赛克图层
-(UIImage *)juMosaicLevel:(NSUInteger)level{
    
    //1、这一部分是为了把原始图片转成位图，位图再转成可操作的数据
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();//颜色通道
    CGImageRef imageRef = self.CGImage;//位图
    CGFloat width = CGImageGetWidth(imageRef);//位图宽
    CGFloat height = CGImageGetHeight(imageRef);//位图高
    CGContextRef context = CGBitmapContextCreate(nil, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast);//生成上下文
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), imageRef);//绘制图片到上下文中
    unsigned char *bitmapData = CGBitmapContextGetData(context);//获取位图的数据
    
    //2、这一部分是往右往下填充色值
    NSUInteger sizeLevel = level == 0?MIN(width,height)/40.0: MIN(width,height)/level;

    NSUInteger index,preIndex;
    unsigned char pixel[4] = {0};
    for (int i = 0; i < height; i++) {//表示高，也可以说是行
        for (int j = 0; j < width; j++) {//表示宽，也可以说是列
            index = i * width + j;
            if (i % sizeLevel == 0) {
                if (j % sizeLevel == 0) {
                    //把当前的色值数据保存一份，开始为i=0，j=0，所以一开始会保留一份
                    memcpy(pixel, bitmapData + index * 4, 4);
                }else{
                    //把上一次保留的色值数据填充到当前的内存区域，这样就起到把前面数据往后挪的作用，也是往右填充
                    memcpy(bitmapData +index * 4, pixel, 4);
                }
            }else{
                //这里是把上一行的往下填充
                preIndex = (i - 1) * width + j;
                memcpy(bitmapData + index * 4, bitmapData + preIndex * 4, 4);
            }
        }
    }
    
    //把数据转回位图，再从位图转回UIImage
    NSUInteger dataLength = width * height * 4;
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, bitmapData, dataLength, NULL);
    
    CGImageRef mosaicImageRef = CGImageCreate(width, height,8,32,width*4 ,colorSpace,kCGBitmapByteOrderDefault,provider,NULL, NO,kCGRenderingIntentDefault);
    CGContextRef outputContext = CGBitmapContextCreate(nil, width, height,8, width*4,colorSpace,kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(outputContext, CGRectMake(0.0f, 0.0f, width, height), mosaicImageRef);
    CGImageRef resultImageRef = CGBitmapContextCreateImage(outputContext);
    UIImage *resultImage = nil;
    if([UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)]) {
        float scale = [[UIScreen mainScreen] scale];
        resultImage = [UIImage imageWithCGImage:resultImageRef scale:scale orientation:UIImageOrientationUp];
    } else {
        resultImage = [UIImage imageWithCGImage:resultImageRef];
    }
    CFRelease(resultImageRef);
    CFRelease(mosaicImageRef);
    CFRelease(colorSpace);
    CFRelease(provider);
    CFRelease(context);
    CFRelease(outputContext);
    return resultImage;
}


@end


@implementation UIImageView (category)

- (void)juRotationView {
    self.image= [self.image juFixOrientation];
//    //在本例子中,图片的最大高度设置为500,最大宽度为屏幕宽度,当然自己也可以根据自己的需要去调整自己的图片框的大小
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformRotate(self.transform, M_PI_2);
        if (self.frame.size.width >= self.juWindowWidth) { //过长
            //计算比例系数
            CGFloat kSacale = self.juWindowWidth /self.frame.size.width;
            //大小缩放
            self.transform = CGAffineTransformScale(self.transform,kSacale, kSacale);
        }else{
            //判断当宽度缩放到屏幕宽度之后,高度与500哪一个更大
            CGFloat kSacale = self.juWindowWidth / self.frame.size.width;
            self.transform = CGAffineTransformScale(self.transform,kSacale, kSacale);
        }
    }];
}

- (UIImage *)juSaveRotationResult {
    //使用绘制的方法得到旋转之后的图片
    double rotationZ = [[self.layer valueForKeyPath:@"transform.rotation.z"] doubleValue];
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.image.size.width, self.image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(rotationZ);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    UIGraphicsBeginImageContextWithOptions(rotatedSize, NO, self.image.scale);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap,rotationZ);
    CGContextScaleCTM(bitmap, 1, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.image.size.width / 2, -self.image.size.height / 2, self.image.size.width, self.image.size.height), [self.image CGImage]);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //把最终的图片存到相册看看是否成功
//    UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil);
    return newImage;
}

//设置图片展开
- (CGRect) juSetImage:(UIImage *)image{
    CGRect ju_originRect=CGRectZero;
    if (image){
        self.image=image;
        CGSize imgSize = image.size;
        //判断首先缩放的值
        float scaleX = self.juWindowWidth/imgSize.width;
        float scaleY = self.juWindowHeight/imgSize.height;
        //倍数小的，先到边缘
        if (scaleX > scaleY){
            //Y方向先到边缘
            float imgViewWidth = imgSize.width*scaleY;
            ju_originRect = (CGRect){self.juWindowWidth/2-imgViewWidth/2,0,imgViewWidth,self.juWindowHeight};
        }
        else{
            //X先到边缘
            float imgViewHeight = imgSize.height*scaleX;
            ju_originRect = (CGRect){0,self.juWindowHeight/2-imgViewHeight/2+self.juSafeBottom,self.juWindowWidth,imgViewHeight};
        }
    }
    return ju_originRect;
}
-(CGFloat)juSafeBottom{
    return 0;
}
-(CGFloat)juWindowWidth{
    return [UIScreen mainScreen].bounds.size.width;
}
-(CGFloat)juWindowHeight{
    return [UIScreen mainScreen].bounds.size.height-self.juSafeBottom*2;
}

-(UIImage *)getImage{
    CGSize size = self.image.size;
    UIImage *finalPath = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIGraphicsBeginImageContextWithOptions(size, YES, 1.0);
    [self.image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    [finalPath drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *lastImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return lastImage;
}

@end

@implementation UIScrollView (category)

//获取Scrollview截图
-(UIImage *)juCaptureContent{
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(self.contentSize, NO, 2.0f);
    self.contentOffset = CGPointZero;
    self.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    [self.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
