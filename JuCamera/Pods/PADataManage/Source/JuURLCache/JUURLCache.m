//
//  JUURLCache.m
//  JUURLCache
//
//  Created by Juvid on 18/10/25.
//  Copyright (c) 2018年 Juvid(zhutianwei). All rights reserved.
//

#import "JUURLCache.h"
#import <CommonCrypto/CommonDigest.h>


@interface JUURLCache(){
    NSMutableString *urlPara;
    NSString *_urlPath;
}
@property(nonatomic,strong) id<JuCacheAdapterProtocol> juAdapter;
//缓存磁盘路径
@property(nonatomic,strong) NSString *diskCachePath;

@property(nonatomic,strong) NSString *urlPath;//ulr路径

@property(nonatomic,strong) NSDictionary *parameter;//参数
//刷新时间
@property(nonatomic,assign) NSTimeInterval minRefresh;
//缓存策略
@property(nonatomic,assign) CacheStoragePolicy cachePolicy;
//过期保留时间
//@property (nonatomic, assign) NSTimeInterval minCacheInterval;
@end


@implementation JUURLCache

@synthesize diskCachePath,urlPath=_urlPath;

+(id)initWithPath:(NSString *)path parameter:(NSDictionary *)para{
    return [[self alloc]initWithPath:path parameter:para adapter:[[JuBaseCacheAdapter alloc]init]];
}
+(id)initWithPath:(NSString *)path parameter:(NSDictionary *)para adapter:(id<JuCacheAdapterProtocol>)dapter{
    return [[self alloc]initWithPath:path parameter:para adapter:dapter];
}

-(id)initWithPath:(NSString *)path parameter:(NSDictionary *)para adapter:(id<JuCacheAdapterProtocol>)dapter{
    self=[super init];
    if (self) {
        self.diskCachePath=[JUURLCache defaultCachePath];
        self.juAdapter=dapter;
//        _cachePolicy=JuCacheNotPolicy;
        self.urlPath=path;
        self.parameter=para;
    }
    return self;
}

-(void)setUrlPath:(NSString *)urlPath{
    _urlPath=urlPath;
    CGFloat minTime=[self.juAdapter juMinRefresh:urlPath];
    if (minTime) {
        self.minRefresh=minTime;
    }
}
-(void)setMinRefresh:(NSTimeInterval)minRefresh{
    _minRefresh=minRefresh;
    if (_minRefresh>0) {///< 时间大于零有缓存
        self.cachePolicy=JuCacheRoutineCachePolicy;
    }
}
/**去除公用参数*/
-(void)setParameter:(NSDictionary *)parameter{
    _parameter=parameter;
    urlPara=[NSMutableString string];
    for (NSString *str in [parameter allKeys]) {
        if (![[self.juAdapter juNoEncryptKeys] containsObject:str]) {
            [urlPara appendFormat:@"%@=%@&",str,parameter[str]];
        }
    }
}

