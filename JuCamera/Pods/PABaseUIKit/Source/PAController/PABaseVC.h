//
//  PABaseViewC.h
//  PABase
//
//  Created by Juvid on 2021/4/19.
//

#import <UIKit/UIKit.h>
#import "JuSharedInstance.h"
#import "UIViewController+data.h"
#import "UIViewController+action.h"
#import "UIViewController+topBar.h"

#define ZLHandleData(value)                 if(self.zl_handleResult) self.sh_handleResult(value);
#define ZLHandleMultiData(first,second)     if(self.zl_handleMultiResult) self.sh_handleMultiResult(value);

typedef void(^__nullable JuHandleResult)(id _Nullable result);             //下步操作后有跟新数据
typedef void(^__nullable JuHandleMultiResult)(id _Nullable first,id _Nullable second);//下步操作后有有多个数据
@interface PABaseVC : UIViewController{
}
@property (nonatomic,copy  ) JuHandleResult         zl_handleResult;
@property (nonatomic,copy  ) JuHandleMultiResult    zl_handleMultiResult;
@property (nonatomic,copy,nullable) NSString    *zl_barTitle;

-(void)zlGetBaseData;

-(void)zlAppBecomeActive;

//zhu
//有导航栏按钮 必须重写事件
- (void)zlTouchRightItems:(UIButton *)sender;
//导航栏左边按钮 可重写事件
-(void)zlTouchLeftItems:(UIButton *)sender;

///< 无数据操作回调
-(void)zlNoDataStatusHandle;

-(void)zlSetManageConfig;

@end


