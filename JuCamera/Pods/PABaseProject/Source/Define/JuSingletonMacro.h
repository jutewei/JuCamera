//
//  JuSingletonMacro.h
//  PANetServiceDemo
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/6/28.
//

#ifndef JuSingletonMacro_h
#define JuSingletonMacro_h

#pragma mark - 单例
// .h文件
#define JuSingletonH(name) + (instancetype)shared##name;

// .m文件

#define JuSingletonM(name) \
static id _instace; \
+ (instancetype)shared##name \
{ \
 @synchronized(self) {\
    if(_instace == nil) {\
        _instace = [[self alloc] init]; \
    } \
 }\
 return _instace; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
    return _instace; \
}

#pragma mark - 强制单例（所有的子类统一使用父类单例）
#define JuSingletonMM(name) \
JuSingletonM(name)\
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
    @synchronized(self) {\
    if(_instace == nil) {\
        _instace = [super allocWithZone:zone]; \
    }\
    }\
 return _instace; \
}

#define JuSharedInstanceH     JuSingletonH(Instance)
#define JuSharedInstanceM     JuSingletonM(Instance)
#define JuSharedInstanceMM    JuSingletonMM(Instance)
/*
 #pragma mark - 单例
 // .h文件
 #define JuSingletonH(name) + (instancetype)shared##name;
 #define JuNonnullSingletonH(name) + (nonnull instancetype)shared##name;

 // .m文件

 #define JuSingletonM(name) \
 static id _instace; \
 + (instancetype)shared##name \
 { \
 static dispatch_once_t onceToken; \
 dispatch_once(&onceToken, ^{ \
 _instace = [[self alloc] init]; \
 }); \
 return _instace; \
 } \
 \
 - (id)copyWithZone:(NSZone *)zone \
 { \
 return _instace; \
 }

 #pragma mark - 强制单例（所有的子类统一使用父类单例）
 #define JuSingletonMM(name) \
 JuSingletonM(name)\
 + (instancetype)allocWithZone:(struct _NSZone *)zone \
 { \
 static dispatch_once_t onceToken; \
 dispatch_once(&onceToken, ^{ \
 _instace = [super allocWithZone:zone]; \
 }); \
 return _instace; \
 }
 **/
/*
 +(instancetype)sharedInstance {
     static id sharedStore = nil;
     if (!sharedStore)
         sharedStore = [[super allocWithZone: nil] init];
     return sharedStore;
 }

 +(id)allocWithZone:(NSZone *)zone {
     return [self sharedStore];
 }
 */

#endif /* JuSingletonMacro_h */
