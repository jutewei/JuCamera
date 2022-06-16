//
//  JuTopBarView.h
//  JuLayout
//
//  Created by Juvid on 2017/10/27.
//  Copyright © 2017年 Juvid(zhutianwei). All rights reserved.
//

#import <UIKit/UIKit.h>

@class JuLargeTitleView;

@interface JuTopBarView : UIView

+(instancetype)initWithVC:(UIViewController *)supVC;

@property (nonatomic,strong) NSString *title;

@property (nonatomic,copy) UIColor *ju_showColor;
@property (nonatomic,copy) UIColor *ju_backColor;

@property (nonatomic,copy) UIImage *ju_backImage;

@property (nonatomic,copy) UIView *ju_titleView;
@property (nonatomic,copy) JuLargeTitleView *ju_largeView;

//@property (nonatomic,copy) id ju_largeTitles;
@property (nonatomic,assign) CGFloat ju_alpha;
@property (nonatomic,assign) BOOL isShow;
-(void)setLargeTitles:(id)ju_largeTitles withHeight:(CGFloat)height;
- (void)juViewWillTransitionToSize:(CGSize)size;
@end


//大标题
@interface JuLargeTitleView : UIView
@property (nonatomic,readonly)UIView *ju_contentView;
@property (nonatomic,readonly)UILabel *ju_labTitle;
@property (nonatomic,readonly)UIImageView *ju_imageView;
+(instancetype)initWithData:(id)largeTitles withHeight:(CGFloat)height;
-(BOOL)scrollViewDidScroll:(UIScrollView *)scrollView;
@end


//大标题背景
@interface JuTitleTopEdgeView : UIView
+(instancetype)initTopView;
@end
