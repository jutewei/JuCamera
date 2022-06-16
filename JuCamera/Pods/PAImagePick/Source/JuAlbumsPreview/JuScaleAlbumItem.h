//
//  JuZoomScaleImageView.h
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JuScaleScrollView.h"

@interface JuScaleAlbumItem : JuScaleScrollView

@property (nonatomic,copy)dispatch_block_t ju_tapHandle;

-(void)setItemData:(id)data;

//设置大图
-(void)juSetFullImage;

@end
