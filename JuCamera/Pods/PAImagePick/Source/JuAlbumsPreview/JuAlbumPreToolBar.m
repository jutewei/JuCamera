//
//  JuAlbumPreFootView.m
//  PAImagePick
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/7/15.
//

#import "JuAlbumPreToolBar.h"
#import "JuPhotoConfig.h"
#import "JuLayoutFrame.h"
#import "JuAlbumManage.h"
#import "PHAsset+juDeal.h"

//#import "JuImageObject.h"

@interface JuAlbumPreToolBar ()<UICollectionViewDelegate,UICollectionViewDataSource>
@end

@implementation JuAlbumPreToolBar{
    UIButton *ju_btnDone;
    UICollectionView *ju_collectImage;
    NSInteger totalCount;
}

-(instancetype)init{
    self=[super init];
    if (self) {
        self.backgroundColor= Photo_BackColor;
        UIView *view=[[UIView alloc]init];
        view.backgroundColor=self.backgroundColor;
        [self addSubview:view];
        view.juLead.equal(0);
        view.juTopSpace.equal(0);
        view.juSize(CGSizeMake(0, 50));
        
        [self setBaseView];
    }
    return self;
}

-(void)setHide:(BOOL)hide{
    self.hidden=(_ju_arrImage.count==0||hide);
}

-(void)setJu_currentIndex:(NSInteger)ju_currentIndex{
    _ju_currentIndex=ju_currentIndex;
    if (ju_collectImage) {
        [ju_collectImage reloadData];
    }
    if (_ju_arrImage.count>ju_currentIndex) {
        [self juSetContentMinX:[NSIndexPath indexPathForRow:ju_currentIndex inSection:0]];
    }
}
//赋值已选择
-(void)setJu_arrImage:(NSArray *)ju_arrImage{
    _ju_arrImage=ju_arrImage;
    totalCount=_ju_arrImage.count;
    [self juSetStatus];
    self.hidden=totalCount==0;
}

-(void)setDoneCount:(NSInteger)count{
    if (count) {
        totalCount++;
    }else{
        totalCount--;
    }
    ju_btnDone.enabled=totalCount>0;
    ju_btnDone.alpha=totalCount>0?1:0.5;
    [self juSetStatus];
}

-(void)juSetStatus{
    [ju_btnDone setTitle:[NSString stringWithFormat:@"完成(%d)",totalCount] forState:UIControlStateNormal];
    [ju_collectImage reloadData];
}

-(void)setBaseView{
    ju_btnDone=[[UIButton alloc]init];
    ju_btnDone.backgroundColor=Photo_btnColor;

    [ju_btnDone.layer setCornerRadius:2];
    [ju_btnDone.layer setMasksToBounds:YES];
    [ju_btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ju_btnDone addTarget:self action:@selector(juTouchDone) forControlEvents:UIControlEventTouchUpInside];
    ju_btnDone.contentEdgeInsets=UIEdgeInsetsMake(4, 16, 4, 16);
    ju_btnDone.titleLabel.font=[UIFont systemFontOfSize:16];
    [self addSubview:ju_btnDone];
    ju_btnDone.juOrigin(CGPointMake(-12, -17));
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset=UIEdgeInsetsMake(0, 12, 0, 12);
    layout.itemSize=CGSizeMake(56, 56);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 10;
    
    ju_collectImage=[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    ju_collectImage.dataSource = self;
    ju_collectImage.delegate=self;
    ju_collectImage.showsHorizontalScrollIndicator=NO;
    [ju_collectImage registerClass:[JuAlbumSelectCell class] forCellWithReuseIdentifier:@"JuAlbumSelectCell"];
    ju_collectImage.showsVerticalScrollIndicator=NO;
    ju_collectImage.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
    [self addSubview:ju_collectImage];
    ju_collectImage.juFrame(CGRectMake(0, -64, 0, 60));
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _ju_arrImage.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    JuImageObject *objec=_ju_arrImage[indexPath.row];
    JuAlbumSelectCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"JuAlbumSelectCell" forIndexPath:indexPath];
    [cell setCellContent:_ju_arrImage[indexPath.row]];
    [cell setCurrentIndex:_ju_currentIndex==indexPath.row];
        return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _ju_currentIndex=indexPath.row;
    if (self.ju_hanlleIndex) {
        self.ju_hanlleIndex(_ju_currentIndex);
    }
    [collectionView reloadData];
    [self juSetContentMinX:indexPath];
}

-(void)juTouchDone{
    if (self.ju_hanlleDone) {
        self.ju_hanlleDone();
    }
}

//选中居中显示
-(void)juSetContentMinX:(NSIndexPath *)indexPath{
    [ju_collectImage scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end



@implementation JuAlbumSelectCell{
    UIImageView *ju_imgView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self zjuSetSubViews];
    }
    return self;
}

-(void)zjuSetSubViews{
    ju_imgView=[[UIImageView alloc]init];
    [ju_imgView setClipsToBounds:YES];
    [ju_imgView setContentMode:UIViewContentModeScaleAspectFill];
    [self.contentView addSubview:ju_imgView];
    ju_imgView.juEdge(UIEdgeInsetsMake(0, 0, 0, 0));
    [self.layer setBorderColor:Photo_btnColor.CGColor];
}

-(void)setCurrentIndex:(BOOL)isSelect{
    if (isSelect) {
        [self.layer setBorderWidth:2];
    }else{
        [self.layer setBorderWidth:0];
    }
}

-(void)setCellContent:(PHAsset *)ju_asset{
    ju_imgView.alpha=ju_asset.isSelect?1:0.5;
    __weak typeof(self) weakSelf = self;
    [ju_asset juRequestImageSize:CGSizeMake(200, 200) handle:^(UIImage * _Nonnull image) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf->ju_imgView.image=image;
    }];
}

@end
