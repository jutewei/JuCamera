//
//  JuBarButton.m
//  PABase
//
//  Created by Juvid on 2018/11/27.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuBarButton.h"
#import "UIView+textBounds.h"
#import "NSObject+JuEasy.h"
#import "UIView+Frame.h"
//#import "UIImage+Cropping.h"
@implementation JuBarButton{
//    BOOL isFinishFix;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    /*if ([[[UIDevice currentDevice] systemVersion] floatValue]  < 11) return;
    UIView *view = self;
    while (![view isKindOfClass:UINavigationBar.class] && view.superview) {
        view = [view superview];
        if ([view isKindOfClass:UIStackView.class] && view.superview) {
            for (NSLayoutConstraint *constraint in view.superview.constraints) {
                if ([constraint.firstItem isKindOfClass:UILayoutGuide.class]) {
                    if(constraint.firstAttribute == NSLayoutAttributeTrailing){
                        constraint.constant=0;
                    }else if (constraint.firstAttribute == NSLayoutAttributeLeading){
                        constraint.constant=0;
                    }
                }
            }
            break;
        }
    }*/
}
+(NSArray <UIBarButtonItem *>*)juInitBarItems:(NSArray *)itemsName  resultHandle:(PFBTouchHandle)handle{
    NSMutableArray *arrBtnList=[NSMutableArray array];
    NSInteger items=itemsName.count;
    UIButton *btnFirst;
    for (int i=0; i<items; i++) {
        JuBarButton *btnItem=[self juInitBarItem:itemsName[i]  systemType:YES];
        if (handle) {
            handle(btnItem);
        }
        btnItem.tag=10+i;
        [arrBtnList addObject:btnItem.barButtonItem];
        if (i==0) {
            btnFirst=btnItem;
        }
        if (i==items-1){
            btnItem.sizeW+=(IOS_SYS_VERSION>=11&&IOS_SYS_VERSION<11.19)?11:5;
        }else{
            btnItem.sizeW=MAX(26, btnItem.sizeW);
        }
    }
    return arrBtnList;
}

+(JuBarButton *)juInitBarItem:(id)medium  systemType:(BOOL)isSystem{
    JuBarButton *btnItem =[JuBarButton buttonWithType:isSystem?UIButtonTypeSystem:UIButtonTypeCustom];
    if ([medium isKindOfClass:[UIImage class]]) {///<
        UIImage *image=[medium imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        btnItem.frame=CGRectMake(0, 0,MAX(26, image.size.width), 44);
        [btnItem setImage:image forState:UIControlStateNormal];
    }else{
        [btnItem setTitle:medium  forState:UIControlStateNormal];
        btnItem.frame= CGRectMake(0, 0, [btnItem boundingWidth:100], 44);
    }
    btnItem.titleLabel.font=[UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    if (!isSystem) {
        btnItem.sizeW=80;
    }
    return btnItem;
}

-(void)setImageName:(NSString *)imageName{
    [self setImage: [[UIImage imageNamed:imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
}
-(void)setTitle:(NSString *)title{
    [self setTitle:title forState:UIControlStateNormal];
}
- (void)setTitleColor:(nullable UIColor *)color{
    [self setTitleColor:color forState:UIControlStateNormal];
}
- (void)addTarget:(nullable id)target action:(SEL)action forAlignment:(UIControlContentHorizontalAlignment)alignment{
    [self setContentHorizontalAlignment:alignment];
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
