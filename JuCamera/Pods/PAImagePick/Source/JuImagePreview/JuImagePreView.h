//
//  JuImagesCollectView.h
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JuPhotoConfig.h"
#import "JuScaleCollectItem.h"
#import "JuScaleCollectView.h"

@protocol JuImagePreViewDelegate <JuScaleViewDelegate>

@optional

-(CGRect)juRectIndex:(NSInteger)index;

-(void)juCurrentIndex:(NSInteger)index;

@end


@interface JuImagePreView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,readonly)JuScaleCollectView *ju_collectView;

@property (nonatomic,weak) id<JuImagePreViewDelegate> ju_delegate;

@property (nonatomic,assign)BOOL ju_canEdit;

/**
 设置图片

 @param arrList arrlist可为string、JuImageObject、PHAsset、ALAsset
 @param index 当前第几张
 @param frame 小图坐标
 */
- (void)juSetImages:(NSArray *)arrList
      cIndex:(NSInteger)index
              rect:(CGRect)frame;

- (void)changeFrame:(id)sender;

-(void)juDeleteIndex:(NSInteger)index;

@end
