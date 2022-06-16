//
//  PABaseScrollVC.h
//  PABase
//
//  Created by Juvid on 2021/4/19.
//

#import "PABaseVC.h"
#import "JuBaseDataVM.h"
#import "UIScrollView+JuRefresh.h"

NS_ASSUME_NONNULL_BEGIN

@interface PABaseScrollVC : PABaseVC<UIScrollViewDelegate,UIViewControllerPreviewingDelegate>{
    __weak  UIScrollView *zl_scrollView;
    NSIndexPath *zl_indexPath;
//    NSMutableArray *_zl_mArrList;
}

//@property (nonatomic,strong) NSMutableArray  *zl_mArrList;   ///< 列表数据

@property (nonatomic,strong) JuBaseDataVM     *zl_baseVMData;   ///< 对象数据

@property (nonatomic,assign) JuRefreshType    zl_refeshType;  ///< 0隐藏 1首次自动刷新 2、不自动动刷新 是否刷新

@property (nonatomic,copy) JuDataResult     zl_dataResult;  ///< 数据加载结果
@property (nonatomic,strong,nullable) NSMutableArray     *zl_mArrList;  ///< 数据加载结果
@property (nonatomic,strong,nullable) id  zl_data;  ///< 数据加载结果

@property (weak, nonatomic ) IBOutlet UIScrollView      *zl_scrollView;

//改变导航栏颜色
-(void)zlChangNavBarColor:(CGFloat)alpha;

//有数据不使用缓存
-(BOOL)isNotUseCache;

-(void)zlScrollTop:(BOOL)isDouble;

-(void)zlGetListData:(BOOL)isFristPage;///< 分页情况使用

-(void)zlStartRefresh;

-(PAPageModel *)zl_pageSize;

//-(NSMutableArray *)zl_mArrList;
//
////分页处理
//-(void)setZl_mArrList:(NSMutableArray *)sh_MArrList;

//无数据是否显示
-(void)setIsNoDataStatus:(BOOL)isNoDataStatus;

//数据加载是否失败显示
-(void)setIsFailStatus:(BOOL)isFail;

/**添加数据异常视图*/
-(void)zlSetStatusView:(JUDataLoadStatus)status;

-(UIView *)zlInitFootView:(BOOL)isAbsolute height:(CGFloat)height;
/**
 3D touch 按压预览
 
 @param view 按压的视图
 */
-(void)setRegisterPreviewingView:(UIView *)view;

-(PABaseVC *)zlPreviewVC:(id <UIViewControllerPreviewing>)previewingContext;

-(Class)zlVMDataClass;

-(void)zlReloadData;

-(void)zlSetContentFrame:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
