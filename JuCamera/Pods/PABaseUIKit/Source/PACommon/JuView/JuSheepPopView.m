//
//  PASheepView.m
//  PAZLChannelCar
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2022/1/18.
//  Copyright © 2022 pingan. All rights reserved.
//

#import "JuSheepPopView.h"

@implementation JuSheepPopView

+(JuSheepPopView *)zlSetActionItems:(NSArray *)items
                 handle:(JuCallHandle)handle{
    JuSheepPopView *view=[JuSheepPopView initView];
    [view zlSetActionItems:items  handle:handle];
    [view juShowView];
    return view;
}
-(void)zlSetActionItems:(NSArray *)items
                 handle:(JuCallHandle)handle{
    self.ju_callHandle = handle;
    NSInteger itemH=50,spaceH=8;
    for (NSString *title in items) {
        NSInteger index=[items indexOfObject:title];
        UIButton *btn=[[UIButton alloc]init];
        btn.backgroundColor=[UIColor whiteColor];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(juTouchBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font=PAFFont_TitleText;
        [self.vieBox addSubview:btn];
    
        if (index==0&&[title isEqual:@"取消"]) {
            [btn setTitleColor:MFColor_LightGray forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:MFColor_MainBlack forState:UIControlStateNormal];
            UIView *line=[[UIView alloc]init];
            line.backgroundColor=UINormalColorHex(0xE7E7ED);
            [self.vieBox addSubview:line];
            if (index==1) {
                line.juSize(CGSizeMake(0, spaceH));
                line.juBottom.toView(btn).equal(-spaceH);
            }else{
                line.juBottom.toView(btn).equal(0);
                line.juSize(CGSizeMake(0, 0.5));
            }
            line.juLead.equal(0);
        }
        btn.juSafeFrame(CGRectMake(0, -(0.01+(index?spaceH:0)+index*itemH), 0, itemH));
        if (index==items.count-1) {
            btn.juTop.equal(0);
        }
    }
    [self.superview layoutIfNeeded];
    [self layoutIfNeeded];
    self.ju_boxHeight=CGRectGetHeight(self.vieBox.frame);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
