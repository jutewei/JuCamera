//
//  JuTopBarView.m
//  JuLayout
//
//  Created by Juvid on 2017/10/27.
//  Copyright © 2017年 Juvid(zhutianwei). All rights reserved.
//

#import "JuTopBarView.h"
#import "JuLayoutFrame.h"

@interface JuTopBarView(){
    UIView *vieLine;
    UILabel *ju_labTitle;
    BOOL  isAnimate,isSetLayout;
    UIImageView  *mt_backView;
    UIVisualEffectView *effectView;
}
@property (nonatomic,assign) BOOL hasEdge;
//@property (nonatomic,assign) CGFloat barHeight;
@end

@implementation JuTopBarView

+(instancetype)initWithVC:(UIViewController *)supVC{
    JuTopBarView *view=[[JuTopBarView alloc]init];
    view.ju_contentVC=supVC;
    return view;
}

-(instancetype)init{
    self=[super init];
    if (self) {
        [self setBackView];
        [self setShowView];
        self.backgroundColor=[UIColor clearColor];
        self.userInteractionEnabled=YES;
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(juStatusBarFrameChange:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
        self.ju_alpha=1;
    }
    return self;
}

-(void)setBackView{

    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    if (@available(iOS 13.0, *)) {
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemThinMaterial];
    }
    //  毛玻璃视图
    effectView= [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    effectView.alpha=0.85;
   //添加到要有毛玻璃特效的控件中
    [self addSubview:effectView];
   //设置模糊透明度
    effectView.juEdge(UIEdgeInsetsMake(0, 0, 0, 0));

    mt_backView =[[UIImageView alloc]init];
    [self addSubview:mt_backView];
    mt_backView.backgroundColor=JUColor_ContentWhite;
    mt_backView.juEdge(UIEdgeInsetsMake(0, 0, 0, 0));
}
-(void)setShowView{
    vieLine=[[UIView alloc]init];
    vieLine.backgroundColor=[UIColor colorWithWhite:0.5 alpha:.3];
    [mt_backView addSubview:vieLine];
    vieLine.juTopSpace.equal(0);
    vieLine.juHeight.equal(0.3);
    vieLine.juLead.equal(0);
    vieLine.juTrail.equal(0);
}
- (void)juViewWillTransitionToSize:(CGSize)size{
//    NSLog(@"时间1：%@ %f",[NSDate date],[[NSDate date] timeIntervalSince1970]);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.ju_Height.constant=self.topHeight;
    });
}

