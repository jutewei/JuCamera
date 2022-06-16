//
//  JuTextFieldDelegate.h
//  PABase
//
//  Created by Juvid on 2020/3/2.
//  Copyright © 2020 Juvid. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JuTextFieldDelegate <UITextFieldDelegate>

@optional

- (void)juEnableButton:(BOOL)isEnable;

- (void)juGetTextField:(NSString *)strText;


@end

NS_ASSUME_NONNULL_END
