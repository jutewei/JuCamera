//
//  NSObject+JuEasy.h
//  PABase
//
//  Created by Juvid on 2019/11/25.
//  Copyright © 2019 Juvid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (easy)

@property(nonatomic,strong)id payloadObject;
@property  NSInteger payloadSelect;

@end


@interface UIView (easy)

-(void)removeAllSubviews;//移除所有View
-(UIBarButtonItem*)barButtonItem;
//获取控制器
-(UIViewController*)viewController;
@end
NS_ASSUME_NONNULL_END
