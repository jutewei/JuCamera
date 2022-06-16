//
//  PHPhotoLibraryManage.h
//  TestImage
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/4/27.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "PHAsset+juDeal.h"

NS_ASSUME_NONNULL_BEGIN

@interface JuAlbumManage : NSObject
//所有相册
+(NSMutableArray *)juFetchPhotoAlbums;

//最近添加
+(NSMutableArray *)juFetchRecentAlbums;

//个人收藏
+(NSMutableArray *)juFetchFavoritesAlbums;

// 视频相册
+(NSMutableArray *)juFetchVideoAlbums;

+(void)juFetchAuth:(dispatch_block_t)handle;

@end



@interface PHFetchResult(album) 
-(NSMutableArray *)juGetAllAlbums:(BOOL)isCanEmpty;
@end

NS_ASSUME_NONNULL_END
