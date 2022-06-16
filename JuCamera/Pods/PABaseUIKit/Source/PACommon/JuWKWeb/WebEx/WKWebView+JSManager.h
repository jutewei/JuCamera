//
//  WKWebView+JSManager.h
//  JuCycleScroll
//
//  Created by Juvid on 2018/12/14.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKWebView (JSManager)
@property (nonatomic,strong)  NSArray *sh_arrImgList;
/**
 获取图片地址

 @param handle 完成后调
 */
-(void)shGetImageUrlByJS:(void (^)(void))handle;



/**
 查看图片

 @param request 当前请求地址拦截
 @param imgUrls 图片地址
 @return 返回
 */
-(BOOL)shPreviewImageReq:(NSURLRequest *)request imgUrls:(NSArray *)imgUrls;

/**
 清除用户信息
 */
-(void)shRemoveWebCache;
@end

NS_ASSUME_NONNULL_END