- (void)juStatusBarFrameChange:(NSNotification *)notification{
//    NSLog(@"时间2：%@ %f",[NSDate date],[[NSDate date] timeIntervalSince1970]);
    if (self.window) {
        self.ju_Height.constant=self.topHeight;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (!isSetLayout&&self.superview) {
        self.juLead.equal(0);
        self.juTrail.equal(0);
        if (!self.hasEdge||self.superview.originX>0) {
             self.juBtmSpace.equal(0);
        }else{
            self.juTop.equal(0);
        }
        self.juHeight.equal(self.topHeight);
        isSetLayout=YES;
    }
}
/*
-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    if (self.superview) {

    }
}*/

-(void)setJu_contentVC:(UIViewController *)ju_contentVC{
//    _ju_contentVC=ju_contentVC;
    UIRectEdge edge=ju_contentVC.edgesForExtendedLayout;
    self.hasEdge=(edge==UIRectEdgeAll||edge==UIRectEdgeTop);
//    if (ju_contentVC.navigationController) {
//        self.barHeight=ju_contentVC.navigationController.navigationBar.frame.size.height;
//    }
    [ju_contentVC.view addSubview:self];
}

-(void)setTitle:(NSString *)title{
    self.sh_labTitle.text=title;
}

-(UILabel *)sh_labTitle{
    if (!ju_labTitle) {
        ju_labTitle =[[UILabel alloc]init];
        ju_labTitle.textAlignment=NSTextAlignmentCenter;
        ju_labTitle.textColor=JUColor_BlackBlack;
        ju_labTitle.font=JUFont_NaviTitleM;
        [self addSubview:ju_labTitle];
        ju_labTitle.juFrame(CGRectMake(0.01, -0.01, 0, 44));
    }
    return ju_labTitle;
}

-(void)setJu_titleView:(UIView *)ju_titleView{
    if (_ju_titleView) {
        [_ju_titleView removeFromSuperview];
    }
    if (ju_labTitle) {
        [ju_labTitle removeFromSuperview];
        ju_labTitle=nil;
    }
    _ju_titleView=ju_titleView;
    [self addSubview:ju_titleView];
    ju_titleView.juFrame(CGRectMake(0, -0.01, 0, 44));
}

-(void)setLargeTitles:(id)ju_largeTitles withHeight:(CGFloat)height{
    if (!ju_largeTitles) return;
    if (!_ju_largeView) {
        _ju_largeView=[JuLargeTitleView initWithData:ju_largeTitles withHeight:height];
        [self addSubview:_ju_largeView];
    }
}

-(void)setIsShow:(BOOL)isShow{
    if (!isAnimate&&isShow!=_isShow) {
        _isShow=isShow;
        isAnimate=YES;
        self.ju_Bottom=isShow?NavBar_Height:0;
        [UIView animateWithDuration:0.2 animations:^{
            [self.superview layoutIfNeeded];
        }completion:^(BOOL finished) {
            isAnimate=NO;
        }];
    }
}

-(void)setJu_alpha:(CGFloat)ju_alpha{
    self.hidden=ju_alpha==0;
    if (effectView) {
        _ju_alpha=MIN(0.92, ju_alpha);
    }else{
        _ju_alpha= ju_alpha;
    }
    mt_backView.alpha=_ju_alpha;
    effectView.alpha=ju_alpha;
}

-(void)setJu_backColor:(UIColor *)ju_backColor{
    _ju_backColor=ju_backColor;
    mt_backView.backgroundColor=_ju_backColor;
    if (effectView) {
        [effectView removeFromSuperview];
        effectView=nil;
    }
}

-(void)setJu_backImage:(UIImage *)ju_backImage{
    mt_backView.image=ju_backImage;
    if (effectView) {
        [effectView removeFromSuperview];
        effectView=nil;
    }
}

-(CGFloat)topHeight{
    CGFloat barHeight=44;
    UIViewController *vc=(UIViewController *)self.superview.nextResponder;
    if ([vc isKindOfClass:[UIViewController class]]&&vc.navigationController) {
        barHeight= vc.navigationController.navigationBar.frame.size.height;
    }
    return barHeight+[[UIApplication sharedApplication] statusBarFrame].size.height;
}
-(void)setJu_showColor:(UIColor *)ju_showColor{
    _ju_showColor=ju_showColor;
    vieLine.backgroundColor=ju_showColor;
}
-(void)dealloc{
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation JuLargeTitleView{
    CGFloat mt_height;
}

-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    if (self.superview) {
        self.juTopSpace.equal(0);
        self.juSize(CGSizeMake(0, mt_height));
        self.juLead.equal(0);
    }
}
+(instancetype)initWithData:(id)largeTitles withHeight:(CGFloat)height{
    JuLargeTitleView *view=[[JuLargeTitleView alloc]init];
    view.backgroundColor=JUColor_ContentWhite;
    [view juSetTitleData:largeTitles withHeight:height];
    return view;;
}

-(void)juSetTitleData:(id)titleContent withHeight:(CGFloat)height{
    mt_height=height;
    if (!_ju_contentView) {
        _ju_contentView=[[UIView alloc]init];
        [self addSubview:_ju_contentView];
        _ju_contentView.juFrame(CGRectMake(0, -0.01, 0, 40));
        if ([titleContent isKindOfClass:[UIImage class]]) {
            _ju_imageView=[[UIImageView alloc]init];
            _ju_imageView.image=titleContent;
            [_ju_contentView addSubview:_ju_imageView];
            _ju_imageView.juOrigin(CGPointMake(15, 6));
        }else{
            _ju_labTitle=[[UILabel alloc]init];
            _ju_labTitle.font=[UIFont systemFontOfSize:28 weight:UIFontWeightSemibold];
            _ju_labTitle.textColor=PAColor_BlackGray;
            _ju_labTitle.text=titleContent;
            [_ju_contentView addSubview:_ju_labTitle];
            _ju_labTitle.juOrigin(CGPointMake(15, 6));
        }
        [self addSubview:_ju_contentView];
    }
}

-(BOOL)scrollViewDidScroll:(UIScrollView *)scrollView{
    //            CGFloat moveY= self.mtInsetTop+NavBar_Height+scrollView.contentOffset.y;
    CGFloat moveY= NavBar_Height+scrollView.contentOffset.y;
    self.ju_Height.constant=MIN(mt_height, mt_height-moveY);
    self.ju_contentView.alpha=1-(moveY/mt_height);
    self.hidden=self.alpha<=0;
    return self.ju_contentView.alpha>0;
    //            NSLog(@"当前坐标 ：%f  移动：%f ",-(self.mtInsetTop-moveY),moveY);
}
@end


@implementation JuTitleTopEdgeView

-(void)didMoveToSuperview{
    self.userInteractionEnabled=NO;
    self.backgroundColor=JUColor_ContentWhite;
    [super didMoveToSuperview];
    if (self.superview) {
        self.juLead.equal(0);
        self.juCenterX.equal(0);
        self.juTop.equal(0);
        self.juHeight.equal(0.01);
    }
}
+(instancetype)initTopView{
    JuTitleTopEdgeView *topView=[[JuTitleTopEdgeView alloc]init];
    return topView;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.ju_Height.constant=MAX(-scrollView.contentOffset.y, 0);
}

@end
