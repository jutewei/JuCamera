//
//  NSObject+JuEasy.m
//  PABase
//
//  Created by Juvid on 2019/11/25.
//  Copyright © 2019 Juvid. All rights reserved.
//

#import "NSObject+JuEasy.h"
#import <objc/runtime.h>

@implementation NSObject (easy)

static const char* payload="nsobject.payload";
static const void *PayloadSelect = &PayloadSelect;
-(id)payloadObject{
    return objc_getAssociatedObject(self, &payload);
}
-(void)setPayloadObject:(id)payloadObject{
    objc_setAssociatedObject(self, &payload, payloadObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSInteger)payloadSelect
{
    return [objc_getAssociatedObject(self, PayloadSelect) intValue];
}
-(void)setPayloadSelect:(NSInteger)payloadSelect
{
    NSNumber *number = [[NSNumber alloc] initWithInteger:payloadSelect];
    objc_setAssociatedObject(self, PayloadSelect, number, OBJC_ASSOCIATION_COPY);
}

@end


@implementation UIView(easy)

-(void)removeAllSubviews{
    //    NSLog(@"这是谁  %@",self);
    while (self.subviews.count>0) {
        UIView *subview=self.subviews.firstObject;
        [subview removeFromSuperview];
    }
}

-(UIBarButtonItem*)barButtonItem{
    return [[UIBarButtonItem alloc] initWithCustomView:self];
}
//获取控制器
-(UIViewController*)viewController
{
    UIResponder *nextResponder =  self;
    do
    {
        nextResponder = [nextResponder nextResponder];

        if ([nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController*)nextResponder;

    } while (nextResponder != nil);

    return nil;
}
@end
