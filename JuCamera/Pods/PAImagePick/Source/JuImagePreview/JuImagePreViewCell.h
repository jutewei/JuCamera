//
//  JuImagesCollectCell.h
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JuScaleCollectItem.h"


@interface JuImagePreViewCell : UICollectionViewCell<JuScaleViewDelegate>{
    JuScaleCollectItem *ju_scaleView;
}

@property (nonatomic,assign) id<JuScaleViewDelegate> ju_delegate;

-(void)juSetImage:(id)imageData
    originalFrame:(CGRect)frame;

-(void)juSetContentHidden:(BOOL)isHidden;

-(void)juSetFullImage;

@end
