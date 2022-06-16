//
//  JuEqualItemView.m
//  PABase
//
//  Created by Juvid on 2018/3/23.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuMultiItemView.h"
#import "JuLayoutFrame.h"
#import "NSObject+JuEasy.h"

@implementation JuMultiItemView
+(id)juInitItems:(NSArray *)items classStr:(NSString *)classStr{
    return [self juInitItems:items classStr:classStr space:0 isEqual:JuMultiEqualW];
}
+(id)juInitItems:(NSArray *)items classStr:(NSString *)classStr space:(NSInteger )space isEqual:(JuMultiEqualType)isEqual{
    JuMultiItemView *view=[[JuMultiItemView alloc]init];
    [view juInitItems:items classStr:classStr space:space isEqual:isEqual];
    return view;
}
-(void)juInitItems:(NSArray *)items classStr:(NSString *)classStr {
    [self juInitItems:items classStr:classStr space:0 isEqual:JuMultiEqualW];
}
-(void)juInitItems:(NSArray *)items classStr:(NSString *)classStr space:(NSInteger )space isEqual:(JuMultiEqualType)isEqual{
    [self removeAllSubviews];
    NSMutableArray *arrView=[NSMutableArray array];
    NSInteger count = items.count;
    UIView *vieLast;
    for (int i=0; i<count; i++) {
        UIView *control;
        if (classStr) {
            control=[[NSClassFromString(classStr) alloc]init];
        }else{
            control=[[UIView alloc]init];
        }
        [control juSetBaseContent:items[i]];
        [arrView addObject:control];
        control.tag=i;
        [self addSubview:control];
        control.juTop.equal(0);
        control.juBottom.equal(0);

        if(isEqual==JuMultiEqualWH){
            control.juAspectWH.equal(0);
        }
        if (vieLast) {
            control.juLeaSpace.toView(vieLast).equal(space);
            if (isEqual==JuMultiEqualW) {
                control.juWidth.toView(vieLast).equal(0);
            }
        }else{
            control.juLead.equal(0);
        }
        if (i==count-1) {
            if(isEqual>0){
                control.juTrail.equal(0);
            }else{
                control.juTrail.greaterEqual(0);
            }
        }
        vieLast=control;
    }
    _ju_subViews=arrView;
 
}

-(void)removeAllItems{
    [self removeAllSubviews];
    [self removeConstraints:self.ju_Constraints];
    [self.ju_Constraints removeAllObjects];
//    [self juRemoveAllConstraints];
    _ju_subViews = nil;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation UIView(content)

-(void)juSetBaseContent:(id)content{}

@end
