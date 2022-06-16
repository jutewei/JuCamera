//
//  JuButton.h
//  PABase
//
//  Created by Juvid on 2019/5/21.
//  Copyright © 2019 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PAErrorTest) {
    PAErrorCodeNone = -2, // 失败，但已经被其他组件处理
};
NS_ASSUME_NONNULL_BEGIN

typedef void(^JuButtonHandle)(void);//

@interface JuButton : UIButton
@property (nonatomic,copy)  JuButtonHandle ju_handler;///< 点击确认按钮回调
@property (nonatomic,strong)  UIColor *normalColor;

-(void)juTouchUpInside:(JuButtonHandle)handler;

-(void)setSelectColor:(UIColor *)selectColor normalColor:(UIColor *)normalColor;

-(void)highlightColor:(UIColor *)highlightColor  normalColor:(UIColor *) normalColor;

//-(void)setBackgroundImage;

-(void)setIsEnable:(BOOL)isEnable;

@end

NS_ASSUME_NONNULL_END
