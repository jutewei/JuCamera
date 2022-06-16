//
//  JuEqualItemView.h
//  PABase
//
//  Created by Juvid on 2018/3/23.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger,JuMultiEqualType) {
    JuMultiEqualNone ,///< 从左向右排列 view的宽度由内容决定
    JuMultiEqualWH ,///< 每个item的宽=高 view的宽度由内容决定
    JuMultiEqualW ,///< 每个item的规格相等（宽相等，高相等）铺满整个view
};
@interface JuMultiItemView : UIView
@property (nonatomic,readonly) NSArray *ju_subViews;

+(id)juInitItems:(NSArray *)items classStr:(NSString *)classStr;
+(id)juInitItems:(NSArray *)items classStr:(NSString *)classStr space:(NSInteger )space isEqual:(JuMultiEqualType)isEqual;

-(void)juInitItems:(NSArray *)items classStr:(NSString *)classStr;
-(void)juInitItems:(NSArray *)items classStr:(NSString *)classStr space:(NSInteger )space isEqual:(JuMultiEqualType)isEqual;
-(void)removeAllItems;
@end


@interface UIView(content)
-(void)juSetBaseContent:(id)content;
@end
