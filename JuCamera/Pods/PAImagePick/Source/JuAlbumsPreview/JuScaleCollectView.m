//
//  JuScaleCollectView.m
//  PAImagePick
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/7/23.
//

#import "JuScaleCollectView.h"
#import "JuLayoutFrame.h"
#import "JuPhotoConfig.h"

@implementation JuScaleCollectView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(instancetype)juInitWithView:(UIView *)supView{
    JuScaleCollectView *collectView=[[JuScaleCollectView alloc]initWithFrame:CGRectZero collectionViewLayout:self.juSetCollectLayout];
    [collectView setView:supView];
    return collectView;
}

-(void)setView:(UIView *)supView{
    self.dataSource = supView;
    self.delegate=supView;
    self.showsHorizontalScrollIndicator=NO;
    self.showsVerticalScrollIndicator=NO;
    self.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
    self.pagingEnabled=YES;
    [supView addSubview:self];
    self.juEdge(UIEdgeInsetsMake(0, 0, 0, 0));
    self.ju_Trail.constant=-20;
    [self layoutIfNeeded];
}

+(UICollectionViewFlowLayout *)juSetCollectLayout{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset=UIEdgeInsetsMake(0, 0, 0, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    return layout;
}
-(void)juSetOffsetIndex:(NSInteger)index{
    [self reloadData];
    [self setContentOffset:CGPointMake(index*(JU_Window_Width+20), 0)];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor=[UIColor colorWithWhite:0 alpha:1];
    }];
}

-(CGSize)juGetItemSize:(NSInteger)index{
    CGFloat ju_itemWidth=JU_Window_Width+20;
    [self setContentOffset:CGPointMake(index*ju_itemWidth, 0)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setContentOffset:CGPointMake(index*ju_itemWidth, 0)];
    });
    return CGSizeMake(ju_itemWidth, JU_Window_Height);
}
@end
