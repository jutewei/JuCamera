//
//  JuImagesCollectView.m
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuImagePreView.h"
#import "JuLayoutFrame.h"
#import "JuImagePreViewCell.h"
#import "JuImageObject.h"

@interface JuImagePreView()<JuScaleViewDelegate>{
    CGRect ju_originalFrame;
    NSInteger ju_startIndex;
    BOOL isHidderCell;
}

@property(nonatomic,assign) NSInteger  ju_currentIndex;///< 当前第几个
@property(nonatomic,strong) NSMutableArray  *ju_arrList;///< 数据

@end

@implementation JuImagePreView
-(instancetype)init{
    self =[super init];
    if (self) {
        [self juSetCollectView];
    }
    return self;
}

-(void)juSetCollectView{
    _ju_collectView=[JuScaleCollectView juInitWithView:self];
    [_ju_collectView registerClass:self.cellClass forCellWithReuseIdentifier:NSStringFromClass(self.cellClass)];
}

-(Class)cellClass{
    return [JuImagePreViewCell class];
}

-(void)juSetImages:(NSArray *)arrList
            cIndex:(NSInteger)index
              rect:(CGRect)frame{
    ju_startIndex=index;
    ju_originalFrame=frame;
    self.ju_arrList=arrList.mutableCopy;
    self.ju_currentIndex=index;
}

-(void)setJu_arrList:(NSMutableArray *)ju_ArrList{
    _ju_arrList=ju_ArrList;
    [_ju_collectView juSetOffsetIndex:_ju_currentIndex];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _ju_arrList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JuImagePreViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.cellClass) forIndexPath:indexPath];
    cell.ju_delegate=self;
    CGRect frame=CGRectZero;
    if (ju_startIndex==indexPath.row) {
        frame=ju_originalFrame;
        ju_originalFrame=CGRectZero;
    }
    [cell juSetImage:_ju_arrList[indexPath.row] originalFrame:frame];
    return cell;
}

#pragma mark 拖动时赋值
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat scrollViewX=scrollView.contentOffset.x+JU_Window_Width/3;
    _ju_currentIndex=scrollViewX/CGRectGetWidth(scrollView.frame);
    [self juSetItemFullImage];
    if ([self.ju_delegate respondsToSelector:@selector(juCurrentIndex:)]) {
        [self.ju_delegate juCurrentIndex:_ju_currentIndex];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [_ju_collectView juGetItemSize:_ju_currentIndex];
}

// 屏幕转动，改变cell的frame
- (void)changeFrame:(id)sender{
    NSMutableArray *arrCell=[NSMutableArray array];
    for (NSIndexPath *indexPath in self.ju_collectView.indexPathsForVisibleItems) {
        JuImagePreViewCell *cell=(id)[_ju_collectView cellForItemAtIndexPath:indexPath];
        [cell juSetContentHidden:indexPath.row!=_ju_currentIndex];
        [arrCell addObject:cell];
    }
//
    if (!([[[UIDevice currentDevice]systemVersion] floatValue]>=11)||[[[UIDevice currentDevice]systemVersion] floatValue]>13) {
        [_ju_collectView.collectionViewLayout invalidateLayout];
    }
//
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (JuImagePreViewCell *cell in arrCell) {
            [cell juSetContentHidden:NO];
        }
    });
}


-(void)juSetItemFullImage{
    JuImagePreViewCell *cell=[_ju_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_ju_currentIndex inSection:0]];
    [cell juSetFullImage];
}

-(void)setJu_currentIndex:(NSInteger)ju_currentIndex{
    _ju_currentIndex=ju_currentIndex;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self juSetItemFullImage];
    });
}

-(CGRect)juCurrentRect{
    if ([self.ju_delegate respondsToSelector:@selector(juRectIndex:)]) {
        return  [self.ju_delegate juRectIndex:_ju_currentIndex];
    }
    return CGRectZero;
}

-(BOOL)juNotMoveHidder{
    return _ju_canEdit;
}

-(void)juTapHidder{
    
    if (_ju_canEdit) {
        return;
    }
    
    if ([self.ju_delegate respondsToSelector:@selector(juChangeSacle:)]) {
        [self.ju_delegate juChangeSacle:0];
    }
    [self juHideOtherView:YES];

    [UIView animateWithDuration:0.35 animations:^{
        self.ju_collectView.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
    }completion:^(BOOL finished) {
        if ([self.ju_delegate respondsToSelector:@selector(juTapHidder)]) {
            [self.ju_delegate juTapHidder];
        }
    }];
}

-(void)juHideOtherView:(BOOL)isHidder{
    for (UIView *view in self.superview.subviews) {
        if (![view isEqual:self]) {
            view.hidden=isHidder;
        }
    }
}

-(void)juChangeSacle:(CGFloat)scale{

    BOOL enable=scale==1;
    [self juHideOtherView:!enable];
    
    if (scale==1) {
        [UIView animateWithDuration:0.3 animations:^{
            self.ju_collectView.backgroundColor=[UIColor colorWithWhite:0 alpha:1];
        }completion:^(BOOL finished) {
//            [self juSetHidder:hidder];
        }];
    }else{
        self.ju_collectView.backgroundColor=[UIColor colorWithWhite:0 alpha:scale];
    }
    if (!enable) {
        [self.ju_collectView setContentOffset:CGPointMake(_ju_currentIndex*(JU_Window_Width+20), 0)];
    }
    self.ju_collectView.scrollEnabled=enable;

    if ([self.ju_delegate respondsToSelector:@selector(juChangeSacle:)]) {
        [self.ju_delegate juChangeSacle:scale];
    }
}

-(void)juDeleteIndex:(NSInteger)index{
    [self.ju_arrList removeObjectAtIndex:index];
    [self.ju_collectView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (index>=self.ju_arrList.count) {
            [self.ju_collectView setContentOffset:CGPointMake((index-1)*CGRectGetWidth(self.ju_collectView .frame), 0)];
        }
        [self scrollViewDidEndDecelerating:self.ju_collectView];
    });
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
