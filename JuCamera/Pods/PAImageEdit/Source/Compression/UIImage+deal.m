//
//  UIImage+deal.m
//  TestImage
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/5/14.
//

#import "UIImage+deal.h"
#import "UIColor+hexString.h"

//#define PAImageDefaultWid 1080

@implementation UIImage (deal)

/**裁剪略缩图*/
-(UIImage*)zlSetThumbnail{
    return [self zlSetMinSide:150];
}

/**以最小边压缩**/
-(UIImage *)zlSetMinSide :(CGFloat)newSize{
    if(newSize<=0)return self;
    CGSize oSize=CGSizeMake(self.size.width*self.scale, self.size.height*self.scale);
    if (MIN(oSize.height, oSize.width) <= newSize) {
        return self;
    }
    CGSize  fixSize;
    if (oSize.width>oSize.height) {
        fixSize=CGSizeMake(newSize*(oSize.width/oSize.height),newSize);
    }else{
        fixSize=CGSizeMake(newSize,newSize*(oSize.height/oSize.width));
    }
    return [self zlFixImage :fixSize];
}

/**以最大边压缩*/
-(UIImage *)zlSetMaxSide :(CGFloat)newSize{
    if(newSize<=0)return self;
    CGSize  fixSize;
    CGSize oSize=CGSizeMake(self.size.width*self.scale, self.size.height*self.scale);
    if (MAX(oSize.width,oSize.height)<=newSize) {
        return self;
    }
    if (oSize.width>=oSize.height) {
        fixSize=CGSizeMake(newSize,newSize*(oSize.height/oSize.width));
    }else{
        fixSize=CGSizeMake(newSize*(oSize.width/oSize.height),newSize);
    }
    return  [self zlFixImage:fixSize];
}

//按指定尺寸压缩
-(UIImage *)zlFixImage:(CGSize)fixSize{
    UIGraphicsBeginImageContext(fixSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [self drawInRect:CGRectMake(0,0,fixSize.width,fixSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}
//图片裁剪（指定区域裁剪）
- (UIImage *)zlImageFromInRect:(CGRect)rect original:(CGSize)oSize{
    CGFloat cropingX=(rect.origin.x/oSize.width)*self.size.width;
    CGFloat cropingY=(rect.origin.y/oSize.height)*self.size.height;
    CGFloat cropingW=(rect.size.width/oSize.width)*self.size.width;
    CGFloat cropingH=(rect.size.height/oSize.height)*self.size.height;
    CGRect croping=CGRectMake(cropingX, cropingY, cropingW, cropingH);
    return [self zlImageFromInRect:croping];
}

- (UIImage *)zlImageFromInRect:(CGRect)cropRect{
    CGImageRef sourceImageRef = [self CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, cropRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}

-(CGFloat)imageLenght{
    return UIImageJPEGRepresentation(self, 1).length/(1024.*1024);
}

@end

