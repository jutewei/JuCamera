//
//  UITableView+indexPath.m
//  PABase
//
//  Created by Juvid on 2018/5/29.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "UITableView+indexPath.h"

@implementation UITableView (indexPath)
//遍历UITableViewCell
- (NSIndexPath *)juSubViewIndexPath:(UIView *)subview{
    if (!subview) return [NSIndexPath indexPathWithIndex:0];
    while (![subview isKindOfClass:[UITableViewCell class]]) {
        subview=subview.superview;
    }
    NSIndexPath * path = [self indexPathForCell:(UITableViewCell *)subview];
    return path;
}
-(NSInteger)numberOfRows{
    NSInteger section=0;
    NSInteger rowCout=0;
    while (section<[self numberOfSections]) {
        rowCout+=[self numberOfRowsInSection:section];
        section+=1;
    }
    return rowCout;
}
-(NSInteger)lastSection{
    return [self numberOfSections]>0?[self numberOfSections]-1:0;
}
-(NSInteger)lastSectionRow{
    return [self numberOfRowsInSection:self.lastSection]-1;
}
-(NSIndexPath *)indexPathForLastRow{
    if (self.numberOfRows>0) {
        return [NSIndexPath indexPathForRow:self.numberOfRows-1 inSection:[self lastSection]];
    }
    return nil;
}

@end
