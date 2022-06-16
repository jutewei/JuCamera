//
//  JuBadgeLable.h
//  MTSkinPublic
//
//  Created by Juvid on 16/10/10.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JuBadgeLable : UILabel

@property NSInteger maxMark;

-(void)juSetBackGround:(BOOL)red;

-(void)juSetTitle:(NSString *)title;

@end
