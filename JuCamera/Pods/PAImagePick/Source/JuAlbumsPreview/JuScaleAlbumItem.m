//
//  JuZoomScaleImageView.m
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuScaleAlbumItem.h"
#import "UIImage+PhotoManage.h"

@interface JuScaleAlbumItem(){
    //缩放前大小
    dispatch_queue_t ju_queueFullImage;
   __weak PHAsset *ju_asset;
}
@end

@implementation JuScaleAlbumItem

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        ju_queueFullImage=dispatch_queue_create("queue.getFullImage", DISPATCH_QUEUE_SERIAL);///< 串行队列
    }
    return self;
}

/**
 设置图片
 */
-(void)setItemData:(id)data{
    ju_asset=nil;
    if (!data) return;
    if ([data isKindOfClass:[UIImage class]]) {
        [self setItemFrameWithImage:data];
    }else if([data isKindOfClass:[PHAsset class]]){
        ju_asset=data;
        [self juSetDefaultImage];
        //可设置先预览小图再显示大图
    }
}

-(void)juSetDefaultImage{
    __weak typeof(self) weakSelf=self;
    [ju_asset juGetPreFullImage:^(id image) {
        [weakSelf setItemFrameWithImage:image];
//        [weakSelf juGetAssetImage];
    }];
}
//读取相册图片相册图片
-(void)juSetFullImage {
    __weak typeof(self) weakSelf=self;
    dispatch_async(ju_queueFullImage, ^{
        [self->ju_asset juGetfullScreenImage:^(UIImage *result) {
            [weakSelf setItemFrameWithImage:result];
        }];
    });
}

//隐藏
-(void)juTouchTap{
    if (self.ju_tapHandle) {
        self.ju_tapHandle();
    }
}

- (void)dealloc{
    ju_queueFullImage=nil;
}

@end
