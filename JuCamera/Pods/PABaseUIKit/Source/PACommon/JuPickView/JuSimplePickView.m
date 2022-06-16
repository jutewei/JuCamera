//
//  JuSimplePickView.m
//  PABase
//
//  Created by Juvid on 2020/12/26.
//  Copyright © 2020 Juvid. All rights reserved.
//

#import "JuSimplePickView.h"

@implementation JuSimplePickView

/**初始化设置数据*/
-(void)juSetDataList:(NSArray *)dataList{
    self.ju_MArrlist=[NSMutableArray arrayWithArray:dataList];;
    [self.ju_PickView reloadAllComponents];
}
/**设置滚轮标题*/
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    CGFloat count=self.ju_MArrlist.count;
    UILabel *pickerLabel = (UILabel *)view;
    if (pickerLabel == nil){
        CGRect frame = CGRectMake(0.0, 0.0, Screen_Width/count, self.juCellHeight);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:17]];
    }
    NSDictionary *adapter=self.ju_MArrlist[component][row];
    pickerLabel.text=adapter[@"name"];
    return pickerLabel;
}
-(CGFloat)juCellHeight{
    return 44;
}
/**停止滚动重新赋值*/
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.juCanNoCancel) {
        [self juDidFinishData];
    }
}
-(void)juWillFinishData{
    NSMutableArray *juShowArr=[NSMutableArray array];
    NSMutableArray *juPostArr=[NSMutableArray array];
    for (int i=0; i<self.ju_PickView.numberOfComponents; i++) {
        NSInteger selectRow = [self.ju_PickView selectedRowInComponent:i];
        NSDictionary *adapter=self.ju_MArrlist[i][selectRow];
        [juShowArr addObject:adapter[@"title"]];
        [juPostArr addObject:adapter[@"title"]];
    }
    ju_outputModel.juPostId=[juPostArr componentsJoinedByString:@","];
    ju_outputModel.juShowValue=[juShowArr componentsJoinedByString:@"-"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
