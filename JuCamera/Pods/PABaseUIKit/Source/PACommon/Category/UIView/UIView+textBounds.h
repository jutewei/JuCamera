//
//  UILabel+StringFrame.h
//  XYLEPlay
//
//  Created by Juvid on 15/6/30.
//  Copyright (c) 2015年 Juvid(zhutianwei). All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UILabel (textBounds)
- (CGSize)boundingRectWithSize:(CGFloat)width;
- (CGFloat)boundingWidth:(CGFloat)height;
- (CGFloat)boundingHeight:(CGFloat)width;
@end

@interface UITextField (textBounds)
- (CGSize)boundingRectWithSize:(CGFloat)width;
- (CGFloat)boundingWidth:(CGFloat)width;
- (CGFloat)boundingHeight:(CGFloat)width;
@end

@interface UIButton (textBounds)
- (CGSize)boundingRectWithSize:(CGFloat)width;
- (CGFloat)boundingWidth:(CGFloat)width;
- (CGFloat)boundingHeight:(CGFloat)width;
@end

@interface UITextView(textBounds)
- (CGSize)boundingRectWithSize:(CGFloat)width;
- (CGFloat)boundingWidth:(CGFloat)width;
- (CGFloat)boundingHeight:(CGFloat)width;
@end
