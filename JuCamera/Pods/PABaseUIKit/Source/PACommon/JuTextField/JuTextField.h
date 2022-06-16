//
//  JuTextField.h
//  PABase
//
//  Created by Juvid on 2020/3/2.
//  Copyright © 2020 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JuTextFieldDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface JuTextField : UITextField<UITextFieldDelegate>

@property(nonatomic,assign) NSInteger ju_maximum;///< 文本框输入最大长度或者最大值
@property(nonatomic,assign) NSInteger ju_minimum;///< 文本框输入最小长度或者最小值

@property(nonatomic,assign) BOOL isNumKeyboard;///< 是否数字键盘
@property (nonatomic) NSInteger ju_pointNum;


-(BOOL)isPosition;///< 是否有高亮
-(void)juSetBase;
@property (nonatomic,assign) IBOutlet id<JuTextFieldDelegate> juDelegate;
@end

@interface JuNumTextField : JuTextField

@end


NS_ASSUME_NONNULL_END
