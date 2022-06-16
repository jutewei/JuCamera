//
//  JuCycleScrollView.m
//  JuCycleScroll
//
//  Created by Juvid on 2018/10/25.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuCycleScrollView.h"
#import "NSTimer+Addition.h"
#import "JuLayoutFrame.h"
#import "JuCycleScrollAdapter.h"
#import "UIImageView+CycleAdapter.h"
#import "NSObject+JuEasy.h"
@implementation JuCycleScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self juInitView];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self juInitView];
}

- (void)juSetTimer:(BOOL)animated{
    if (animated) {
        if (ju_arrList.count>1) {
            [ju_timer resumeTimerAfterTimeInterval:ju_animation];
        }
    }else{
        [ju_timer pauseTimer];
    }
}

-(void)juStartTimer{
    ju_timer= [NSTimer scheduledTimerWithTimeInterval:ju_animation target: self selector: @selector(juHandleTimer:)  userInfo:nil  repeats: YES];
    [ju_timer pauseTimer];
}


-(void)juInitView{
    self.backgroundColor=JUDarkColorHex(0xf5f5f5);
    _Scale=1.0/3.0;
    ju_animation=5;
    [self juStartTimer];
    [self juSetScrollView];
}
//初始化控件
-(void)juSetScrollView{
    for (NSLayoutConstraint *layout in self.constraints ) {
        if (layout.relation==NSLayoutRelationEqual) {
            _Scale=1.0/layout.multiplier;
        }
    }
    ju_scrollView=self.scrollView;
    [self addSubview:ju_scrollView];
    ju_scrollView.juFrame(CGRectMake(0, 0, 0, 0));

    ju_scrollView.showsHorizontalScrollIndicator=NO;
    ju_scrollView.showsVerticalScrollIndicator=NO;
    ju_scrollView.pagingEnabled=YES;
    ju_scrollView.delegate=self;
    [self juSetPageView];
}
-(UIScrollView *)scrollView{
    return [[UIScrollView alloc]init];
}
-(void)juSetPageView{
    ju_page=[[JuPageViewControl alloc]init];
    ju_page.hidesForSinglePage=YES;
    ju_page.pageSize=6;
    ju_page.currentPageIndicatorTintColor=MFColor_LightGray;
    ju_page.pageIndicatorTintColor=JUColor_SelectSecond;
    [self addSubview:ju_page];
    ju_page.juBottom.equal(0);
}
//重新设置位置
-(void)setScale:(CGFloat)Scale{
    _Scale=Scale;
}
//初始化轮播图片
-(void)juSetScrollItem:(NSArray *)arrItem{
    if (!arrItem&&arrItem.count==0) return;
    ju_arrList=[NSMutableArray arrayWithArray:arrItem];
    if (ju_arrList.count<=1) {
        [ju_timer pauseTimer];
    }
    else{
        //        [sh_Timer resumeTimer];
        [ju_timer resumeTimerAfterTimeInterval:ju_animation];
        [ju_arrList addObject:arrItem.firstObject];
    }
    ju_totalNum=(int)ju_arrList.count;
    [self juPageStyle:ju_totalNum-1];
    [ju_scrollView removeAllSubviews];
    UIImageView *lastView=nil;
    for (int i=0; i<ju_totalNum; i++) {
        UIImageView *imgItem =[self juSetImageData:ju_arrList[i]];
        imgItem.tag=i;
        [self juSetImageView:imgItem currentView:lastView];
        lastView=imgItem;
        if (i==ju_totalNum-1) {
            imgItem.juTrail.equal(0);
        }
    }
    if (arrItem.count>1) {
        [self juMoreOneImage:arrItem listView:lastView];
    }
//    sh_ScrollView.contentSize=CGSizeMake(sh_TotalNum*Screen_Width, 0);

}
-(UIImageView *)juSetImageData:(id)imageObject{
    UIImageView *imgItem =[[UIImageView alloc]init];
    imgItem.userInteractionEnabled=YES;
    imgItem.contentMode = UIViewContentModeScaleAspectFill;
    [ju_scrollView addSubview:imgItem];
//      [self mtSetImageView:imgItem currentView:currentItem];
    [imgItem setClipsToBounds:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapAction:)];
    [imgItem addGestureRecognizer:tap];
    imgItem.payloadObject=imageObject;
    [self juSetItemData:imgItem withData:imageObject];
    return imgItem;
}

