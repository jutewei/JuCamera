//
//  NSData+Encryption.h
//  PABase
//
//  Created by Juvid on 15/9/6.
//  Copyright (c) 2015年 Juvid(zhutianwei). All rights reserved.
//

#import <Foundation/Foundation.h>
#define JUCBCIVKEY          @"kl3ko_8sk2!12@k5" //可以自行修改

@interface NSData (Encryption)
//256加解密 ECB加密
- (NSData *)AES256EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES256DecryptWithKey:(NSString *)key;   //解密

//128加解密 CBC加密 iv 需要约定
- (NSData *)AES128EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES128DecryptWithKey:(NSString *)key;   //解密
@end


@interface NSString (Encryption)

//256加解密 ECB加密
- (NSString *)AES256EncryptWithKey:(NSString *)key;//加密
- (NSString *)AES256DecryptWithKey:(NSString *)key;//解密

//128加解密 CBC加密 iv 需要约定
-(NSString *)AES128EncryptWithKey:(NSString*)key;//加密
-(NSString *)AES128DecryptWithKey:(NSString*)key;//AES解密

@end
