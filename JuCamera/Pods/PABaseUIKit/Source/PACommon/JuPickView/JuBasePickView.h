//
//  JuBasePickView.h
//  JuBasePickView
//
//  Created by Juvid on 15/12/15.
//  Copyright © 2015年 Juvid(zhutianwei). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JuOutputDataModel.h"
typedef void(^JuHandleWithData)(JuOutputDataModel *model);             //下步操作后有跟新数据
@interface JuBasePickView : UIView{
    UILabel *ju_labTitle;
    UIView *ju_navigationBar;
    NSString *juShowValue,*juPostVale;
    JuOutputDataModel *ju_outputModel;
//    BOOL isNotKeyBoard;///< 是否键盘事件
}

@property (nonatomic,strong)NSString *ju_navTitle;//选择器标题

@property (nonatomic) BOOL juCanNoCancel;///< 不可取消时滚动停止即选择(默认可取消)

+(instancetype)initWitBackHandle:(JuHandleWithData)handleData;///< 键盘使用
+(instancetype)initWithView:(UIView *)view backHandle:(JuHandleWithData)handleData;/// 无键盘使用
+(instancetype)initWindowHandle:(JuHandleWithData)handleData;
//显示
-(void)juShowPick;
//隐藏
-(void)juHidePick;

-(void)juDidFinishData;
@end

