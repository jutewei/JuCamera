//
//  JuBarButton.h
//  PABase
//
//  Created by Juvid on 2018/11/27.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^PFBTouchHandle)(id  _Nullable button);
NS_ASSUME_NONNULL_BEGIN

@interface JuBarButton : UIButton



+(NSArray <UIBarButtonItem *>*)juInitBarItems:(NSArray *)itemsName resultHandle:(PFBTouchHandle)handle;

+(JuBarButton *)juInitBarItem:(id)medium  systemType:(BOOL)isSystem;

-(void)setImageName:(NSString *)imageName;

-(void)setTitle:(NSString *)title;

- (void)setTitleColor:(nullable UIColor *)color;

- (void)addTarget:(nullable id)target action:(SEL)action forAlignment:(UIControlContentHorizontalAlignment)alignment;

@end

NS_ASSUME_NONNULL_END
