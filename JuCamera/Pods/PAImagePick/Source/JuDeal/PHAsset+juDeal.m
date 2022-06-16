//
//  PHAsset+deal.m
//  PAImagePick
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2022/3/31.
//

#import "PHAsset+juDeal.h"
#import <objc/runtime.h>
#import "JuVideoEditManage.h"
#import "AVAsset+compress.h"

@implementation PHAsset (juDeal)

-(void)setIsOriginal:(BOOL)isOriginal{
    NSNumber *number = [[NSNumber alloc] initWithBool:isOriginal];
    objc_setAssociatedObject(self, @selector(isOriginal), number, OBJC_ASSOCIATION_COPY);
}

-(BOOL)isOriginal{
    return [objc_getAssociatedObject(self, @selector(isOriginal)) boolValue];
}

-(void)setIsSelect:(BOOL)isSelect{
    NSNumber *number = [[NSNumber alloc] initWithBool:isSelect];
    objc_setAssociatedObject(self, @selector(isSelect), number, OBJC_ASSOCIATION_COPY);
}
-(BOOL)isSelect{
    return [objc_getAssociatedObject(self, @selector(isSelect)) boolValue];
}

/// 是否需要网络下载
- (BOOL)isNetwork{
//    fileName = [self valueForKey:@"filename"];
    // asset是一个您想要为其获取信息的PHAsset对象
    NSArray *resourceArray = [PHAssetResource assetResourcesForAsset:self];
    if (resourceArray.count > 0){
        ///本地是否可用：NO 代表icould 图片
        // If this returns NO, then the asset is in iCloud and not saved locally yet
        PHAssetResource *resource=resourceArray.firstObject;
        BOOL locallyAvailable=[[resource valueForKey:@"locallyAvailable"] boolValue];
//        NSURL *URL=[resource valueForKey:@"privateFileURL"];
        return !locallyAvailable;
    }
    return NO;
}
/**
 获取图片

 @param targetSize 图片尺寸
 @param imageHandle 返回图片
 */

-(void)juRequestImageSize:(CGSize)targetSize
                   handle:(void(^)(UIImage *image))imageHandle {
    [self juRequestImageSize:targetSize isAsyn:NO handle:imageHandle];
}

-(void)juRequestImageSize:(CGSize)targetSize
                   isAsyn:(BOOL)isAsyn
                   handle:(void(^)(UIImage *image))imageHandle{
    PHImageRequestOptions *imageOptions = [[PHImageRequestOptions alloc] init];
    if (isAsyn&&self.isNetwork) {
//        if (imageHandle&&targetSize.width<900) imageHandle(nil);
        imageOptions.synchronous = NO;///< 异步
    }else{
        imageOptions.synchronous = YES;///< 同步
    }
    imageOptions.networkAccessAllowed = YES;
    imageOptions.resizeMode=PHImageRequestOptionsResizeModeFast;///< 精准尺寸
    // 请求图片
//    if (CGSizeEqualToSize(targetSize, CGSizeZero)) {
//        [[PHImageManager defaultManager]requestImageDataForAsset:(PHAsset *)self  options:imageOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
//            dispatch_async(dispatch_get_main_queue(),^{
//                UIImage *image=[UIImage imageWithData:imageData];
//                imageHandle(imageData);
//            });
//        }];
//    }else{
        [[PHImageManager defaultManager] requestImageForAsset:self targetSize:targetSize contentMode:PHImageContentModeAspectFill options:imageOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(),^{
                imageHandle(result);
            });
        }];
//    }
}
//请求image data
-(void)juRequestData:(PHAssetVideoProgressHandler)progress
                handle:(void (^)(NSData *result))handle{
    PHImageRequestOptions *imageOptions = [[PHImageRequestOptions alloc] init];
    if (self.isNetwork) {
        imageOptions.synchronous = NO;///< 异步
    }else{
        imageOptions.synchronous = YES;///< 同步
    }
    imageOptions.networkAccessAllowed = YES;
    imageOptions.progressHandler = progress;
    imageOptions.resizeMode=PHImageRequestOptionsResizeModeFast;///< 精准尺寸
    [[PHImageManager defaultManager]requestImageDataForAsset:(PHAsset *)self  options:imageOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(),^{
            if (handle) {
                handle(imageData);
            }
        });
    }];
}

-(void)juRequestVideo:(BOOL)isFast
             progress:(JuProgresHandle)progress
               handle:(JuVideoHandle)handle{
    [self juRequestVideoPreset:AVAssetExportPreset1280x720 isFast:isFast progress:progress handle:handle];
}


-(void)juRequestVideoPreset:(NSString*)presetName
                       isFast:(BOOL)isFast
                   progress:(JuProgresHandle)progress
                     handle:(JuVideoHandle)handle{
    PHVideoRequestOptions* options = [[PHVideoRequestOptions alloc] init];
    options.version = PHVideoRequestOptionsVersionOriginal;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    options.networkAccessAllowed = NO;
    [[PHImageManager defaultManager]requestAVAssetForVideo:self options:options resultHandler:^(AVAsset * _Nullable avAsset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
//        AVURLAsset *urlAsset=(AVURLAsset *)avAsset;
//        NSString *url=[NSObject juSwitchFilePath:urlAsset.URL.absoluteString];
        [avAsset juExportWithPreset:presetName isFast:isFast progress:progress handle:handle];
    }];
}


