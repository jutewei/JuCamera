//
//  PABaseTableVC.m
//  PABase
//
//  Created by Juvid on 2021/4/19.
//

#import "PABaseTableVC.h"

@interface PABaseTableVC ()

@end

@implementation PABaseTableVC

@synthesize zl_tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
-(void)zlSetManageConfig{
    self.ju_styleManage.zl_barStatus=JuNavBarStatusTranslucent;
}
#pragma mark 设置table
-(void)zlSetScrollView{
    if (!zl_tableView) {
        PABaseTableView *table=[PABaseTableView zlInitTableWithStyle:self.zlIsGroupedStyle?UITableViewStyleGrouped:UITableViewStylePlain];
        [self.view addSubview:table];
        [self zlSetContentFrame:table];
        zl_tableView=table;
    }
    zl_tableView.delegate=self;
    zl_tableView.dataSource=self;
    selfTVC = [[UITableViewController alloc] init];
    selfTVC.clearsSelectionOnViewWillAppear=NO;
    selfTVC.tableView=self.zl_tableView;
    [self addChildViewController:selfTVC];

    zl_scrollView=zl_tableView;
}

-(BOOL)zlIsGroupedStyle{
    return YES;
}

-(void)setIsAutoHeight:(BOOL)isAutoHeight{
    if (isAutoHeight) {
        self.zlAutoHeight=52;
    }
}

-(void)setZlAutoHeight:(NSInteger)shAutoHeight{
    zl_tableView.rowHeight=UITableViewAutomaticDimension;
    zl_tableView.estimatedRowHeight=shAutoHeight;
}

#pragma mark 刷新行
-(void)zlReloadRowPath{
    if (zl_indexPath) {
        [self zlReloadRowPaths:@[zl_indexPath]];
    }
}

-(void)zlReloadRowPaths:(NSArray *)indexPath{
    [zl_tableView reloadRowsAtIndexPaths:indexPath withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark 插入行
-(void)zlInsterRowPath:(id)addObj{
    [self shInsterRowPath:addObj forList:self.zl_mArrList];
}
-(void)shInsterRowPath:(id)addObj forList:(NSMutableArray *)listMarr{
    [listMarr addObject:addObj];
    NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:self.zl_mArrList.count-1 inSection:zl_indexPath.section];
    [self.zl_tableView beginUpdates];
    [self.zl_tableView insertRowsAtIndexPaths:@[indexPathToInsert] withRowAnimation:UITableViewRowAnimationLeft];
    [self.zl_tableView endUpdates];
}

#pragma mark 删除行删除section 需自己写
-(void)zlDeleteRowPath:(NSInteger)removeRow{
    [self zlDeleteRowPath:removeRow forList:self.zl_mArrList];
}
-(void)zlDeleteRowPath:(NSInteger)removeRow forList:(NSMutableArray *)listMarr{
    [self.view endEditing:YES];
    [listMarr removeObjectAtIndex:removeRow];
    [self.zl_tableView beginUpdates];
    [self.zl_tableView deleteRowsAtIndexPaths:@[zl_indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self.zl_tableView endUpdates];
    self.isNoDataStatus=(self.zl_mArrList.count==0);
    //      [sh_TableView  deleteSections:[NSIndexSet indexSetWithIndex:sh_selectPath.section] withRowAnimation:UITableViewRowAnimationBottom];///< 删除section写法
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.zl_mArrList.count;
}


/*-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor=JUColor_ContentWhite;
    }
    else{ while ([cell.contentView.subviews lastObject]!=nil) {
        [[cell.contentView.subviews lastObject]removeFromSuperview];
    }}
    cell.textLabel.font=PAFFont_NormalText;
    cell.textLabel.textColor=PAColor_DarkGray;
    return cell;
}*/

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return self.isShowFootSection?10:0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.isShowHeadSection?10:0.001;
}

-(BOOL)isShowFootSection{
    return NO;
}

-(BOOL)isShowHeadSection{
    return NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    zl_indexPath=indexPath;
}

#pragma mark TableView 删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return zl_cellCanEdit;
}

-(PABaseVC *)mtPreviewVC:(id <UIViewControllerPreviewing>)previewingContext{
    NSIndexPath *indexPath = [zl_tableView indexPathForCell:(UITableViewCell* )[previewingContext sourceView]];
    return [self mtPushNextVC:indexPath];
}

-(PABaseVC *)mtPushNextVC:(NSIndexPath *)indexPath{
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
