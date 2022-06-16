//
//  JuMultiPickView.m
//  PABase
//
//  Created by Juvid on 2018/12/5.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuMultiPickView.h"
#import "UIView+Frame.h"
#import "JuInputDataAdapter.h"

@implementation JuMultiPickView{
    NSInteger juComponents;
    Class juAdapterClass;
}

-(CGFloat)juPickHeight{
    return 300;
}
-(void)juSetPickView{
    UIPickerView *datePick=[[UIPickerView alloc]init];
    datePick.delegate=self;
    datePick.dataSource=self;
    datePick.backgroundColor=[UIColor whiteColor];
    [self addSubview:datePick];
    datePick.juFrame(CGRectMake(0.01, -0.01, 0, self.juPickHeight-51));
    [self layoutIfNeeded];
    _ju_PickView=datePick;
}
/**单个数据*/
-(void)juSetSingleDataList:(NSArray *)dataList{

    [self juSetDataList:dataList component:1 adapterCls:[JuInputDataAdapter class]];
    [self juShowPick];
}

/**初始化设置数据*/
-(void)juSetDataList:(NSArray *)dataList component:(NSInteger)component adapterCls:(Class)adapter{
    if (!dataList) {
        return;
    }
    juComponents=component;
    juAdapterClass=adapter;
    _ju_MArrlist=[NSMutableArray arrayWithObject:dataList];;
    NSArray *arrNextList=dataList;
    for (int i=1; i<juComponents; i++) {
        JuInputDataAdapter *adapter=[self juGetAadper:arrNextList[0]];
        [_ju_MArrlist addObject:adapter.juArrList];
        arrNextList=adapter.juArrList;
    }
    [_ju_PickView reloadAllComponents];
}

-(JuInputDataAdapter *)juGetAadper:(id)data{
    if ([data isKindOfClass:[JuInputDataAdapter class]]) {
        return data;
    }
    return [[juAdapterClass alloc]initWithData:data];
}
#pragma mark _______picker datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return [_ju_MArrlist count];
}
////确定picker的每个轮子的item数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_ju_MArrlist[component] count];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return self.juCellHeight;
}
-(CGFloat)juCellHeight{
    return 44;
}
/**设置滚轮标题*/
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    CGFloat count=juComponents;
    UILabel *pickerLabel = (UILabel *)view;
    if (pickerLabel == nil){
        CGRect frame = CGRectMake(0.0, 0.0, Screen_Width/count, self.juCellHeight);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:17]];
    }
    JuInputDataAdapter *adapter=[self juGetAadper:_ju_MArrlist[component][row]];
    pickerLabel.text=adapter.juTitle;
    return pickerLabel;
}
/**停止滚动重新赋值*/
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    for (NSInteger i=component+1; i<juComponents; i++) {
        NSInteger rows=[pickerView selectedRowInComponent:i-1];
        JuInputDataAdapter *adapter=[self juGetAadper:_ju_MArrlist[i-1][rows]];
        [_ju_MArrlist replaceObjectAtIndex:i withObject:adapter.juArrList];
        [pickerView reloadComponent:i];
        if ([adapter.juArrList count]>0) {
             [pickerView selectRow:0 inComponent:i animated:NO];
        }
    }
    if (self.juCanNoCancel) {
        [self juDidFinishData];
    }
//    UILabel *lab=(UILabel *)[pickerView viewForRow:row forComponent:component];
//    lab.textColor=[UIColor redColor];
}
-(void)juWillFinishData{
    NSMutableArray *juShowArr=[NSMutableArray array];
    NSMutableArray *juPostArr=[NSMutableArray array];
    for (int i=0; i<self.ju_PickView.numberOfComponents; i++) {
        NSInteger selectRow = [self.ju_PickView selectedRowInComponent:i];
        JuInputDataAdapter *adapter=[self juGetAadper:_ju_MArrlist[i][selectRow]];
        [juShowArr addObject:adapter.juTitle];
        [juPostArr addObject:adapter.juId];
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
