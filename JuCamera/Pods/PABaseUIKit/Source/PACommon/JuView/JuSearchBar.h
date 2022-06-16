//
//  KKSearchBar.h
//  KKSearchBar
//
//  Created by Leo on 15/6/17.
//  Copyright (c) 2015年 Juvid(zhutianwei). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JuTextField.h"

typedef NS_ENUM(NSInteger, JuSearchType) {
    JuSearchTypeNone = 0, // 默认情况（需要点搜索按钮）
    JuSearchTypeWord = 1, // 完整搜索（不需要点搜索，框内无高亮的字）
    JuSearchTypeFast = 2, // 快速搜索（有输入即搜索）
};

typedef void(^JuSearchBarClickHandle)(NSString *searchText);

@protocol JuCusSearchDelegate ;

@interface JuSearchTextField : JuTextField
@property (nonatomic,weak)  id<JuTextFieldDelegate> juDelegate;
@property (nonatomic,assign)  JuSearchType searchType;
@end


@interface JuSearchBar : UIView<UITextFieldDelegate,JuTextFieldDelegate> 
//dispatch_block_t
@property (nonatomic,copy) JuSearchBarClickHandle searchHandle;
@property (nonatomic,weak) id<JuCusSearchDelegate> juDelegate;

@property (nonatomic, readonly) JuSearchTextField *textField;
@property (nonatomic, readonly) UIImageView *tipImageView;
@property (nonatomic, readonly) UIButton *btnCancel;

//@property (nonatomic) BOOL isDelegate;
@property (assign,nonatomic) BOOL isBecomeFirstResponder;
@property (nonatomic) BOOL unableEidt;
@property (nonatomic) NSInteger showCancel;

@property (nonatomic) CGFloat ju_space;
@property (nonatomic) CGFloat ju_searchHeight;

-(void)textFieldShouldClear;

@end

@protocol JuCusSearchDelegate <NSObject>
@optional
- (void)textFieldEndEditing:(UITextField *)textField;
- (void)textFieldShouldBeginEditing:(UITextField *)textField;
- (void)textFieldSearchResult:(NSString *)searchText;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
@end
