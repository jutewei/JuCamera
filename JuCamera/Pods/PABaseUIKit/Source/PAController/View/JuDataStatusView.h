//
//  JuDataStatusView.h
//  PABase
//
//  Created by Juvid on 2017/8/23.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^__nullable JuDataStatusHandle)(NSInteger type);             //0 刷新 1完成
@interface JuDataStatusView : UIView
@property (nonatomic ,strong)UIImageView * _Nullable ju_ImgView;
@property (nonatomic ,strong)UIView * _Nullable ju_VieBox;
@property (nonatomic ,strong)UILabel * _Nullable ju_LabWarm;
@property (nonatomic ,strong)UIButton * _Nullable ju_btnFinish;
@property (nonatomic,copy  ) JuDataStatusHandle ju_touchHandle;  //回调
@property (nonatomic) CGFloat   ju_boxY;

@property (nonatomic) BOOL   ju_reLoad;///< 加载重新加载
+(instancetype _Nullable )initView:(UIView *_Nullable)view;
+(instancetype _Nullable )initView;

-(void)juSetStatusView:(NSString *_Nonnull)message;
/**
 *  @author Juvid, 16-05-18 10:05
 *
 *  <#Description#>
 *
 *  @param message   <#message description#>
 *  @param imageName <#imageName description#>
 */
-(void)juSetStatusView:(NSString *_Nullable)message
                 Image:(NSString *_Nullable)imageName;
/**
 *  @author Juvid, 16-05-18 10:05
 *
 *  <#Description#>
 *
 *  @param message   <#message description#>
 *  @param imageName <#imageName description#>
 *  @param actName   <#actName description#>
 */
-(void)juSetStatusView:(NSString *_Nullable)message
                 Image:(NSString *_Nullable)imageName
            withAction:(NSString *_Nullable)actName;
@end
