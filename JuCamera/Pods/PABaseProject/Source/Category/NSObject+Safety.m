//
//  NSObject+Safe.m
//  PABase
//
//  Created by Juvid on 16/7/7.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "NSObject+Safety.h"

@implementation NSObject (Safety)

- (instancetype)safeDic {
    if (![self isKindOfClass:[NSDictionary class]]) {
        return [NSMutableDictionary dictionary];
    }
    return self;
}

- (instancetype)safeArr {
    if (![self isKindOfClass:[NSArray class]]) {
        return [NSMutableArray array];
    }
    return self;
}

- (instancetype)safeStr {
    if (![self isKindOfClass:[NSString class]]) {
        return @"";
    }
    return self;
}

- (instancetype)safeNum {
    if (![self isKindOfClass:[NSNumber class]]) {
        return [NSNumber new];
    }
    return self;
}

- (instancetype)safeObjcClass:(Class)classs {
    if (![self isKindOfClass:classs]) {
        return nil;
    }
    return self;
}

- (BOOL)notEmpty{
    if ([self isKindOfClass:[NSString class]]) {
        NSString *string=(id)self;
        return string.length;
    }else if ([self isKindOfClass:[NSArray class]]){
        NSArray *array=(id)self;
        return array.count;
    }else if ([self isKindOfClass:[NSDictionary class]]){
        NSDictionary *dic=(id)self;
        return dic.count;
    }
    return NO;
}

/**对象转成data**/
-(NSData *)juObjectToData{
    if ([self notEmpty]) {
        NSError* error = nil;
        NSData* jsonData;
        if (@available(iOS 11.0, *)) {
           jsonData=[NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingSortedKeys error:&error];
        } else {
             jsonData=[NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
            // Fallback on earlier versions
        }
        if (error==nil) {
            return jsonData;
        }
    }
    return nil;
}

-(NSData *)juDataWithObject{
    return [self juObjectToData];
}

/**josn、data转对象**/
-(id)juJsonToObject{
    NSData *jsonData=nil;
    if ([self isKindOfClass:[NSData class]]) {
        jsonData=(NSData*)self;
    }else if([self isKindOfClass:[NSString class]]){
        jsonData = [(NSString *)self dataUsingEncoding:NSUTF8StringEncoding];
    }else{
        return self;
    }
    return [NSJSONSerialization JSONObjectWithData:jsonData
                                           options:NSJSONReadingMutableContainers
                                             error:nil];
}

-(id)juJSONObjectWithDataOrStr{
    return [self juJsonToObject];
}

/**对象转json*/
-(NSString *)juObjectToJson{
    NSData *data=nil;
    if([self isKindOfClass:[NSString class]]){
        return (NSString *)self;
    }
    else if ([self isKindOfClass:[NSData class]]) {
        data=(NSData *)self;
    }else {
        data=[self juObjectToData];
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

-(NSString *)juStringWithJsonObject{
    return [self juObjectToJson];
}

@end

@implementation NSArray (Safe)

-(id (^)(NSInteger index))safeIndex{
    return ^id (NSInteger  index){
        if (index<self.count) {
            return    [self objectAtIndex:index];
        }
        return nil;
    };
}
/**
 *  网络获取数据数组转换
 */
+(NSArray *) setSafeArray :(NSArray *) arr{
    if ([arr isKindOfClass:[NSArray class]]) {
        return arr;
    }else{
        return [NSMutableArray new];
    }
}

+(NSArray* (^)(NSArray *images))juImages{
    return ^ NSArray * (NSArray *images){
        NSMutableArray *arrImage=[NSMutableArray array];
        for (id img in images) {
            if ([img isKindOfClass:[UIImage class]]) {
                [arrImage addObject:img];
            }else{
                UIImage *image=[UIImage imageNamed:img];
                if (image) {
                    [arrImage addObject:image];
                }
            }
        }
        return arrImage;
    };
}

@end

@implementation NSDictionary (Safe)

- (id (^)(NSString *key))juKey{
    return ^id (NSString  *key){
        if (self[key]) {
            return  [self valueForKey:key];
        }
        return nil;
    };
}

+(NSDictionary *) setDictionary :(NSDictionary *) dic{
    if ([dic isKindOfClass:[NSDictionary class]]) {
        return dic;
    }else{
        return [NSMutableDictionary new];
    }
}
@end
