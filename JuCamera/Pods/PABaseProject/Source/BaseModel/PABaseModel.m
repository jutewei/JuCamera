//
//  BaseModel.m
//  JsonModel
//
//  Created by Juvid on 14-6-30.
//  Copyright (c) 2015年 Juvid(zhutianwei). All rights reserved.
//

#import "PABaseModel.h"

@implementation PABaseModel

/*
////如果需要传参直接在参数列表后面添加就好了
void dynamicBaseModelIMP(id self, SEL _cmd, id name) {
    NSString *method = NSStringFromSelector(_cmd);
    NSLog(@"%@ %@ %@",self ,method ,name);
}

+ (BOOL)resolveInstanceMethod:(SEL)name {
//    NSLog(@"resolveInstanceMethod: %@", NSStringFromSelector(name));
//    if (name == @selector(appendString:)) {
//        class_addMethod([self class], name, (IMP)dynamicAdditionMethodIMP, "v@:");
//        return YES;
//    }
    return [super resolveInstanceMethod:name];
}
+ (BOOL)resolveClassMethod:(SEL)name {
    [super resolveClassMethod:name];
    class_addMethod(object_getClass(self), name, (IMP)dynamicBaseModelIMP, "v@:");
    return YES;
//    return [super resolveClassMethod:name];
}


- (id)forwardingTargetForSelector:(SEL)aSelector{
    NSString *method = NSStringFromSelector(aSelector);
    NSLog(@"未找到的方法 %@ %@",self,method);
    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    return [super methodSignatureForSelector:@selector(noMethodDeal:)];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
#ifdef DEBUG
    // 从继承树中查找
    [super forwardInvocation:anInvocation];
#else
    SEL sel = @selector(noMethodDeal:);
    [anInvocation setTarget:self];
    [anInvocation setSelector:sel];
    NSString *city = @"baseVC";
    // 消息的第一个参数是self，第二个参数是选择子，所以"北京"是第三个参数
    [anInvocation setArgument:&city atIndex:2];
    [anInvocation invokeWithTarget:self];
#endif
}
// 完整的消息转发
- (void)noMethodDeal:(NSString*)city{
    NSLog(@"crash class：%@", city);
}
*/

-(NSMutableDictionary *)zlToDictionary {
    NSMutableDictionary *dic=[self juToDictionary];
    if (self.zlRemoveKey) {
        [dic removeObjectsForKeys:self.zlRemoveKey];
    }
    return dic;
}

+(NSArray *)juProPrefixs{
    static NSArray * juPrefixs=nil;
    if (!juPrefixs) {
        juPrefixs=@[@"zl_"];
    }
    return juPrefixs;
}

-(NSArray *)zlRemoveKey{
    return nil;
}

+(Class)juBaseClass{
    return [PABaseModel class];
}
-(Class)juBaseClass{
    return [PABaseModel class];
}
@end


