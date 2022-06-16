//
//  PABaseCollectVC.m
//  PABase
//
//  Created by Juvid on 2021/4/19.
//

#import "PABaseCollectVC.h"
#import "UIView+highlight.h"
@interface PABaseCollectVC ()

@end

@implementation PABaseCollectVC

@synthesize zl_collectView;

- (void)viewDidLoad {
    [super viewDidLoad];
}

//文本编辑
-(void)setIsTextInput:(BOOL)isTextEidt{
    if (isTextEidt) {
        _isTextInput=isTextEidt;
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
        gestureRecognizer.delegate=self;
        gestureRecognizer.cancelsTouchesInView = NO;
        [self.zl_collectView addGestureRecognizer:gestureRecognizer];
    }
}
-(void)mtSetManageConfig{
    self.ju_styleManage.zl_barStatus=JuNavBarStatusTranslucent;
}
#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if([touch.view isKindOfClass:[UIButton class]]){
        return NO;
    }
    return YES;
}

#pragma mark 隐藏键盘
- (void) hideKeyboard:(UIGestureRecognizer *)sender{
    //    if (sh_ViemTime)  [sh_ViemTime shHidePick];
    [self.view endEditing:YES];
    [self.navigationController.view endEditing:YES];
}

-(void)zlSetScrollView{
    if (!zl_collectView.collectionViewLayout) {
        [self zlInitCollectionLayout];
    }else{
        zl_flowLayout=(UICollectionViewFlowLayout *)zl_collectView.collectionViewLayout;
    }
    if (!zl_collectView) {
        UICollectionView *collect=[[self.zlCollectViewClass alloc]initWithFrame:CGRectZero collectionViewLayout:zl_flowLayout];
        [self.view addSubview:collect];
        zl_collectView=collect;
        [self zlSetCollectFrame];

    }
    zl_collectView.delegate=self;
    zl_collectView.dataSource=self;
    zl_collectView.backgroundColor = UIColor.whiteColor;
    if (self.ju_styleManage.zl_topEdgeView) {
        UIView *viewBack=[[UIView alloc]init];
        viewBack.backgroundColor=PAColor_Background;
        [viewBack addSubview:self.ju_styleManage.zl_topEdgeView];
        zl_collectView.backgroundView=viewBack;
    }
    zl_collectView.alwaysBounceVertical=YES;
    zl_scrollView=zl_collectView;
    [self.view layoutIfNeeded];
}
-(void)zlSetCollectFrame{
    [self zlSetContentFrame:zl_collectView];
}
//-(void)setZl_refeshType:(JuRefreshType)ju_refeshType{
//    juDis_mian_after(0.01, ^{
//       [super setZl_refeshType:ju_refeshType];
//    });
//}
-(Class)zlCollectViewClass{
    return [UICollectionView class];
}

-(void)zlInitCollectionLayout{
    zl_flowLayout=[[UICollectionViewFlowLayout alloc] init];
    zl_flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    zl_flowLayout.minimumInteritemSpacing = 0;
    zl_flowLayout.minimumLineSpacing = 0;
    zl_flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark collectionView Delegate &datasource methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.zl_mArrList.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.collectviewCellWillHighlight) {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        cell.juSelectColor=JUColor_SelectSecond;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.collectviewCellWillHighlight) {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        cell.juSelectColor=nil;
    }
}
-(void)zlReloadAtIndexPath:(NSIndexPath*)indexPath{
    NSInteger rowNum = [self.zl_collectView numberOfItemsInSection:indexPath.section];
    if (indexPath.row<rowNum) {
        [self.zl_collectView reloadItemsAtIndexPaths:@[indexPath]];
    }
}
-(void)zlScrollSection:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes* attr = [self.zl_collectView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
    CGRect rect = attr.frame;
    [self.zl_collectView setContentOffset:CGPointMake(0, rect.origin.y) animated:YES];
//    UIEdgeInsets insets = self.zl_collectView.scrollIndicatorInsets;
//    rect.size = self.zl_collectView.frame.size;
//    rect.size.height -= insets.top + insets.bottom;
//    CGFloat offset = (rect.origin.y + rect.size.height) - self.zl_collectView.contentSize.height;
//    if ( offset > 0.0 ) rect = CGRectOffset(rect, 0, -offset);
//    [self.zl_collectView scrollRectToVisible:rect animated:YES];
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [super scrollViewDidScroll:scrollView];
//    static NSInteger currentIndex = 0;
//
//    CGRect visibleRect = (CGRect){.origin = self.zl_collectView.contentOffset, .size = self.zl_collectView.bounds.size};
//    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
//    NSIndexPath *visibleIndexPath = [self.zl_collectView indexPathForItemAtPoint:visiblePoint];
////        NSLog(@"%@",visibleIndexPath);
//    if (currentIndex == visibleIndexPath.section || visibleIndexPath == nil) {
//        return;
//    }
//    currentIndex = visibleIndexPath.section;
//    
//}
-(BOOL)collectviewCellWillHighlight{
    return NO;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"JuBaseCollectCell" forIndexPath:indexPath];
    return cell;
}

-(PABaseVC *)zlPreviewVC:(id <UIViewControllerPreviewing>)previewingContext{
    NSIndexPath *indexPath = [zl_collectView indexPathForCell:(UICollectionViewCell* )[previewingContext sourceView]];
    return [self zlPushNextVC:indexPath];
}

-(PABaseVC *)zlPushNextVC:(NSIndexPath *)indexPath{
    return nil;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
