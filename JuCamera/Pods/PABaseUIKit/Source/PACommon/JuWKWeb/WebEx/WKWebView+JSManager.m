//
//  WKWebView+JSManager.m
//  JuCycleScroll
//
//  Created by Juvid on 2018/12/14.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "WKWebView+JSManager.h"
#import <objc/runtime.h>
@implementation WKWebView (JSManager)

-(void)setSh_arrImgList:(NSArray *)sh_arrImgList{
    objc_setAssociatedObject(self, @selector(sh_arrImgList), sh_arrImgList, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSArray *)sh_arrImgList{
    return objc_getAssociatedObject(self, @selector(sh_arrImgList));
}
-(void)shGetImageUrlByJS:(void (^)(void))handle{
    //js方法遍历图片添加点击事件返回图片个数
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgUrlStr='';\
    for(var i=0;i<objs.length;i++){\
    var objParent = objs[i].parentNode;\
    if (objParent != undefined && objParent != null && objParent.tagName.toUpperCase() != 'A'){\
    if(i==0){\
    if(objs[i].alt==''){\
    imgUrlStr=objs[i].src;\
    }\
    }else{\
    if(objs[i].alt==''){\
    imgUrlStr+='#'+objs[i].src;\
    }\
    }\
    }\
    objs[i].onclick=function(){\
    if(this.alt==''){\
    document.location=\"juwebimageclick:\"+this.src;\
    }\
    };\
    };\
    return imgUrlStr;\
    };";
    //用js获取全部图片 添加方法
    [self evaluateJavaScript:jsGetImages completionHandler:^(id Result, NSError * error) {

    }];
    NSString *js2=@"getImages()";///获取图片
    [self evaluateJavaScript:js2 completionHandler:^(id Result, NSError * error) {
        NSString *resurlt=[NSString stringWithFormat:@"%@",Result];
        if([resurlt hasPrefix:@"#"]){
            resurlt=[resurlt substringFromIndex:1];
        }
        self.sh_arrImgList=[resurlt componentsSeparatedByString:@"#"];
        if (handle) {
            handle();
        }
    }];
}


-(BOOL)shPreviewImageReq:(NSURLRequest *)request imgUrls:(NSArray *)imgUrls{
    static NSDate *sh_clickDate=nil;
    NSTimeInterval spaceTime= [[NSDate date] timeIntervalSinceDate:sh_clickDate];
    sh_clickDate=[NSDate date];
    //将url转换为string
    NSURL *url = [request URL];
    NSLog(@"请求地址：%@",url);
    //hasPrefix 判断创建的字符串内容是否以pic:字符开始
    if ([url.scheme isEqual:@"juwebimageclick"]){
        if (spaceTime>1) {
//            NSString *imageUrl = [url.absoluteString substringFromIndex:@"juwebimageclick:".length];
//            NSInteger index=[imgUrls indexOfObject:imageUrl];
//            SHPreviewBigPhotos *changImg=[SHPreviewBigPhotos shInit];
//            [changImg shSetImages:imgUrlArr currentIndex:index];
        }
        return YES;
    }
    return NO;
}

-(void)shRemoveWebCache{
    //    iOS9 WKWebView新方法：
    NSSet *websiteDataTypes = [NSSet setWithArray:@[WKWebsiteDataTypeDiskCache,WKWebsiteDataTypeOfflineWebApplicationCache,WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeLocalStorage,WKWebsiteDataTypeCookies,WKWebsiteDataTypeSessionStorage,WKWebsiteDataTypeIndexedDBDatabases,WKWebsiteDataTypeWebSQLDatabases]];
    //你可以选择性的删除一些你需要删除的文件 or 也可以直接全部删除所有缓存的type
    //NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes
                                               modifiedSince:dateFrom completionHandler:^{
                                                   // code
                                               }];

    //    针对与iOS7.0、iOS8.0、iOS9.0 WebView的缓存，我们找到了一个通吃的办法:

    NSString *libraryDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                               NSUserDomainMask, YES)[0];
    NSString *bundleId  =  [[[NSBundle mainBundle] infoDictionary]
                            objectForKey:@"CFBundleIdentifier"];
    NSString *webkitFolderInLib = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
    NSString *webKitFolderInCaches = [NSString
                                      stringWithFormat:@"%@/Caches/%@/WebKit",libraryDir,bundleId];
    NSString *webKitFolderInCachesfs = [NSString
                                        stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryDir,bundleId];

    NSError *error;
    /* iOS8.0 WebView Cache的存放路径 */
    [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];

    /* iOS7.0 WebView Cache的存放路径 */
    [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCachesfs error:&error];

    //    H5更新发版的的时候，做一次清除WebView缓存， app的WebView就会显示最新的H5页面了。

}


@end
