//
//  UITextField+Selection.h
//  PABase
//
//  Created by Juvid on 16/8/22.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Selection)
- (NSRange) selectedRange;
- (void) setSelectedRange:(NSRange) range;
@end
