//
//  JuPhotoOverlayView.h
//  JuPhotoBrowser
//
//  Created by Juvid on 16/9/22.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^JuSelectHandle)(BOOL isSelect);//选择

@interface JuPhotoOverlayView : UIView

@property(nonatomic) BOOL isSelect;

@property (nonatomic,copy)JuSelectHandle ju_handle;
@end
