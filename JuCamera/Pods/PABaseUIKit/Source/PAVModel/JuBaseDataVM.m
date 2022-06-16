//
//  JuBaseData.m
//  PABase
//
//  Created by Juvid on 2021/4/20.
//

#import "JuBaseDataVM.h"

@implementation JuBaseDataVM{
    __weak UIScrollView *zl_scrollView;
}

+(instancetype)zlInitWithContentView:(UIScrollView *)contentView{
    JuBaseDataVM *vm=[[[self class]alloc]init];
    [vm setContentView:contentView];
    return vm;
}

-(void)setContentView:(UIScrollView *)contentView{
    zl_scrollView=contentView;
    [self zlSetBaseDadas];
}

-(void)zlSetBaseDadas{
    
}
-(void)setZl_data:(id)zl_data{
    _zl_data=zl_data;
}
//分页处理
-(void)setArrList:(NSMutableArray *)mArrList isPage:(BOOL)isPage{
    if(!_zl_mArrList) _zl_mArrList=[NSMutableArray array];
    if (![mArrList isKindOfClass:[NSArray class]]) {//数据异常处理
        if(self.zl_pageSize.zl_isFirstPage){
            [_zl_mArrList removeAllObjects];
        }
    }else{
        if (isPage) {//分页情况
            if (self.zl_pageSize.zl_isFirstPage) [_zl_mArrList removeAllObjects];//第一页请求
            [_zl_mArrList addObjectsFromArray:mArrList];
        }
        else {//不分页情况
            _zl_mArrList=mArrList;
        }
    }
}
-(BOOL)isNoData{
    if (self.zl_mArrList.count==0&&!self.zl_data) {
        return YES;
    }
    return NO;
}
-(NSMutableArray *)zl_mArrList{
    if (_zl_mArrList==nil) {
        _zl_mArrList=[NSMutableArray array];
    }
    return _zl_mArrList;
}

-(void)zlReloadData{
    [self zlReloadData:zl_scrollView];
}

-(void)zlReloadData:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        UITableView *sh_TableView=(id)scrollView;
        [sh_TableView reloadData];
    }else if ([scrollView isKindOfClass:[UICollectionView class]]){
        UICollectionView *sh_CollectionView=(id)scrollView;
        [sh_CollectionView reloadData];
    }
}


-(PAPageModel *)zl_pageSize{
    if (!_zl_pageSize) {
        _zl_pageSize=[PAPageModel juInitM];
    }
    return _zl_pageSize;
}
-(NSInteger)sections{
    return self.zl_mArrList.count;
}
-(NSInteger)sectionRows:(NSInteger)section{
    return [self.zl_mArrList[section] count];
}

-(id)sectionRowData:(NSIndexPath *)indexPath{
    return nil;
}
-(id)sectionData:(NSInteger)section{
    return nil;
}
@end

