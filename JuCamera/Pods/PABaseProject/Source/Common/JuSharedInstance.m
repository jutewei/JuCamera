//
//  JuSharedInstance.m
//  PABase
//
//  Created by Juvid on 2017/8/23.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import "JuSharedInstance.h"
#import <UserNotifications/UserNotifications.h>
#import "JuSystemDefine.h"

@implementation JuSharedInstance{
    NSMutableDictionary *ju_shareObj; ///<  对象集合
}

+ (instancetype) sharedInstance
{
    static JuSharedInstance *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance juInit];
    });
    return sharedInstance;
}

-(void)juInit{
    ju_shareObj=[NSMutableDictionary dictionary];
}

-(void)juSetValue:(id)value key:(NSString *)key{
    @synchronized (ju_shareObj) {
        [ju_shareObj setValue:value forKey:key];
    }
}

-(id)juObjectForClass:(Class)objClass{
    if (!objClass) return nil;
    NSString *key=NSStringFromClass(objClass);
    id object= [self juObjectForKey:key];
    if (!object) {
        object = [[objClass alloc]init];
        [self juSetValue:object key:key];
    }
    return object;
}

-(id)juObjectForKey:(NSString *)key{
    @synchronized (ju_shareObj) {
        return [ju_shareObj objectForKey:key];
    }
}

-(void)juRemoveObjectForKey:(NSString *)key{
    @synchronized (ju_shareObj) {
         [ju_shareObj removeObjectForKey:key];
    }
}

-(void)juRemoveObjectForClass:(Class)objClass{
    if (!objClass) return;
    [self juRemoveObjectForKey:NSStringFromClass(objClass)];
}




-(void)setUserPhone:(NSString *)phone
             dbName:(NSInteger)dbName{
    self.ju_userIdentifier=phone;
    self.ju_dbName=[NSString stringWithFormat:@"%ld",(long)dbName];
}

-(NSString *)juUserDBName{
    if (self.ju_userIdentifier.length) {
        return self.ju_userIdentifier;
    }
    return self.ju_dbName;
}

-(JuWindow *)ju_toPwindow{
    if (!_ju_toPwindow) {
        _ju_toPwindow =[JuWindow juInit];
    }
    [_ju_toPwindow shShowWindow];
    return _ju_toPwindow;
}

-(JuWindow *)ju_window{
    if (!_ju_window) {
        _ju_window =[JuWindow juInit];
        _ju_window.windowLevel=UIWindowLevelAlert+1;
    }
    [_ju_window shShowWindow];
    return _ju_window;
}

-(UIViewController *)topViewcontrol{
    if (_topViewcontrol) {
        return _topViewcontrol;
    }
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *presentedController = controller.presentedViewController;
    while (presentedController && ![presentedController isBeingDismissed]) {
      controller = presentedController;
      presentedController = controller.presentedViewController;
    }
    return controller;
}

@end
