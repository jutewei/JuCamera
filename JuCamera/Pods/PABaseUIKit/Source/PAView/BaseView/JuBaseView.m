//
//  JuBaseView.m
//  MTSkinPublic
//
//  Created by Juvid on 2018/7/9.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuBaseView.h"
#import "JuNibLoad.h"
@implementation JuBaseView{
    BOOL isSubview;
}

-(instancetype)init{
    self=[super init];
    if (self) {
        [self mtInitView];
    }
    return self;
}

-(void)mtInitView{
    if (!isSubview) {
        isSubview=YES;
        [self juSubViews];
    }
}

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self mtInitView];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self mtInitView];
}

-(void)juSubViews{

}
-(void)juSetContent:(id)content{}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation JuBaseNibView

-(instancetype)init{
    self=[super init];
    if (self) {
        self=(id)[JuNibLoad loadNib:NSStringFromClass([self class])];
        [self juSubViews];
    }
    return self;
}

-(void)juSetContent:(id)content{
    
}

-(void)juSubViews{

}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
