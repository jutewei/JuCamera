//
//  JuPhotoOverlayView.m
//  JuPhotoBrowser
//
//  Created by Juvid on 16/9/22.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JuPhotoOverlayView.h"
#import "JuLayoutFrame.h"
#import "JuPhotoConfig.h"
@interface JuPhotoOverlayView (){
    UIButton *ju_btnSelect;
}

@end

@implementation JuPhotoOverlayView
-(instancetype)init{
    self=[super init];
    if (self) {
        [self shSetView];
    }
    return self;
}
-(void)shSetView{
    ju_btnSelect =[[UIButton alloc]init];
    [ju_btnSelect addTarget:self action:@selector(juTouchSelct:) forControlEvents:UIControlEventTouchUpInside];
    [ju_btnSelect setImage:juPhotoImage(@"photo_select") forState:UIControlStateSelected];
    [ju_btnSelect setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [ju_btnSelect setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [ju_btnSelect setContentEdgeInsets:UIEdgeInsetsMake(6, 0, 0, 6)];
    [ju_btnSelect setImage:juPhotoImage(@"photo_un_select") forState:UIControlStateNormal];
    [self addSubview:ju_btnSelect];
    ju_btnSelect.juFrame(CGRectMake(-0.01, 0.01, 50, 60));
    self.isSelect=NO;
}

-(void)setIsSelect:(BOOL)isSelect{
    _isSelect=isSelect;
    ju_btnSelect.selected=isSelect;
    if (isSelect) {
        self.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
    }else{
        self.backgroundColor=[UIColor clearColor];
    }
}
-(void)juTouchSelct:(UIButton *)sender{
    ju_btnSelect.selected=!ju_btnSelect.selected;
    [self setIsSelect: ju_btnSelect.selected];
    if (self.ju_handle) {
        self.ju_handle(ju_btnSelect.selected);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
