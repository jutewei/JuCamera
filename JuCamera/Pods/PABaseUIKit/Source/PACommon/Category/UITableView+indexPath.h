//
//  UITableView+indexPath.h
//  PABase
//
//  Created by Juvid on 2018/5/29.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (indexPath)
//遍历UITableViewCell
- (NSIndexPath *)juSubViewIndexPath:(UIView *)subview;

-(NSInteger)numberOfRows;
-(NSInteger)lastSection;
-(NSIndexPath *)indexPathForLastRow;
@end
