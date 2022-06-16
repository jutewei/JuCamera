//
//  PredicateCheck.m
//  YunMySelf
//
//  Created by Juvid on 14/12/1.
//  Copyright (c) 2014年 Juvid(zhutianwei). All rights reserved.
//

#import "JuPredicateCheck.h"

@implementation JuPredicateCheck
// 手机号
+(BOOL)isMobileCheck:(NSString *)str{
//    NSString *Regex = @"^\\d{11}$";
    if (!str) return NO;
//     NSString *Regex = @"^(13[0-9]|14[0-9]|15[0-9]|16[0-9]|19[0-9]|18[0-9]|17[0-9])\\d{8}$";
    NSString *Regex = @"^(13|14|15|16|17|18|19)\\d{9}$";
    NSPredicate *Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [Test evaluateWithObject:str];
}
//+(void)safePhoneNume{
    //    echo "13800000000"|sed "s/\([0-9]\{3\}\)[0-9]\{4\}\([0-9]\{4\}\)/\1****\2/"
    //  NSString  *sed 's/\<\([0-9]\{3\}\)[0-9]\{4\}/\1****/g'
    //    sed -r 's/^(...).{4}/\1\****/'
//}
+(BOOL)matchesInString:(NSString *)str pattern:(NSString *)pattern{
//    pattern=@"\\.(js|css)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *result = [regex matchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    return result.count;
}
+(NSString*)abandonWhitesSpaceWithString:(NSString*)str{
    if (![str isKindOfClass:[NSString class]]) {
        return @"" ;
    }else{
//        NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];

        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        return trimedString ;
    
    }
}
//空字符
+(BOOL)isEmpty:(id)strObject{
    if (!strObject) {
        return true;
    } else {
        if ([strObject isKindOfClass:[NSString class]]) {
            //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
            NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
            //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
            NSString *trimedString = [strObject stringByTrimmingCharactersInSet:set];
            if ([trimedString length] == 0) {
                return true;
            }
        }else if([strObject isKindOfClass:[NSArray class]]){
            if ([strObject count]==0) {
                return true;
            }
        }
    }
    return false;
}
//加密手机号
+(NSString *)safePhoneNum:(NSString *)str{
    /*NSMutableString *num=[NSMutableString string];
    NSString *src=str;
    for (int i=0; i<src.length; i++) {
        if (i>2&&i<7) {
            [num appendString:@"*"];
        }
        else{
            NSString *single= [src substringWithRange:NSMakeRange(i,1)];
            [num appendString:single];
        }
    }
    return num;*/
    NSString *num=str;
    if (str.length>3) {
        NSInteger replac = MIN(str.length-3, 4);
        NSString *strPlac= [@"****" substringToIndex:replac];
        num=[str stringByReplacingCharactersInRange:NSMakeRange(3, replac) withString:strPlac];
    }
    return num;
}
+(NSString *)juSwithSafe:(NSString *)str left:(NSInteger)left right:(NSInteger)right{
    NSMutableString *num=[NSMutableString string];
    NSInteger leftE=MIN(left, str.length) ;
    NSInteger rightE=MIN(right, str.length) ;
    NSString *src=str;
    for (int i=0; i<src.length; i++) {
        if (i>=leftE&&src.length-rightE>i) {
            [num appendString:@"*"];
        }
        else{
            NSString *single= [src substringWithRange:NSMakeRange(i,1)];
            [num appendString:single];
        }
    }
    
    return num;
}
//利用正则表达式验证
+(BOOL)isCheckEmail:(NSString *)str {
    
    NSString *Regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    
//    NSString *Regex = @"[A+Z0+9a+z._%++]+@[A+Za+z0+9.+]+\\.[A+Za+z]{2,4}";
//    NSPredicate *Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [Test evaluateWithObject:str];
}

// 汉字验证(1+20个)
+(BOOL)isCheckChinese:(NSString *)str {
    NSString *Regex = @"^[\u4e00-\u9fa5]{1,20}+$";
    NSPredicate *Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [Test evaluateWithObject:str];
}

// 纯英文(1+20个)
+(BOOL)isCheckLetters:(NSString *)str {
    NSString *Regex = @"^[A-Za-z]{6,20}+$";
    NSPredicate *Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [Test evaluateWithObject:str];
}

