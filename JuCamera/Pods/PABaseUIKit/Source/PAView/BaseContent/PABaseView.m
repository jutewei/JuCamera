//
//  PABaseView.m
//  PABase
//
//  Created by Juvid on 2021/4/19.
//

#import "PABaseView.h"

@implementation PABaseView{
    BOOL isSubview;
}
-(instancetype)initWithCoder:(NSCoder *)coder{
    self=[super initWithCoder:coder];
    if (self) {
        [self zlSubViews];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self zlSubViews];
    }
    return self;
}

//-(instancetype)init{
//    self=[super init];
//    if (self) {
//        [self zlInitView];
//    }
//    return self;
//}

//-(void)zlInitView{
//    if (!isSubview) {
//        isSubview=YES;
//        [self zlSubViews];
//    }
//}
//-(void)awakeFromNib{
//    [super awakeFromNib];
//    [self zlInitView];
//}

-(void)zlSubViews{}
-(void)zlSetContent:(id)content{}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation PABasePopupView

+(instancetype)zlInitWithHandle:(dispatch_block_t)handle{
    PABasePopupView *view=[[[self class] alloc]init];
    view.zl_handle=handle;
    return view;
}

-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    if (self.superview) {
        self.backgroundColor=[UIColor clearColor];
        self.juLead.equal(0);
        self.juTrail.equal(0);
        self.juBottom.equal(0);
        [self zlShowView];
    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    UIView *view=touches.anyObject.view;
    if ([view isEqual:self]) {
        [self zlHideView];
    }
}

-(void)zlShowView{
    [self.zl_contentView layoutIfNeeded];
    self.zl_contentView.transform=CGAffineTransformMakeTranslation(0,-CGRectGetHeight(self.zl_contentView.frame));
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor=[UIColor colorWithWhite:0 alpha:0.3];
        self.zl_contentView.transform=CGAffineTransformMakeTranslation(0,0);
    }];
}

-(void)zlHideView{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor=UIColor.clearColor;
        self.zl_contentView.transform=CGAffineTransformMakeTranslation(0,-CGRectGetHeight(self.zl_contentView.frame));
    }completion:^(BOOL finished) {
        if (self.zl_handle) {
            self.zl_handle();
        }
        [self removeFromSuperview];
    }];
}

@end
