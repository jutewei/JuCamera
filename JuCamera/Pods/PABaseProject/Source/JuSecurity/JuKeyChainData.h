//
//  PFBKeyChainItem.h
//  PABase
//
//  Created by Juvid on 2019/1/4.
//  Copyright © 2019 Juvid(zhutianwei). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>
NS_ASSUME_NONNULL_BEGIN

@interface JuKeyChainData : NSObject

/**
 钥匙串存储

 @param object 数据
 @param key 关键key
 @return 是否成功
 */
+(BOOL)juSetObject:(nullable id)object forKey:(NSString *)key;

/**
 钥匙串读取

 @param key 关键key
 @return 数据
 */
+(id)juObjectForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
/*
 *kSecClass:有五个值，分别为
 kSecClassGenericPassword(通用密码－－也是接下来使用的)、
 kSecClassInternetPassword(互联网密码)、
 kSecClassCertificate(证书)、
 kSecClassKey(密钥)、
 kSecClassIdentity(身份)

 kSecAttrService:服务
 kSecAttrServer:服务器域名或IP地址
 kSecAttrAccount:账号
 kSecAttrAccessGroup: 可以在应用之间共享keychain中的数据
 kSecMatchLimit:返回搜索结果，kSecMatchLimitOne（一个）、kSecMatchLimitAll（全部）
 */

/*
 //添加
 OSStatus SecItemAdd(CFDictionaryRef attributes, CFTypeRef *result);

 // 更新
 OSStatus SecItemUpdate(CFDictionaryRef query, CFDictionaryRef attributesToUpdate);

 // 删除
 OSStatus SecItemDelete(CFDictionaryRef query)

 */
