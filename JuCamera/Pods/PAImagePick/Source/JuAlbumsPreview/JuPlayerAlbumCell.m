//
//  JuPlayerAlbumItem.m
//  PAImagePick
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2022/3/31.
//

#import "JuPlayerAlbumCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImage+PhotoManage.h"
#import "PHAsset+juDeal.h"
#import "JuLayoutFrame.h"
#import "JuPhotoConfig.h"

@implementation JuPlayerAlbumCell{
    AVPlayer *ju_player;
    AVPlayerLayer *ju_playerLayer;
    UIImageView *ju_imgCover;
    UIButton *ju_btnPlay;
    PHAsset *ju_asset;
    UIView *ju_viewBox;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        ju_viewBox=[[UIView alloc]init];
        [self.contentView addSubview:ju_viewBox];
        ju_viewBox.juEdge(UIEdgeInsetsMake(0, 0, 0, 20));

        ju_imgCover=[[UIImageView alloc]init];
        [ju_imgCover setContentMode:UIViewContentModeScaleAspectFit];
        [ju_viewBox addSubview:ju_imgCover];
        ju_imgCover.juEdge(UIEdgeInsetsMake(0, 0, 0, 0));

        ju_btnPlay=[[UIButton alloc]init];
        [ju_btnPlay addTarget:self action:@selector(juTouchPlay:) forControlEvents:UIControlEventTouchUpInside];
        [ju_btnPlay setImage:juPhotoImage(@"photo_VideoPlay") forState:UIControlStateNormal];
        [ju_viewBox addSubview:ju_btnPlay];
        ju_btnPlay.juOrigin(CGPointMake(0, 0));
    }
    return self;
}
-(void)juSetImage:(PHAsset *)imageData{
    ju_asset=imageData;
    __weak typeof(self) weakSelf = self;
    [imageData juGetPreFullImage:^(id image) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf->ju_imgCover.image=image;
    }];
}

-(void)juTouchPlay:(UIButton *)sender{
    

    if ([self juReSetPlay]) {
        if (self.ju_tapHandle) {
            self.ju_tapHandle(NO);
        }
        return;
    }
    if (self.ju_tapHandle) {
        self.ju_tapHandle(YES);
    }
    __weak typeof(self) weakSelf = self;
    [ju_asset juRequestPlayer:^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
        ;
    } handle:^(AVPlayerItem * _Nonnull result) {
        [weakSelf juStartPlay:result];
    }];
}

-(void)juStartPlay:(AVPlayerItem *)playerItem{

    [self juReSetPlay];
    
    ju_player = [AVPlayer playerWithPlayerItem:playerItem];
    ju_playerLayer = [AVPlayerLayer playerLayerWithPlayer:ju_player];
    ju_playerLayer.backgroundColor = [UIColor blackColor].CGColor;
    ju_playerLayer.frame = ju_viewBox.bounds;
    [ju_viewBox.layer addSublayer:ju_playerLayer];
    [ju_player play];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [self juTouchPlay:nil];
}

-(BOOL)juReSetPlay{
    if (ju_player) {
        [ju_playerLayer removeFromSuperlayer];
        ju_playerLayer = nil;
        [ju_player pause];
        ju_player = nil;
        return YES;
    }
    return NO;
}

@end

