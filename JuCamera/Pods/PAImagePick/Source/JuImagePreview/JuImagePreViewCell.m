//
//  JuImagesCollectCell.m
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuImagePreViewCell.h"
#import "JuScaleCollectItem.h"
#import "JuLayoutFrame.h"

@implementation JuImagePreViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        ju_scaleView=[[JuScaleCollectItem alloc]init];
        ju_scaleView.ju_delegate=self;
        [self.contentView addSubview:ju_scaleView];
        ju_scaleView.juEdge(UIEdgeInsetsMake(0, 0, 0, 20));
        [self.contentView layoutIfNeeded];
    }
    return self;
}

-(void)juSetContentHidden:(BOOL)isHidden{
    ju_scaleView.hidden=isHidden;
}

-(void)juSetImage:(id)imageData originalFrame:(CGRect)frame{
    ju_scaleView.hidden=NO;
    ju_scaleView.ju_delegate=self.ju_delegate;
    [ju_scaleView setItemData:imageData originalRect:frame];
}

-(void)juSetFullImage{
    [ju_scaleView juSetFullImage];
}

@end
