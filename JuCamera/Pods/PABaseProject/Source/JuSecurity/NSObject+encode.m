//
//  NSObject+encode.m
//  PABase
//
//  Created by Juvid on 2019/12/13.
//  Copyright © 2019 Juvid. All rights reserved.
//

#import "NSObject+encode.h"


@implementation NSObject (encode)

-(void)juSetEncode:(NSString *)encodeKey path:(NSString *)path{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self forKey:encodeKey]; // archivingDate的encodeWithCoder
    //    方法被调用
    [archiver finishEncoding];
    if([data writeToFile:path atomically:YES]){
        NSLog(@"归档成功");
    }
}

+(id)juGetEncode:(NSString *)encodeKey path:(NSString *)path{
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:path];
    if (data) {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
           //获得类
        NSObject *obj = [unarchiver decodeObjectForKey:encodeKey];// initWithCoder方法被调用
        [unarchiver finishDecoding];
           //读取的数据
        return obj;
    }
    return nil;
}
@end
