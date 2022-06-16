//
//  UIImageView+netImage.m
//  TestImage
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/4/27.
//

#import "UIImageView+netImage.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (netImage)

- (void)juSetImageWithURL:(nullable NSString *)url
                  iobsKey:(NSString *)iobsKey
                  progress:(nullable JuImageLoaderProgressBlock)progressBlock
                 completed:(nullable JuImageLoaderCompletedBlock)completedBlock {
    
    PAIobsImageTB *tbModel=[PAIobsImageTB zlSelectWithID:iobsKey];
    if (tbModel) {
        url=tbModel.zl_url;
    }
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageRetryFailed progress:progressBlock completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        completedBlock(image,image?YES:NO);
        if (!tbModel) {
            [PAIobsImageTB zlInsertWithID:iobsKey withUrl:url];
        }
    }];
}

+(BOOL)diskImageDataExistsWithKey:(NSString *)key{
    return [SDImageCache.sharedImageCache diskImageDataExistsWithKey:key];
}

+(UIImage *)imageFromDiskCacheForKey:(NSString *)key{
    return [SDImageCache.sharedImageCache imageFromDiskCacheForKey:key];;
}

@end


