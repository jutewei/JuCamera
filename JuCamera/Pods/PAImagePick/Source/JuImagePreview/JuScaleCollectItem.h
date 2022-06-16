//
//  JuZoomScaleImageView.h
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JuImageObject.h"
#import "JuScaleAlbumItem.h"

@protocol JuScaleViewDelegate <NSObject>

@optional
/**
 当前预览坐标
 */
-(CGRect)juCurrentRect;

-(void)juTapHidder;

-(void)juChangeSacle:(CGFloat)scale;

-(BOOL)juNotMoveHidder;

@end


@interface JuScaleCollectItem : JuScaleAlbumItem

@property (nonatomic,assign) id<JuScaleViewDelegate> ju_delegate;

-(void)setItemData:(id)data
      originalRect:(CGRect)originalRect;


@end