-(void)juMoreOneImage:(NSArray *)list listView:(UIView *)listView{}


-(void)juSetImageView:(UIImageView *)imageV currentView:(UIImageView *)currentItem{

    imageV.juSizeEqual(ju_scrollView);
    imageV.juTop.equal(0);
    imageV.juBottom.equal(0);
    if (currentItem) {
        imageV.juLeaSpace.toView(currentItem).equal(0);
    }else{
        imageV.juLead.equal(0);
    }
}

-(void)juPageStyle:(NSInteger)pageNum{
    pageNum=pageNum==0?1:pageNum;
    ju_page.numberOfPages=pageNum;
}
-(void)setJuPageAlignment:(JUPageAlignment)juPageAlignment{
    ju_page.juPageAlignment=juPageAlignment;
}
//设置数据
-(void)juSetItemData:(UIImageView *)imgItem withData:(id)model{
    [imgItem juLoadImage:[self juGetAdapter:model]];
    [self juSetItemlOther:imgItem withData:model];
}
-(void)juSetItemlOther:(UIView *)viewImg withData:(id)model{

}
-(JuCycleScrollAdapter *)juGetAdapter:(id)model{
    return [JuCycleScrollAdapter initWithData:model];
}
//-(void)shSetItemlOther:(UIView *)viewImg withData:(id)sh_M{
//    sh_Page.currentPageIndicatorTintColor=PFB_Color_TextThird;
//    sh_Page.pageIndicatorTintColor=PFB_Color_CellSelect;
//}

//轮播图片
#pragma mark - 5秒换图片
- (void) juHandleTimer: (NSTimer *) timer
{
    if(ju_currentNum==0)[ju_scrollView setContentOffset:CGPointMake(0,0)];

    ju_currentNum++;
    CGFloat scrollW=CGRectGetWidth(ju_scrollView.frame);
    [UIView animateWithDuration:0.5 animations:^{
        [ju_scrollView setContentOffset:CGPointMake(ju_currentNum*scrollW,0)];
    } completion:^(BOOL finished) {
        if(ju_currentNum==ju_totalNum-1){//先移动到最后一页////在移动到第一页//最后一页时
            ju_currentNum=0;
            [ju_scrollView setContentOffset:CGPointMake(0,0)];
            ju_page.currentPage=ju_currentNum;
        }
    }];
    ju_page.currentPage=ju_currentNum;
}
#pragma mark 拖动时赋值
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat scrollViewX=scrollView.contentOffset.x;
    CGFloat scrollW=CGRectGetWidth(scrollView.frame);
    ju_currentNum=scrollViewX/scrollW;

    if (scrollViewX==(ju_totalNum-1)*scrollW){
        ju_currentNum=0;
    }
    if (ju_timer) {
        [ju_timer resumeTimerAfterTimeInterval:ju_animation];
    }
    ju_page.currentPage=ju_currentNum;
}

-(void)setCurrentNum:(int)num{
    ju_currentNum=num;
    ju_page.currentPage=ju_currentNum;
    if (num==0) {
        [ju_scrollView setContentOffset:CGPointMake(0,0)];
    }
}

//暂停定时器
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (ju_timer) {
        [ju_timer pauseTimer];
    }
}
//开始定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [ju_timer resumeTimerAfterTimeInterval:ju_animation];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollViewX=scrollView.contentOffset.x;
    CGFloat scrollW=CGRectGetWidth(scrollView.frame);
    if (scrollViewX>(ju_totalNum-1)*scrollW) {//最后一张
        [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    else if (scrollViewX<0){//第一张
        [scrollView setContentOffset:CGPointMake((ju_totalNum-1)*scrollW, 0) animated:NO];
    }
}

-(void)TapAction:(UITapGestureRecognizer *)sender{
    if ([self.juDelegate respondsToSelector:@selector(juTouchImageIndex:)]) {
        [self.juDelegate juTouchImageIndex:sender.view.payloadObject];
    }
}

-(void)dealloc{
    [self juDealloc];
}
-(void)juDealloc{
    [ju_timer invalidate];
    ju_timer=nil;
}
@end
