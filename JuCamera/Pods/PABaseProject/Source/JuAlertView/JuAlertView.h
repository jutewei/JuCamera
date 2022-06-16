//
//  JuAlertView.h
//  PABase
//
//  Created by Juvid on 2017/8/24.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JuAlertAction;
typedef void(^JuActionHandle)(JuAlertAction *action);//下步操作后有跟新数据
@interface JuAlertView : UIAlertView<UIAlertViewDelegate>

@property (nonatomic,copy)  JuActionHandle handler;///< 点击确认按钮回调
//@property (nonatomic,copy)  dispatch_block_t callbackOther;///< 点击确认按钮回调
//@property (nonatomic,copy)  dispatch_block_t callbackCancle;///< 点击取消按钮回调


/**
 新方法【确定】无回调
 @param title 标题
 @param message 消息
 @return 弹框
 */
+(JuAlertView *)juAlertTitle:(nullable NSString *)title
                       message:(nullable NSString *)message;

/**
 弹框【确定】有回调
 
 @param title 标题
 @param message 内容
 @param handler 回调
 @return 弹框
 */
+(JuAlertView *)juAlertTitle:(nullable NSString *)title
                       message:(nullable NSString *)message
                       handler:(JuActionHandle)handler;

/**
 【确定】【取消】有回调
 
 @param title 标题
 @param message 内容
 @param handler 回调
 @return 弹框
 */
+(JuAlertView *)juDoubleAlert:(nullable NSString *)title
                        message:(nullable NSString *)message
                        handler:(JuActionHandle)handler;

///**
// plist文件弹框
//
// @param keyName 键
// @param handler 回调
// @return 弹框
// */
//+(JuAlertView *)juWarnAlert:(NSString *)keyName
//                      handler:(JuActionHandle)handler;

/**
 自定义多个按钮
 
 @param title 标题
 @param message 内容
 @param items 按钮数组
 @param handler 回调
 @return 弹框
 */
+(JuAlertView *)juAlertTitle:(nullable NSString *)title
                       message:(nullable NSString *)message
                   actionItems:(NSArray *)items
                       handler:(JuActionHandle)handler;

/**
 自定义内容显示样式
 
 @param title 标题
 @param message 内容
 @param items 按钮数组
 @param handler 回调
 @return 弹框
 */
+(JuAlertView *)juAlertTitle:(nullable NSString *)title
                  messageAttri:(nullable NSAttributedString *)message
                   actionItems:(NSArray *)items
                       handler:(JuActionHandle)handler;

@end


@interface JuActionSheet : UIActionSheet<UIActionSheetDelegate>

+(id)juSheetTitle:(nullable NSString *)title
      actionItems:(NSArray *)items
          handler:(JuActionHandle)handler;

+(JuActionSheet *)juSheetTitle:(nullable NSString *)title
                   actionItems:(NSArray *)items
                      withView:(UIView *)view
                       handler:(JuActionHandle)handler;

@property (nonatomic,copy)  JuActionHandle handler;///< 点击确认按钮回调
@end



@interface JuAlertAction : NSObject
@property (nonatomic,strong) NSString *ju_title;
@property (nonatomic,strong) NSString *ju_content;
@property (nonatomic) NSInteger ju_index;

-(BOOL)cancelButton;
-(BOOL)otherButton;
-(BOOL)confirmButton;
-(BOOL)firstButton;
+(id)juSetTitle:(NSString *)title clickedIndex:(NSInteger)buttonIndex;
@end

