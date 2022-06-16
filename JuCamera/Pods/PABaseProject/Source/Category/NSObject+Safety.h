//
//  NSObject+Safe.h
//  PABase
//
//  Created by Juvid on 16/7/7.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+JuEasy.h"

@interface NSObject (Safety)
/**self=nil时以下方法失效**/
- (NSDictionary *)safeDic ;

- (NSArray *)safeArr ;

- (NSString *)safeStr ;

- (NSNumber *)safeNum ;

- (instancetype)safeObjcClass:(Class)classs ;

- (BOOL)notEmpty;
/**self=nil时以上方法失效**/
/**对象转成data**/
-(NSData *)juObjectToData;
-(NSData *)juDataWithObject __deprecated_msg("Use juObjectToData instead.");//DEPRECATED_MSG_ATTRIBUTE

/**json 转成对象*/
-(id)juJsonToObject;
-(id)juJSONObjectWithDataOrStr __deprecated_msg("Use juJsonToObject instead.");

/*对象转成json字符串*/
-(NSString *)juObjectToJson;
-(NSString *)juStringWithJsonObject __deprecated_msg("Use juObjectToJson instead.");
///**数据转json**/
//-(id)juJSONObjectWithData;

@end


@interface NSArray<__covariant ObjectType>  (Safe)

- (ObjectType (^)(NSInteger index))safeIndex;

+(NSArray *) setSafeArray :(NSArray *) arr ;

+(NSArray* (^)(NSArray *imageNames))juImages;

@end


@interface NSDictionary (Safe)

- (id (^)(NSString *key))juKey;

+(NSDictionary *) setDictionary :(NSDictionary *) dic ;

@end

