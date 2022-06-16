//
//  PABaseTableSectionView.h
//  PABase
//
//  Created by Juvid on 2021/4/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PABaseTableSectionView : UITableViewHeaderFooterView
@property (nonatomic,weak) UITableView *zl_tableView;
+(instancetype )zlRegisterNib:(UITableView *)tableView;

+(instancetype )zlRegisterClass:(UITableView *)tableView;

-(void)zlSetSubViews;

-(void)zlSetCellContent:(id)content;
@end

NS_ASSUME_NONNULL_END
