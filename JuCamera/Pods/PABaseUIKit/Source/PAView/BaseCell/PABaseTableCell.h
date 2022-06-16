//
//  PABaseTableCell.h
//  PABase
//
//  Created by Juvid on 2021/4/19.
//

#import <UIKit/UIKit.h>
#import "JuCellLine.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^__nullable ZLHandleResult)(id _Nullable result);             //

@interface PABaseTableCell : UITableViewCell{
   __weak NSIndexPath *zl_indexPath;
}

@property (nonatomic,weak) UITableView *zl_tableView;

@property (nonatomic,weak) NSIndexPath *zl_indexPath;

@property (nonatomic,weak) IBOutlet JuCellLine *zl_CellLine;

@property (nonatomic,weak) IBOutlet UIView *zl_EdgeContentView;

@property (nonatomic,strong) UIColor *zl_cellSelectColor;

@property (nonatomic,copy ) ZLHandleResult         zl_handleResult;
/**加班Nib中多个cell**/

+(instancetype )zlReuseIdentifier:(UITableView *)tableView index:(NSInteger)index;

/**注册Nib*Nib中只能有一个cell**/
+(instancetype )zlRegisterNib:(UITableView *)tableView;
/**注册class*Nib中只能有一个cell**/
+(instancetype )zlRegisterClass:(UITableView *)tableView;

/**
 无NIB的时候初始化使用
 */
-(void)zlSetSubViews;

-(void)zlSetCellLeft:(CGFloat)lead right:(CGFloat)trail;

-(void)zlSetCellTitle:(id)indexPath;

-(void)zlSetCellContent:(id)content;

-(void)zlSetCellContent:(id)content indexPath:(NSIndexPath *)indexPath;


@end

NS_ASSUME_NONNULL_END
