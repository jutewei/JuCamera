//
//  JuAlbumPreView.m
//  PAImagePick
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/7/19.
//

#import "JuAlbumPreView.h"
#import "JuAlbumPreViewCell.h"
#import "JuPlayerAlbumCell.h"
#import "JuLayoutFrame.h"
#import "JuScaleCollectView.h"

@interface JuAlbumPreView ()
@property (nonatomic,copy) JuHandleIndex ju_handelIndex;
@property(nonatomic,strong) NSArray  *ju_arrList;///< 数据
@end

@implementation JuAlbumPreView{
}

-(instancetype)init{
    self =[super init];
    if (self) {
        [self juSetCollectView];
    }
    return self;
}

-(void)juSetCollectView{
    _ju_collectView=[JuScaleCollectView juInitWithView:self];
    [_ju_collectView registerClass:[JuPlayerAlbumCell class] forCellWithReuseIdentifier:@"JuPlayerAlbumCell"];
    [_ju_collectView registerClass:self.cellClass forCellWithReuseIdentifier:NSStringFromClass(self.cellClass)];
}

-(Class)cellClass{
    return [JuAlbumPreViewCell class];
}

-(void)juSetImages:(NSArray *)arrList cIndex:(NSInteger)index handle:(JuHandleIndex)handelIndex{
    _ju_handelIndex=handelIndex;
    self.ju_arrList=arrList;
    self.ju_currentIndex=index;
}

-(void)setJu_arrList:(NSArray *)ju_ArrList{
    _ju_arrList=ju_ArrList;
    [_ju_collectView juSetOffsetIndex:_ju_currentIndex];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _ju_arrList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PHAsset *asset=_ju_arrList[indexPath.row];
    if (_ju_allowVideo&&asset.mediaType==PHAssetMediaTypeVideo) {
        JuPlayerAlbumCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"JuPlayerAlbumCell" forIndexPath:indexPath];
        [cell juSetImage:_ju_arrList[indexPath.row]];
        cell.ju_tapHandle = self.ju_tapHandle;
        return cell;
    }else{
        __weak typeof(self) weakSelf = self;
        JuAlbumPreViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.cellClass) forIndexPath:indexPath];
        [cell juSetImage:_ju_arrList[indexPath.row]];
        cell.ju_tapHandle = ^{
            weakSelf.ju_tapHandle(NO);
        };
        return cell;
    }
}


#pragma mark 拖动时赋值

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    PHAsset *asset=_ju_arrList[_ju_currentIndex];
    if (_ju_allowVideo&&asset.mediaType==PHAssetMediaTypeVideo) {
        JuPlayerAlbumCell *cell=(JuPlayerAlbumCell *)[_ju_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_ju_currentIndex inSection:0]];
        [cell juReSetPlay];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat scrollViewX=scrollView.contentOffset.x+JU_Window_Width/3;
    _ju_currentIndex=scrollViewX/CGRectGetWidth(scrollView.frame);
    [self juSetItemFullImage];
    if (self.ju_handelIndex) {
        self.ju_handelIndex(_ju_currentIndex);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [_ju_collectView juGetItemSize:_ju_currentIndex];
}

-(void)setJu_currentIndex:(NSInteger)ju_currentIndex{
    _ju_currentIndex=ju_currentIndex;
    [_ju_collectView setContentOffset:CGPointMake(ju_currentIndex*CGRectGetWidth(_ju_collectView.frame), 0)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self juSetItemFullImage];
    });
}

-(void)juSetItemFullImage{
    PHAsset *asset=_ju_arrList[_ju_currentIndex];
    if (_ju_allowVideo&&asset.mediaType==PHAssetMediaTypeVideo) {
        return;
    }
    JuAlbumPreViewCell *cell=(JuAlbumPreViewCell *)[_ju_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_ju_currentIndex inSection:0]];
    [cell juSetFullImage];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