- (NSString *)cacheKeyForURL{
    NSString  *strurl=[[NSString stringWithFormat:@"%@%@",_urlPath,urlPara] stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet characterSetWithCharactersInString:@""].invertedSet];
    const char *str = [strurl UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (unsigned int)strlen(str), r);
    NSString *strFileName=[NSString stringWithFormat:@"%@_%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",@"Ju", r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return strFileName;
}
//（写）
- (void)juSaveCacheData:(id)response{

    if(self.cachePolicy==JuCacheNotPolicy)return;

    id objData=[self.juAdapter juGetNetData:response];

    if(objData){
        [self createDiskCachePath];
        //    存储文件
        NSData *dataDic =  [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:nil];///< 转换成Data写文件
        if (![dataDic writeToFile:[self.diskCachePath stringByAppendingPathComponent:[self cacheKeyForURL]] atomically:YES]){
            NSLog(@"缓存失败");
            return;
        }
        NSMutableDictionary *dicCacheHead=[self HeadProperty];
        //    文件存储属性
        BOOL rhead=  [dicCacheHead writeToFile:[self.diskCachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@ heads",[self cacheKeyForURL]]]atomically:YES];
        if (!rhead) {
            NSLog(@"头文件写入失败");
        }
    }
}
//（读）返回YES不请求网络
-(BOOL)juGetCache:(BOOL)netConnection withData:(void(^)(id result))cacheResult {

    if(self.cachePolicy==JuCacheNotPolicy)return NO;

    BOOL isUseCache=[self isCached]; //    判断是否有缓存 (是否过期,无网络)
    if (!isUseCache) {///< 无缓存直接返回
        return NO;
    }
    //    有缓存做一下操作
    //    第一步判断是否有网络
    BOOL loadCacheData= isUseCache; ///<     页面无数据需预先加载缓存数据（第一页先使用过期数据）
    if (netConnection) {///< 有网络 (无网络直接用缓存)
        NSDate *date=[NSDate date];
        NSDictionary *dic=[self getHeadData];
        if (!dic)return NO;
        NSTimeInterval timecurret= [date timeIntervalSinceDate:[self dateFromHttpDateString:[NSString stringWithFormat:@"%@",dic[JuDate]]]];
        //    第二步判断缓存是否过期
        if ([dic[JuMinRefresh]floatValue]<timecurret) {//  判断是否该重新刷新(缓存过期，缓存未过期直接使用缓存)
            isUseCache=NO;
            //    第三步判断是否需要预先加载缓存
            if (self.cachePolicy==JuCacheCacheExpiredPolicy) {
                loadCacheData=NO;
            }
            else if ([_parameter[[self.juAdapter juEnptyKey]] intValue]||[_parameter[[self.juAdapter juPageIndexKey]] intValue]){///< 分页数据时不是第一页 或者已经有数据
                // 页面已有数据，不加载缓存数据，
                loadCacheData=NO;
            }
        }
    }
    if (loadCacheData) {
        cacheResult([self juGetCached]);
    }
    return isUseCache;
}


//添加头文件属性
-(NSMutableDictionary *)HeadProperty{
    NSDateFormatter  *dateformatter=CreateDateFormatter(@"EEE, dd MMM yyyy HH:mm:ss z");
    NSString *  locationString=[dateformatter stringFromDate:[NSDate date]];
    NSMutableDictionary *dicCacheHead=[NSMutableDictionary dictionary];
    [dicCacheHead setObject:locationString forKey:JuDate];
    [dicCacheHead setObject:[NSNumber numberWithInteger:_cachePolicy] forKey:JuCachePolicy];
    [dicCacheHead setObject:_urlPath forKey:@"url"];
    //    [dicCacheHead setObject:[NSNumber numberWithDouble:_minCacheInterval] forKey:MinCacheInterval];
    [dicCacheHead setObject:[NSNumber numberWithDouble:_minRefresh] forKey:JuMinRefresh];
    return dicCacheHead;
}


-(BOOL)isCached{
    NSString *filepath=[self.diskCachePath stringByAppendingPathComponent:[self cacheKeyForURL]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filepath];
}
/**缓存内容*/
-(id)juGetCached{
    NSString *filepath=[self.diskCachePath stringByAppendingPathComponent:[self cacheKeyForURL]];
    NSData *data=[NSData dataWithContentsOfFile:filepath];
    if (data) {
        return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    }
    return nil;
//    return [NSDictionary dictionaryWithContentsOfFile:filepath];
}
/**头文件内容*/
-(id)getHeadData{
    NSString *filepath=[self.diskCachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@ heads",[self cacheKeyForURL]]];
    return [NSDictionary dictionaryWithContentsOfFile:filepath];
}

- (void)createDiskCachePath
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if (![fileManager fileExistsAtPath:diskCachePath])
    {
        [fileManager createDirectoryAtPath:diskCachePath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:NULL];
    }
}
+ (NSString *)defaultCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:JuConfigurationPlist];
}
-(NSDate *)dateFromHttpDateString:(NSString *)httpDate
{
    static NSDateFormatter *RFC1123DateFormatter;
    static NSDateFormatter *ANSICDateFormatter;
    static NSDateFormatter *RFC850DateFormatter;
    NSDate *date = nil;
    @synchronized(self) // NSDateFormatter isn't thread safe
    {
        // RFC 1123 date format - Sun, 06 Nov 1994 08:49:37 GMT
        if (!RFC1123DateFormatter) RFC1123DateFormatter = CreateDateFormatter(@"EEE, dd MMM yyyy HH:mm:ss z");
        date = [RFC1123DateFormatter dateFromString:httpDate];
        if (!date)
        {
            // ANSI C date format - Sun Nov  6 08:49:37 1994
            if (!ANSICDateFormatter) ANSICDateFormatter = CreateDateFormatter(@"EEE MMM d HH:mm:ss yyyy") ;
            date = [ANSICDateFormatter dateFromString:httpDate];
            if (!date)
            {
                // RFC 850 date format - Sunday, 06-Nov-94 08:49:37 GMT
                if (!RFC850DateFormatter) RFC850DateFormatter = CreateDateFormatter(@"EEEE, dd-MMM-yy HH:mm:ss z") ;
                date = [RFC850DateFormatter dateFromString:httpDate];
            }
        }
    }
    
    return date;
}

static NSDateFormatter* CreateDateFormatter(NSString *format)
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:locale];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [dateFormatter setDateFormat:format];
    return dateFormatter;
}
//-(void)dealloc{
//    NSLog(@"释放了");
//}
+(void)juRemoveURLCache{
    [[NSFileManager new] removeItemAtPath:[self  defaultCachePath] error:nil];
}
@end
