//
//  PABaseCollectView.m
//  PABase
//
//  Created by Juvid on 2021/4/19.
//

#import "PABaseCollectView.h"

@implementation PABaseCollectView
-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.zl_heightHandle) {

        if (zl_contentHeight!=self.contentSize.height) {
            for (NSLayoutConstraint *layout in self.constraints ) {
                if (layout.firstAttribute==NSLayoutAttributeHeight) {
                    layout.constant=MAX(_zl_miniHeight, self.contentSize.height);
                }
            }
            zl_contentHeight=self.contentSize.height;
            self.zl_heightHandle(zl_contentHeight);
        }

    }
}
-(instancetype)initWithFrame:(CGRect)frame{
    self=[self initWithFrame:frame collectionViewLayout:[UICollectionViewLayout new]];
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self=[super initWithFrame:frame collectionViewLayout:[self zlLayout]];
    if (self) {
        [self zlSetCollentView];
    }
    return self;
}
-(UICollectionViewFlowLayout *)zlLayout{
    zl_flowLayout=[[UICollectionViewFlowLayout alloc] init];
    zl_flowLayout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
    zl_flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    zl_flowLayout.minimumInteritemSpacing = 5;
    zl_flowLayout.minimumLineSpacing = 0;
    return zl_flowLayout;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self zlSetCollentView];
}

-(void)zlSetCollentView{
    if (!self.collectionViewLayout) {
        [self zlLayout];
    }else{
        zl_flowLayout=(id)self.collectionViewLayout;
    }
    self.delegate=self;
    self.dataSource=self;
    self.backgroundColor = [UIColor whiteColor];
}
-(void)setZl_mArrList:(NSMutableArray *)sh_MArrList{
     zl_contentHeight=0;
    _zl_mArrList=sh_MArrList;
    [self reloadData];
}

#pragma mark collectionView Delegate &datasource methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _zl_mArrList.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"collectViewCell" forIndexPath:indexPath];
    return cell;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
