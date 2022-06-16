//
//  PABaseView.h
//  PABase
//
//  Created by Juvid on 2021/4/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PABaseView : UIView

-(void)zlSubViews;

-(void)zlSetContent:(id)content;

@end


@interface PABasePopupView : PABaseView

@property (nonatomic,strong) UIView *zl_contentView;
@property (nonatomic,copy) dispatch_block_t zl_handle;

+(instancetype)zlInitWithHandle:(dispatch_block_t)handle;

-(void)zlShowView;

-(void)zlHideView;

@end

NS_ASSUME_NONNULL_END
