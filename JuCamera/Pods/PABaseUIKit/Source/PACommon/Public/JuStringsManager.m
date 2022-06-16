//
//  JuStringsManager.m
//  PABase
//
//  Created by Juvid on 2019/7/4.
//  Copyright © 2019 Juvid. All rights reserved.
//

#import "JuStringsManager.h"
#import "JuFileManage.h"

@implementation JuStringsManager

+ (instancetype) sharedInstance{
    static JuStringsManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JuStringsManager alloc] init];
    });
    return sharedInstance;
}

-(NSDictionary *)ju_markWord{
    if (!_ju_markWord) {
        _ju_markWord=[JuFileManage juJsonResource:@"markedWords"];
    }
    return _ju_markWord;
}

-(NSDictionary *)juDiagLogWords{
    return [JuFileManage juJsonResource:@"diaglogWords"];
}

-(NSDictionary *)juTitleWords{
    return [JuFileManage juJsonResource:@"titleWords"];
}
+(NSDictionary *)juEventKeys{
    return [JuFileManage juJsonResource:@"eventDesc"];
}
-(NSString *)juSexTitle:(NSInteger)gender{
    if (gender==1) {
        return @"男";
    }else if (gender==2){
        return @"女";
    }
    return @"";
}

@end
