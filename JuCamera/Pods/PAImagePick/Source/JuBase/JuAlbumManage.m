//
//  PHPhotoLibraryManage.m
//  TestImage
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/4/27.
//

#import "JuAlbumManage.h"

@implementation JuAlbumManage
+(NSMutableArray *)juFetchPhotoAlbums{
    //            最近添加
    NSMutableArray *arrAlbums=[NSMutableArray array];
    [arrAlbums addObjectsFromArray:[self juFetchRecentAlbums]];
    [arrAlbums addObjectsFromArray:[self juFetchFavoritesAlbums]];
    [arrAlbums addObjectsFromArray:[self juFetchUserAlbums]];
    return arrAlbums;
}
//PHAssetCollectionTypeSmartAlbum 系统相册
//PHAssetCollectionTypeAlbum 用户自定义相册

// 最近添加 所有相册
+(NSMutableArray *)juFetchRecentAlbums{
    PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    return [fetchResult juGetAllAlbums:YES];;
}

// 视频相册
+(NSMutableArray *)juFetchVideoAlbums{
    PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumVideos options:nil];
    return [fetchResult juGetAllAlbums:YES];
}
// 个人收藏
+(NSMutableArray *)juFetchFavoritesAlbums{
    PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumFavorites options:nil];
    return [fetchResult juGetAllAlbums:NO];
}

//用户创建的相册
+(NSMutableArray *)juFetchUserAlbums{
    PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    return [fetchResult juGetAllAlbums:NO];
}

+(void)juFetchAuth:(dispatch_block_t)handle{
    if ([PHPhotoLibrary authorizationStatus]==PHAuthorizationStatusAuthorized) {
        if (handle) handle();
        return;
    }
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handle) handle();
            });
        }
    }];
}

@end


@implementation PHFetchResult(album)

-(NSMutableArray *)juGetAllAlbums:(BOOL)isCanEmpty{
    NSMutableArray *albums=[NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
        PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        if (assetsFetchResults.count||isCanEmpty) {
            [albums addObject:collection];
        }
    }];
    return albums;
}

@end
