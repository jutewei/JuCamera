//
//  PFBKeyChainItem.m
//  PABase
//
//  Created by Juvid on 2019/1/4.
//  Copyright © 2019 Juvid(zhutianwei). All rights reserved.
//

#import "JuKeyChainData.h"
#define jDelimiter @"-|-"

@implementation JuKeyChainData

+(BOOL)juSetObject:(nullable id)object forKey:(NSString *)key{
    NSData *data=nil;
    if ([object isKindOfClass:[NSString class]]) {
        data=[object dataUsingEncoding:NSUTF8StringEncoding];
    }else if ([object isKindOfClass:[NSDictionary class]]){
        NSDictionary *dic=object;
        NSString *strValue=nil;
        NSMutableArray * keysAndValues = [NSMutableArray arrayWithArray:dic.allKeys];
        [keysAndValues addObjectsFromArray:dic.allValues];
        if (keysAndValues.count>0) {
            strValue=[keysAndValues componentsJoinedByString:jDelimiter];
        }
        data=[strValue dataUsingEncoding:NSUTF8StringEncoding];
    }
    return [self shSetData:data forKey:key];
}

+(id)juObjectForKey:(NSString *)key{
    NSData *data=[self shGetDataForKey:key];
    if (!data) {
        return nil;
    }
    NSString *strData=[[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
    if ([strData containsString:jDelimiter]) {
        NSArray *keysAndValues = [NSArray arrayWithArray:[strData componentsSeparatedByString:jDelimiter]];
        if (keysAndValues.count>0&&keysAndValues.count%2 !=0) {
            return nil;
        }
        NSUInteger half = keysAndValues.count / 2;
        NSRange keys = NSMakeRange(0, half);
        NSRange values = NSMakeRange(half, half);
        NSDictionary *dicValue=[NSDictionary dictionaryWithObjects:[keysAndValues subarrayWithRange:values]
                                                           forKeys:[keysAndValues subarrayWithRange:keys]];
        return dicValue;
    }else{
        return strData;
    }
}


+(BOOL)shSetData:(NSData *)data forKey:(NSString *)key{
    OSStatus status = -1;
    NSMutableDictionary * searchQuery = [self query];
    [searchQuery setObject:[self hierarchicalKey:key] forKey:(__bridge id)kSecAttrService];
    status = SecItemCopyMatching((__bridge CFDictionaryRef)searchQuery, nil);
    if (!data) {
        if (status == errSecSuccess) {
            status=SecItemDelete((__bridge CFDictionaryRef)searchQuery);
        }
        return (status == errSecSuccess);
    }

    NSMutableDictionary *query = nil;

    if (status == errSecSuccess) {//item already exists, update it!
        query = [[NSMutableDictionary alloc]init];
        [query setObject:data forKey:(__bridge id)kSecValueData];
#if __IPHONE_4_0 && TARGET_OS_IPHONE
        CFTypeRef accessibilityType = [JuKeyChainData accessibilityType];
        if (accessibilityType) {
            [query setObject:(__bridge id)accessibilityType forKey:(__bridge id)kSecAttrAccessible];
        }
#endif
        status = SecItemUpdate((__bridge CFDictionaryRef)(searchQuery), (__bridge CFDictionaryRef)(query));
    }else if(status == errSecItemNotFound){//item not found, create it!
        query = [NSMutableDictionary dictionaryWithDictionary:searchQuery];
        [query setObject:data forKey:(__bridge id)kSecValueData];
#if __IPHONE_4_0 && TARGET_OS_IPHONE
        CFTypeRef accessibilityType = [JuKeyChainData accessibilityType];
        if (accessibilityType) {
            [query setObject:(__bridge id)accessibilityType forKey:(__bridge id)kSecAttrAccessible];
        }
#endif
        status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    }
    if (status != errSecSuccess ) {
        NSLog(@"失败了哦");
    }
    return (status == errSecSuccess);
}

+(NSData *)shGetDataForKey:(NSString *)key{
    NSMutableDictionary *query = [self query];
    /// <多个key用其中一个即可 kSecAttrGeneric kSecAttrService kSecAttrAccount
    [query setObject:[self hierarchicalKey:key] forKey:(__bridge id)kSecAttrService];
    //    [query setObject:@"juvid" forKey:(__bridge id)kSecAttrAccount];
    [query setObject: (__bridge id) kCFBooleanTrue  forKey: (__bridge id) kSecReturnData];
    //    [query setObject:(__bridge id) kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
    //    [query setObject:(__bridge id)kSecMatchLimitAll forKey:(__bridge id)kSecMatchLimit];
#if __IPHONE_4_0 && TARGET_OS_IPHONE
    CFTypeRef accessibilityType = [JuKeyChainData accessibilityType];
    if (accessibilityType) {
        [query setObject:(__bridge id)accessibilityType forKey:(__bridge id)kSecAttrAccessible];
    }
#endif

    CFTypeRef refData = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &refData);
    if (status != errSecSuccess ) {
        return nil;
    }
    return (__bridge_transfer NSData *)refData;
}

+ (NSMutableDictionary *)query {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:3];
    [dictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    return dictionary;
}
+ (CFTypeRef)accessibilityType {
    return kSecAttrAccessibleWhenUnlocked;
}

+(NSString *)hierarchicalKey:(NSString *)key{
    NSString *identifier = [[[NSBundle mainBundle] infoDictionary]objectForKey:(NSString*)kCFBundleIdentifierKey];
    return [identifier stringByAppendingFormat:@".%@", key];
}
@end
