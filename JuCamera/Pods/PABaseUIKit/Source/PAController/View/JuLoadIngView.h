//
//  JuLoadIngView.h
//  PABase
//
//  Created by Juvid on 2017/8/23.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,JuLoadingType) {
    JuLoadingIng,
    JuLoadingSuccess,
    JuLoadingFailure,
    JuLoadingError, ///< 无地址
};

@interface JuLoadIngView : UIView
@property (assign,nonatomic)  JuLoadingType ju_loadingType;
@property (nonatomic,copy  ) dispatch_block_t ju_rereshHandle;//刷新

-(id)initWithView:(UIView *)supView;


-(void)shWhiteStatus;
@end
