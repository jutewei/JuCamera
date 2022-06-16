//
//  JuLargeimageVC.h
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JuPhotoConfig.h"
#import "JuImagePreView.h"

@interface JuImagePreviewVC : UIViewController<UINavigationControllerDelegate,JuImagePreViewDelegate>

@property (nonatomic,assign)BOOL ju_canEdit;


+(instancetype)initRect:(CGRect)frame
                 images:(NSArray *)arrList
                 cIndex:(NSInteger)index
                 handle:(JuHandle)handle;

+(instancetype)initRect:(CGRect)frame
                 images:(NSArray *)arrList
                 cIndex:(NSInteger)index
              thumbSize:(CGFloat)size
                 handle:(JuHandle)handle;


@property (nonatomic,copy) JuCompletion ju_scaleHandle;

@property (nonatomic,readonly) JuImagePreView *ju_imgCollectView;

-(void)juDeleteIndex:(NSInteger)index;

-(void)juShow;

-(void)juHide;

@end
