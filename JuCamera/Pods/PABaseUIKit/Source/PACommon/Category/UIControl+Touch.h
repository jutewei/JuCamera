//
//  UIControl+Touch.h
//  PABase
//
//  Created by Juvid on 2017/12/6.
//  Copyright © 2017年 Juvid. All rights reserved.
//

@interface UIControl (Touch)

@property (nonatomic,assign) BOOL isEnlargeEdge;

-(void)setCanEnable:(BOOL)isEnable;

@end


@interface UITouchEdgeButton : UIButton

@end
