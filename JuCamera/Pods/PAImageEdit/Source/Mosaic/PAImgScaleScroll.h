//
//  JuZoomScaleImageView.h
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "JuImgMosaicView.h"
#import "PAEditConfig.h"

@interface PAImgScaleScroll : UIView<UIScrollViewDelegate>{
    //记录自己的位置
    CGRect ju_originRect;
    UIScrollView *ju_scrollView;
}

@property (nonatomic,strong) UIView *ju_zoomView;;
@property (nonatomic,assign) BOOL isEdit;
- (void)setImage:(UIImage *)image;
@end
