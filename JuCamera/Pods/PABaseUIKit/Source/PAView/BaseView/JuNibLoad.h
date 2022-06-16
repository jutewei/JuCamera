//
//  NibLoad.h
//  YunHK
//
//  Created by Juvid on 14/12/30.
//  Copyright (c) 2014年 Juvid(zhutianwei). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JuNibLoad : NSObject
+(UIView*)loadNib:(NSString *)nibName;
@property (strong, nonatomic) IBOutlet UIView *leNibview;
@property (strong ,nonatomic) UIView *otherView;
@end
