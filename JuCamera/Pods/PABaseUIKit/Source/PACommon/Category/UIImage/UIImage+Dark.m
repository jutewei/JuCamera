//
//  UIImage+Dark.m
//  PABase
//
//  Created by Juvid on 2020/3/23.
//  Copyright © 2020 Juvid. All rights reserved.
//

#import "UIImage+Dark.h"


@implementation UIImage (Dark)

+(UIImage *)imageNamed:(NSString *)name darkHex:(NSInteger)darkHex{
    return [self imageNamed:name darkColor:JUDarkColorHex(darkHex)];
}

+(UIImage *)imageNamed:(NSString *)name darkColor:(UIColor *)darkColor{
    UIImage *image=[UIImage imageNamed:name];
    if (@available(iOS 13.0, *)) {
        image=[image imageWithTintColor:darkColor];
    }
    return image;
}

@end
