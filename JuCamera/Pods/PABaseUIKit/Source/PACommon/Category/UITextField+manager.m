//
//  UITextField+manager.m
//  PABase
//
//  Created by Juvid on 2019/6/25.
//  Copyright © 2019 Juvid. All rights reserved.
//

#import "UITextField+manager.h"

@implementation UITextField (manager)
-(void)setPlaceHolderText:(NSString *)string color:(UIColor *)color;{
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string attributes:
                                      @{NSForegroundColorAttributeName:color,NSFontAttributeName:self.font}];

    self.attributedPlaceholder = attrString;
}
@end
