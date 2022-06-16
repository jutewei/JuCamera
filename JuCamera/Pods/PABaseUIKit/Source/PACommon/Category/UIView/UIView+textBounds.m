//
//  UILabel+StringFrame.m
//  XYLEPlay
//
//  Created by Juvid on 15/6/30.
//  Copyright (c) 2015年 Juvid(zhutianwei). All rights reserved.
//

#import "UIView+textBounds.h"


@implementation UILabel (textBounds)
- (CGSize)boundingRectWithSize:(CGFloat)width {
    NSMutableDictionary *dicStyle=[NSMutableDictionary dictionary];
    if (self.attributedText.length>0) {
        NSRange range = NSMakeRange(0, self.attributedText.length);
        NSDictionary *dic = [self.attributedText attributesAtIndex:0 effectiveRange:&range];   // 获取该段
        NSMutableParagraphStyle *last=dic[NSParagraphStyleAttributeName];
        if (last) {
            NSMutableParagraphStyle *newStyle=[last mutableCopy];
            newStyle.lineBreakMode=NSLineBreakByWordWrapping;
            [dicStyle setObject:newStyle forKey:NSParagraphStyleAttributeName];
        }
    }
    [dicStyle setValue:self.font forKey:NSFontAttributeName];

    CGSize sizeText=CGSizeMake(width, MAXFLOAT);
    CGSize retSize = [self.text boundingRectWithSize:sizeText
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:dicStyle
                                             context:nil].size;
    return retSize;
}

-(CGFloat)boundingWidth:(CGFloat)width{
    return [self boundingRectWithSize:width].width;
}
-(CGFloat)boundingHeight:(CGFloat)width{
    return [self boundingRectWithSize:width].height;
}

@end


@implementation UIButton (textBounds)

- (CGSize)boundingRectWithSize:(CGFloat)width
{
    NSDictionary *attribute = @{NSFontAttributeName: self.titleLabel.font};
    NSString *title=self.currentAttributedTitle?self.currentAttributedTitle.string:self.currentTitle;
    CGSize retSize = [title  boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}
-(CGFloat)boundingWidth:(CGFloat)width{
    return [self boundingRectWithSize:width].width;
}
-(CGFloat)boundingHeight:(CGFloat)width{
    return [self boundingRectWithSize:width].height;
}
@end

@implementation UITextField (textBounds)

- (CGSize)boundingRectWithSize:(CGFloat)width
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize retSize = [self.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}
-(CGFloat)boundingWidth:(CGFloat)width{
    return [self boundingRectWithSize:width].width;
}
-(CGFloat)boundingHeight:(CGFloat)width{
    return [self boundingRectWithSize:width].height;
}
@end
@implementation UITextView (textBounds)

- (CGSize)boundingRectWithSize:(CGFloat)width
{
//    NSMutableDictionary *dicStyle=[NSMutableDictionary dictionary];
//    if (self.attributedText.length>0) {
//        NSRange range = NSMakeRange(0, self.attributedText.length);
//        NSDictionary *dic = [self.attributedText attributesAtIndex:0 effectiveRange:&range];   // 获取该段
//        NSMutableParagraphStyle *last=dic[NSParagraphStyleAttributeName];
//        if (last) {
//            NSMutableParagraphStyle *newStyle=[last mutableCopy];
//            newStyle.lineBreakMode=NSLineBreakByWordWrapping;
//            [dicStyle setObject:newStyle forKey:NSParagraphStyleAttributeName];
//        }
//    }
//    [dicStyle setValue:self.font forKey:NSFontAttributeName];
//
//    CGRect retSize = [self.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
//                                             options:\
//                      NSStringDrawingUsesLineFragmentOrigin |
//                      NSStringDrawingUsesFontLeading
//                                          attributes:dicStyle
//                                             context:nil];

    CGSize size = [self sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];

    return size;
}
-(CGFloat)boundingWidth:(CGFloat)width{
    return [self boundingRectWithSize:width].width;
}
-(CGFloat)boundingHeight:(CGFloat)width{
    return [self boundingRectWithSize:width].height;
}
@end

/*
 *
 NSStringDrawingTruncatesLastVisibleLine：
 
 如果文本内容超出指定的矩形限制，文本将被截去并在最后一个字符后加上省略号。如果没有指定NSStringDrawingUsesLineFragmentOrigin选项，则该选项被忽略。
 
 NSStringDrawingUsesLineFragmentOrigin：
 
 绘制文本时使用 line fragement origin 而不是 baseline origin。
 
 The origin specified when drawing the string is the line fragment origin and not the baseline origin.
 
 NSStringDrawingUsesFontLeading：
 
 计算行高时使用行距。（译者注：字体大小+行间距=行距）
 
 NSStringDrawingUsesDeviceMetrics：
 
 计算布局时使用图元字形（而不是印刷字体）。
 
 Use the image glyph bounds (instead of the typographic bounds) when computing layout.
 */


