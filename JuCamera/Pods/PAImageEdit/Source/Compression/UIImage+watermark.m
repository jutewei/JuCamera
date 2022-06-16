//
//  UIImage+watermark.m
//  PAImageEdit
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/7/22.
//

#import "UIImage+watermark.h"
#import "UIColor+hexString.h"

@implementation UIImage (watermark)


//加水印
-(UIImage *)zlWaterWithTexts:(NSArray *)texts{
    
    if ([texts isKindOfClass:[NSArray class]]&&texts.count) {
        UIGraphicsBeginImageContext(self.size);
        // Draw image1
        [self drawInRect:CGRectMake(0, 0, self.size.width,self.size.height)];
        // Draw image2 位置需要重写
        for(int i=0;i<texts.count;i++){
            NSDictionary* textArr = texts[i];
            CGFloat     fontSize   = [textArr[@"fontSize"] floatValue];   //字体大小
            NSString    *colorHex  = textArr[@"color"];   //字体颜色
            CGFloat     alpha      = [textArr[@"alpha"] floatValue];   //文字透明度
            CGFloat     left       = [textArr[@"left"] floatValue];   //文字距离左边距离
            CGFloat     top        = [textArr[@"top"] floatValue];   //文字距离头部距离
            NSString*   text       = textArr[@"text"];   //文字内容
            NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            UIFont *font = [UIFont fontWithName:@"AmericanTypewriter" size:fontSize];
            UIColor *txtColor=[UIColor zlColorWithHexString:colorHex alpha:alpha];
            NSDictionary *attribute=@{
                                      NSFontAttributeName:font,
                                      NSParagraphStyleAttributeName:paragraphStyle,
                                      NSForegroundColorAttributeName:txtColor
                                      };
            
            [text drawAtPoint:CGPointMake(left, top) withAttributes:attribute];
        }
        UIImage *newImage =UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }
    return self;
}

//加插件
-(UIImage *)juWaterWithImage:(UIImage *)image{
    UIGraphicsBeginImageContext(self.size);
    // Draw image1
    [self drawInRect:CGRectMake(0, 0, self.size.width,self.size.height)];
    // Draw image2 位置需要重写
    [image drawInRect:CGRectMake(0, 0, self.size.width,self.size.height)];
    UIImage *resultingImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

-(CGPoint)changeToPx:(CGPoint)value{
    return CGPointMake(self.size.width*value.x, self.size.height*value.y);
}

//加水印
-(UIImage *)zlWaterWithText:(NSAttributedString *)attribute  point:(CGPoint)point{
    if (attribute) {
        UIGraphicsBeginImageContext(self.size);
        // Draw image1
        [self drawInRect:CGRectMake(0, 0, self.size.width,self.size.height)];
        // Draw image2 位置需要重写
        [attribute drawAtPoint:point];
        UIImage *newImage =UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }
    return self;
}

@end
