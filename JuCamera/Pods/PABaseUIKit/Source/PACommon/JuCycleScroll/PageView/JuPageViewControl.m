//
//  JuPageView.m
//  JuCycleScroll
//
//  Created by Juvid on 2016/10/21.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JuPageViewControl.h"
#import "JuLayoutFrame.h"

@interface JuPageViewControl (){
    UIView *pageView;
    UIImageView *currentPageView;
}

@end

@implementation JuPageViewControl

-(instancetype)init{
    self=[super init];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        self.pageIndicatorTintColor=[UIColor whiteColor];
        self.currentPageIndicatorTintColor=[UIColor lightGrayColor];
        _pageSize=4;
        _pageSpace=8;
        pageView=[[UIView alloc]init];
        [self addSubview:pageView];
        pageView.juCenterY.equal(0);
        pageView.juCenterX.priority(750).equal(0);
        pageView.juTop.equal(0);
//        pageView.juWidth.equal(40);
    }
    return self;
}
-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    if (!self.ju_Height) {
       self.juHeight.equal(24);
    }
    if (!self.ju_Bottom) {
        self.juBottom.equal(0);
    }
    self.juWidth.equal(0);
    self.juCenterX.equal(0);
}
-(void)setCurrentPage:(NSInteger)currentPage{
    _currentPage=currentPage;

    currentPageView.backgroundColor=_pageIndicatorTintColor;
    if (_pageIndicatorImage) {
         currentPageView.image=_pageIndicatorImage;
         currentPageView.backgroundColor=nil;
    }
    if (_currentPageSize>0) {
        currentPageView.ju_Width.constant=_pageSize;
    }
    currentPageView =[pageView viewWithTag:10+currentPage];
    if (_currentPageSize>0) {
          currentPageView.ju_Width.constant=_currentPageSize;
      }
    currentPageView.backgroundColor=_currentPageIndicatorTintColor;
    if (_currentPageIndicatorImage) {
         currentPageView.image=_currentPageIndicatorImage;
         currentPageView.backgroundColor=nil;
    }

}
-(void)setPageSize:(CGFloat)pageSize{
    _pageSize=pageSize;
    [self juSetPageItems];
}
-(void)setPageSpace:(CGFloat)pageSpace{
    _pageSpace=pageSpace;
    [self juSetPageItems];
}
-(void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor{
    _currentPageIndicatorTintColor=currentPageIndicatorTintColor;
}
-(void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor{
    _pageIndicatorTintColor=pageIndicatorTintColor;
}
-(void)setPageIndicatorImage:(UIImage *)pageIndicatorImage{
    _pageIndicatorImage=pageIndicatorImage;
}
-(void)setCurrentPageIndicatorImage:(UIImage *)currentPageIndicatorImage{
    _currentPageIndicatorImage=currentPageIndicatorImage;
}
-(void)setHidesForSinglePage:(BOOL)hidesForSinglePage{
    _hidesForSinglePage=hidesForSinglePage;
    if (_numberOfPages&&hidesForSinglePage) {
        pageView.hidden=YES;
    }
}
-(void)setJuPageAlignment:(JUPageAlignment)juPageAlignment{
    _juPageAlignment=juPageAlignment;
    if (juPageAlignment==JUPageAlignmentLeft&&!pageView.ju_Lead) {
        pageView.juLead.equal(15);
    }else if (juPageAlignment==JUPageAlignmentRight&&!pageView.ju_Trail){
        pageView.juTrail.equal(15);
    }
}
-(void)setNumberOfPages:(NSInteger)numberOfPages{
    _numberOfPages=numberOfPages;
    [self juSetPageItems];
}

-(void)juSetPageItems{
    while (pageView.subviews.count>0) {
        UIView *subview=pageView.subviews.firstObject;
        [subview removeFromSuperview];
    }
    if (_numberOfPages==1&&_hidesForSinglePage) {
        pageView.hidden=YES;
    }else{
        pageView.hidden=NO;
    }
//    pageView.ju_Width.constant=_numberOfPages*(_pageSpace+_pageSize)-_pageSpace;
    self.juPageAlignment=_juPageAlignment;
    UIImageView *lastView;
    for (int i=0; i<_numberOfPages; i++) {
        UIImageView *vie=[[UIImageView alloc]init];
        [vie setContentMode:UIViewContentModeScaleAspectFit];
        [vie setClipsToBounds:YES];

        vie.tag=i+10;
        [pageView addSubview:vie];
//        vie.juLead.equal(i*(_pageSpace+_pageSize));
        if (_pageIndicatorImage) {
            vie.juTop.equal(0);
            vie.image=_pageIndicatorImage;
        }else{
            vie.juCenterY.equal(0);
            [vie.layer setCornerRadius:_pageSize/2.0];
            vie.backgroundColor=_pageIndicatorTintColor;
            vie.juSize(CGSizeMake(_pageSize, _pageSize));
        }

        if (lastView) {
            vie.juLeaSpace.toView(lastView).equal(_pageSpace);
        }else{
            vie.juLead.equal(0);
        }
        if (i==_numberOfPages-1) {
            vie.juTrail.equal(0);
        }

        if (i==0) {
            currentPageView=vie;
        }

        lastView=vie;

    }
    self.currentPage=0;
}


//- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount{
//
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
