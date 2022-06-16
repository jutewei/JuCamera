//
//  PABaseTableVC.h
//  PABase
//
//  Created by Juvid on 2021/4/19.
//

#import "PABaseScrollVC.h"
#import "PABaseTableView.h"

@interface PABaseTableVC : PABaseScrollVC<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>{
    BOOL zl_cellCanEdit;//cell可删除
    __weak  PABaseTableView *zl_tableView;
    UITableViewController *selfTVC;
}
@property (nonatomic,assign) BOOL       isAutoHeight;///< 高度自动适配
@property (nonatomic,assign) NSInteger  zlAutoHeight;///< 预估高度

@property (weak, nonatomic ) IBOutlet PABaseTableView    *zl_tableView;

-(BOOL)zlIsGroupedStyle;
-(BOOL)isShowFootSection;
-(BOOL)isShowHeadSection;
#pragma mark 删除行
-(void)zlDeleteRowPath:(NSInteger)removeRow;
-(void)zlDeleteRowPath:(NSInteger)removeRow forList:(NSMutableArray *)listMarr;

-(void)zlInsterRowPath:(id)addObj;
/**
 *  刷新行
 */
-(void)zlReloadRowPath;
-(void)zlReloadRowPaths:(NSArray *)indexPath;
-(void) hideKeyboard;
- (void) hideKeyboard:(UIGestureRecognizer *)sender;

@end


