//
//  UIImage+MUCommon.h
//  BigCalculate
//
//  Created by Juvid on 16/10/27.
//  Copyright © 2016年 Juvid . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIImage (category)

-(UIImage *_Nonnull)juFixOrientation;

-(UIImage *_Nonnull)juRotatingOrientation;
//马赛克图层
-(UIImage *)juMosaicLevel:(NSUInteger)level;

@end


@interface UIImageView (category)

- (void)juRotationView;

- (UIImage *_Nullable)juSaveRotationResult;

- (CGRect)juSetImage:(UIImage *_Nullable)image;

-(CGFloat)juSafeBottom;


-(CGFloat)juWindowWidth;

-(CGFloat)juWindowHeight;

@end

@interface UIScrollView (category)

//获取Scrollview截图
-(UIImage *)juCaptureContent;

@end