+(BOOL)isPngImage:(NSData *)tempData{
    
    if (tempData.length > 4) {
        const unsigned char * bytes = [tempData bytes];
        
        if (bytes[0] == 0xff &&
            bytes[1] == 0xd8 &&
            bytes[2] == 0xff)
        {
            return NO;
        }
        
        if (bytes[0] == 0x89 &&
            bytes[1] == 0x50 &&
            bytes[2] == 0x4e &&
            bytes[3] == 0x47)
        {
            return YES;
        }
    }
    
    return NO;
    
    
//    if (tempData ) //request返回状态码
//    {
//        Byte pngHead[] = {0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a};//文件头数据
//        //NSLog(@"tempData = %@", tempData);
//        int cmpResult = memcmp(tempData.bytes, pngHead, 8);//判断是否为png格式
//        //NSLog(@"PNG head 8 bytes cmpResult = %d", cmpResult);
//        if (cmpResult == 0)
//        {
//            return YES;
//        }
//    }
//    return NO;
}
//
//// 用户名检测 纯英文或者纯中文 10个字符
//+(BOOL)userNameCheck:(NSString *)str {
//    BOOL isReal = NO;
//    NSString *userChinese = @"^[\u4e00+\u9fa5]{1,5}+$";
//    isReal = [str isMatchedByRegex:userChinese];
//    if (!isReal) {
//        NSString *namStr = @"^[a+zA+Z]{1,10}+$";
//        isReal = [str isMatchedByRegex:namStr];
//    }
//    return isReal;  // YES 符合要求 NO 不符合
//}
//
+(BOOL)userIDNumCheck:(NSString *)IDNum{
    //    @"^(^\d{15}$|^\d{18}$|^\d{17}(\d|X|x))$
    NSString *num = @"^(^\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$";
    //    NSString *num = @"^\\d{17}+[0+9a+zA+Z]$";
    NSPredicate *Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", num];
    return [Test evaluateWithObject:IDNum];
}

+(NSString *)GetLast:(NSString *)startStr RangStr:(NSString *)str{
    NSRange range=[startStr rangeOfString:str];
    if (range.location==NSNotFound) {
        return @"";
    }
    return [startStr substringFromIndex:range.location+range.length];
}
+(NSString *)GetPrevious:(NSString *)startStr RangStr:(NSString *)str{
    NSRange range=[startStr rangeOfString:str];
    if (range.location==NSNotFound) {
        return @"";
    }
    return [startStr substringToIndex:range.location];
}
+(NSString *)isCheckSpecial:(NSString *)tempString{
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+ "];
    tempString = [[tempString componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString: @""];
    
//    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
//    NSString *trimmedString = [tempString stringByTrimmingCharactersInSet:set];
    return tempString;
}


//// 身份证
//+(BOOL)userIDNumCheck:(NSString *)IDNum{
//    NSString *num = @"^\\d{17}+[0+9a+zA+Z]$";
//    BOOL isID = [IDNum isMatchedByRegex:num];
//
//    return isID;
//}
//
//// 邮箱验证
//+(BOOL)emailCheck:(NSString *)str{
//    NSString *email = @"^[A+Z0+9a+z._%++]+@[A+Za+z0+9.+]+\\.[A+Za+z]{2,4}$";
//    BOOL isEmail = [str isMatchedByRegex:email];
//
//    return isEmail; // YES 是邮箱
//}
//
//// QQ号验证
//+(BOOL)qqNumCheck:(NSString *)str {
//    NSString *qqregex = @"^[1+9][0+9]{4,}$";
//    BOOL isQQ = [str isMatchedByRegex:qqregex];
//
//    return isQQ;
//}
//
//// MSN号码验证
//+(BOOL)msnNumCheck:(NSString *)str {
//    BOOL isMSN;
//    NSRange ran = [str rangeOfString:@"@"];
//    if (ran.location == NSNotFound) {
//        isMSN = NO;
//    }
//    else {
//        NSArray  *enterArr= [str componentsSeparatedByString:@"@"];
//        NSString *hou = [enterArr objectAtIndex:1];
//        if ([hou isEqualToString:@"hotmail.com"] || [hou isEqualToString:@"live.com"]
//            || [hou isEqualToString:@"live.cn"] ) {
//            isMSN = YES;
//        }
//        else {
//            isMSN = NO;
//        }
//    }
//    return isMSN;
//}
//

//
//
//// 字符串是否 是纯回车,空格
//+(BOOL)stringIsEmptyNext:(NSString *)theString {
//    BOOL have = NO; // 不包含
//    NSString *empty = @"^[ ]{2,}$";
//    NSString *huiChe = @"^[\n]{2,}$";
//    if ([theString isMatchedByRegex:empty] || [theString isMatchedByRegex:huiChe]) {
//        return YES;
//    }
//    if ([theString isEqualToString:@" "] || [theString isEqualToString:@"\n"]) {
//        return YES;
//    }
//    return have;    // YES 包含回车或者空格
//}
//
//
//// 座机电话号码
//+(BOOL)callNumCheck:(NSString*)theString {
//    BOOL result = NO;
//    NSString *guDing = @"^[0+9]{3}+[0+9]{8}|[0+9]{4}+[0+9]{7}$";
//    BOOL gu = [theString isMatchedByRegex:guDing];
//    if (gu) {
//        result = YES;
//    }
//    else {
//        result = NO;
//    }
//
//    return result;
//}
+(BOOL)isPassWord:(NSString *)pass{
    BOOL result = false;
    if ([pass length] >= 6){
        // 判断长度大于6位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:pass];
    }
    return result;
}

@end
