//
//  JuLableImageView.h
//  JuRefresh
//
//  Created by Juvid on 16/8/11.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, JuImageAlignment) {
    JuImageAlignmentNone  = 0,// 没有imgage
    JuImageAlignmentLeft  = 1,// 左边有imgage
    JuImageAlignmentRight = 2,// 右边有imgage
    JuImageAlignmentTop   = 3,// 上边有imgage
    JuImageAlignmentBottom = 4,// 下边有imgage
};
@interface JuImageButtonView : UIButton
//@property (nonatomic) UIEdgeInsets      contentEdgeInsets;
@property (nonatomic) NSString      *imageString;
@property (nonatomic) NSString      *titleText;
@property (nonatomic) CGFloat      centerSpace;///文本和图片的间距
@property (nonatomic) CGFloat      badgeSpace;/// 边距
@property (nonatomic) NSTextAlignment   textAlignment;
@property (nonatomic) JuImageAlignment imageAlignment;
//@property (nonatomic,strong,readonly) UILabel *titleLable;
@property (nonatomic,strong,readonly) UIImageView *ju_imageView;
@end