-(void)juRequestPlayer:(PHAssetVideoProgressHandler)progress
                handle:(void (^)(AVPlayerItem *result))handle{
    PHVideoRequestOptions* options = [[PHVideoRequestOptions alloc] init];
    options.version = PHVideoRequestOptionsVersionOriginal;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    options.networkAccessAllowed = NO;
    options.progressHandler = progress;
    [[PHImageManager defaultManager]requestPlayerItemForVideo:self options:options resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handle) {
                handle(playerItem);
            }
        });
    }];
}

-(NSString *)juGetTime{
    CGFloat times=self.duration;
    NSInteger minute =times/60;
    CGFloat second =times-minute*60;
    NSString *strSecond=[NSString stringWithFormat:@"%.0f",second];
    if (strSecond.intValue<10) {
        strSecond=[NSString stringWithFormat:@"0%.0f",second];
    }
    return [NSString stringWithFormat:@"%@:%@",@(minute),strSecond];
}

@end


@implementation AVAsset (juDeal)

+(void)juGetVideoPathWithURL:(NSURL *)movUrl
                  presetName:(NSString *)presetName
                      isFast:(BOOL)isFast
                    progress:(JuProgresHandle)progress
                      handle:(JuVideoHandle)handle{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    [avAsset juExportWithPreset:presetName isFast:isFast progress:progress handle:^(BOOL success, NSString *result) {
        if (!handle)  return;
        if (success) {
            handle(success,result);
        }else{
            handle(YES,[movUrl.absoluteString juGetUrlPath]);
        }
    }];
}

- (void)juExportWithPreset:(NSString *)presetName
                    isFast:(BOOL)isFast
                  progress:(JuProgresHandle)progress
                    handle:(JuVideoHandle)handle{
    if (isFast) {
        [self juExportWithPreset:presetName progress:progress handle:handle];
    }else{
        [self juCompressWithAsset:presetName progress:progress handle:handle];
    }
}

@end

@implementation NSObject (file)

#pragma mark - 存储PDF文件
+(NSString *)juSwitchFilePath:(NSString *)strUrl {
    if (![strUrl isKindOfClass:[NSString class]]||strUrl.length==0) {
        return nil;
    }
//    strUrl=[strUrl stringByReplacingOccurrencesOfString:@"file://" withString:@""];
//    NSURL *saveUrl;
//    if ([strUrl hasPrefix:@"file://"]) {
//        saveUrl=[NSURL URLWithString:strUrl];
//    }else{
//        saveUrl= [NSURL fileURLWithPath:strUrl];
//    }
//    NSString *outputPath=[self juGetTmpPath:strUrl.pathExtension];
//    NSData *fileData = [NSData dataWithContentsOfURL:saveUrl options:NSDataReadingMappedIfSafe error:nil];
//    BOOL isSuccess= [[NSFileManager defaultManager] createFileAtPath:outputPath
//                                                            contents:fileData
//                                                          attributes:nil];
//    if (isSuccess) {
//        return outputPath;
//    }
    NSError *error;
    BOOL retVal=YES;
    NSString * sourceUrl = [strUrl juGetUrlPath];
    NSString *outputPath = [sourceUrl  juGetTmpPath];
//    NSString *outputPath=[self juGetTmpPath:strUrl.pathExtension];
    if (![[NSFileManager defaultManager] fileExistsAtPath:outputPath]){
        retVal = [[NSFileManager defaultManager] copyItemAtPath:sourceUrl toPath:outputPath error:&error];
    }
    if (retVal) {
        return outputPath;
    }
    return nil;
}


+(NSString *)juGetTmpPath:(NSString *)pathExtension{
//    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
//    [formater setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *dateStr = [NSString stringWithFormat:@"%@",@([NSDate date].timeIntervalSince1970)];
    dateStr = [dateStr stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *outputPath = [NSTemporaryDirectory() stringByAppendingFormat:@"mediaOutput%@.%@",dateStr,pathExtension];
    return outputPath;
}


+(CGFloat)juGetFileSize:(NSString *)path{
    return  [[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil] fileSize];
}

@end

@implementation NSString (file)

-(NSString *)juGetUrlPath{
    return [[self stringByReplacingOccurrencesOfString:@"file://" withString:@""] stringByRemovingPercentEncoding];
}

-(NSString *)juGetTmpPath{
    if ([self hasPrefix:NSTemporaryDirectory()]) {
        return [NSTemporaryDirectory() stringByAppendingFormat:@"%@",[self lastPathComponent]];
    }
    return [NSString juGetTmpPath:self.pathExtension];
}

@end
