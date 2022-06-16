//
//  JuPhotoCollectionVCell.m
//  JuPhotoBrowser
//
//  Created by Juvid on 16/9/21.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JuPhotoPickerCell.h"
#import "JuLayoutFrame.h"
#import "JuPhotoOverlayView.h"
#import "JuPhotoConfig.h"
#import "JuAlbumManage.h"
#import "PHAsset+juDeal.h"

@interface JuPhotoPickerCell (){
    UILabel *ju_labTime;
    JuPhotoOverlayView *ju_overlayView;
}
@property (nonatomic,strong)   UIImageView *ju_imageView;

@end

@implementation JuPhotoPickerCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        self.contentView.backgroundColor=Photo_BackColor;
        _ju_imageView=[[UIImageView alloc]init];
        [self.contentView addSubview:_ju_imageView];
        [_ju_imageView setContentMode:UIViewContentModeScaleAspectFill];
        [_ju_imageView setClipsToBounds:YES];
        _ju_imageView.juEdge(UIEdgeInsetsMake(0, 0, 0, 0));

        ju_labTime =[[UILabel alloc]init];
        ju_labTime.textColor=[UIColor whiteColor];
        ju_labTime.font=[UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
//        ju_labTime.text=@"0:00";
        [self.contentView addSubview:ju_labTime];
        ju_labTime.juOrigin(CGPointMake(-3, -3));
        
        __weak typeof(self) weakSelf=self;
        ju_overlayView=[[JuPhotoOverlayView alloc]init];
        ju_overlayView.ju_handle = ^(BOOL isSelect) {
            [weakSelf juSetSelected:isSelect];
        };
        [self.contentView addSubview:ju_overlayView];
        ju_overlayView.juEdge(UIEdgeInsetsMake(0, 0, 0, 0));
    }

    return self;
}
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
}

-(void)juSetSelected:(BOOL)selected{
    _ju_asset.isSelect=selected;
    _ju_asset.isOriginal=NO;
    if (self.ju_assetHandle) {
        self.ju_assetHandle(_ju_asset);
    }
}

-(void)setJu_asset:(PHAsset *)ju_asset{
    _ju_asset=ju_asset;
    ju_overlayView.isSelect=ju_asset.isSelect;
    
    if (ju_asset.mediaType==PHAssetMediaTypeVideo&&_ju_allowVideo) {/// 时间格式化
        ju_labTime.text=ju_asset.juGetTime;
    }else{
        ju_labTime.text=@"";
    }
//    ju_overlayView.hidden=_ju_singleSelect;
    if (ju_asset.isNetwork) {
        _ju_imageView.image=nil;
    }
    __weak typeof(self) weakSelf = self;
    [ju_asset juRequestImageSize:CGSizeMake(140, 140) isAsyn:YES handle:^(UIImage * _Nonnull image) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.ju_imageView.image=image;
    }];
}

@end
