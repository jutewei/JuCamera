//
//  PAImageDeal.m
//  PAImageEdit
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/7/22.
//

#import "PAImageDeal.h"
#import "JuFileManage.h"
#import <Photos/Photos.h>

//#define PAImageHighWid    3024
#define GTZ(A,B)    ((A) > (0) ? (A) : (B))

@implementation PAImageDeal

+(NSDictionary *)zlSetImageModel:(PAImageDealModel *)imageM{
    NSData *data=[self zlCompressImage:imageM];
    NSString *path=[JuFileManage juSaveCacheData:data folder:@"PAAlbumCache" suffix:@"jpg"];
    if (!path) {
        return @{};
    }
    UIImage *image=[UIImage imageWithData:data];
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    NSURL *pathUrl=[NSURL fileURLWithPath:path];
    [dic setValue:pathUrl.absoluteString forKey:@"url"];
    [dic setValue:@(data.length/(1024*1024.0)) forKey:@"dataSize"];
    [dic setValue:@(image.size.width) forKey:@"width"];
    [dic setValue:@(image.size.height) forKey:@"height"];
    return dic;
}

+(NSData *)zlCompressImage:(PAImageDealModel *)imageM{
    if (!imageM) {
        return nil;
    }
    NSData *data=[self zlGetImageData:imageM.zl_image type:imageM.zl_type sideSize:imageM.zl_sideSize quality:imageM.zl_quality/100.0];
    return data;
}

+(UIImage *)zlSetImageData:(id)imageData
                      type:(PAImageCompressType)type
                  sideSize:(CGFloat)sideSize
                   quality:(CGFloat)quality{
    return [UIImage imageWithData:[self zlGetImageData:imageData type:type sideSize:sideSize quality:quality]];
}

+(NSData *)zlGetImageData:(id)imageData
                      type:(PAImageCompressType)type
                  sideSize:(CGFloat)sideSize
                  quality:(CGFloat)quality{
    
    if (!imageData) return nil;
    
    __block UIImage *images;
    if ([imageData isKindOfClass:[NSData class]]) {
        images=[UIImage imageWithData:imageData];
    }
    else if ([imageData isKindOfClass:[PHAsset class]]) {
        [self juRequestImageForAsset:imageData handle:^(UIImage *image) {
            images=image;
        }];
    }else{
        images=imageData;
    }
    CGFloat dataLength=images.imageLenght;
    NSLog(@"原图大小: %.3fM", dataLength);
    CGFloat scale=dataLength>0.3?0.84:1;
    CGFloat lastSize=PAImageDefaultWid;
    switch (type) {
        case PAImageCompressTypeAuto:{
            if (dataLength>2) {///
                images=[images zlSetMinSide:lastSize];
                dataLength=images.imageLenght;
            }
            if (dataLength>0.3) {
                CGFloat base=MAX(dataLength-1, 0);
                scale=MAX(0.25,0.65-base*.09);
            }
        }
            break;
        case PAImageCompressTypeMinSide:{
            lastSize=sideSize>0?sideSize:lastSize;
            images=[images zlSetMinSide:lastSize];
            if (quality>0) {
                scale=quality;
            }
            else if(images.imageLenght>0.3){
                scale=0.5;
            }
        }
            break;
        case PAImageCompressTypeMaxSide:{
            lastSize=sideSize>0?sideSize:lastSize;
            images=[images zlSetMaxSide:lastSize];
            if (quality>0) {
                scale=quality;
            }
            else if (images.imageLenght>0.3) {
                scale=0.5;
            }
        }
            break;
        case PAImageCompressTypeHigh:
//            高清图
            lastSize=sideSize;
            images=[images zlSetMinSide:lastSize];
            scale=quality;
            break;
        case PAImageCompressTypeNone:
//            原图
            lastSize=0;///打印参数
            break;
    }
        
    NSData *dataImage= UIImageJPEGRepresentation(images, scale);
    NSLog(@"压缩参数: %f %f 。压缩后大小: %.3fM",scale,lastSize,dataImage.length/(1024.*1024));
    return dataImage;
}


/**
 获取相册图片

 @param asset 图片尺寸
 @param imageHandle 返回图片
 */
+(void)juRequestImageForAsset:(PHAsset *)asset handle:(void(^)(UIImage *image))imageHandle {
    PHImageRequestOptions *imageOptions = [[PHImageRequestOptions alloc] init];
    imageOptions.synchronous = YES;///< 同步
    imageOptions.networkAccessAllowed = YES;
    imageOptions.resizeMode=PHImageRequestOptionsResizeModeFast;///< 精准尺寸
    CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
    // 请求图片
    [[PHImageManager defaultManager] requestImageForAsset:(PHAsset *)self targetSize:size contentMode:PHImageContentModeAspectFill options:imageOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(),^{
            imageHandle(result);
        });
    }];
}

@end
