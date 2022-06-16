//
//  JuZoomScaleImageView.h
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JuPhotoConfig.h"
#import <Photos/Photos.h>



@interface JuScaleScrollView : UIScrollView<UIScrollViewDelegate>{
    CGRect ju_originRect;///初始位置
}


@property (nonatomic,strong) UIImageView *ju_imgView;

//设置图片展开
- (void) setItemFrameWithImage:(UIImage *)image;

@end
