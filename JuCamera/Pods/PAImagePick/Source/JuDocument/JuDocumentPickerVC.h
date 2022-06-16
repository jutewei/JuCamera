//
//  JUDocumentPickerVC.h
//  TestImage
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/5/19.
//

#import <UIKit/UIKit.h>
typedef void(^__nullable JuDocumentHandle)(id  _Nullable reslut);
NS_ASSUME_NONNULL_BEGIN

@interface JuDocumentPickerVC : UIDocumentPickerViewController

@property (nonatomic,copy)dispatch_block_t ju_cancel;

+(instancetype)initDocumentPickHandle:(JuDocumentHandle)handle;

+(instancetype)initDocumentPickWithType:(NSArray *)types
                                 handle:(JuDocumentHandle)handle;

+(instancetype)initDocumentPickWtihVC:(UIViewController *)vc
                                handle:(JuDocumentHandle)handle;

+(NSArray *)fileTypes;

@end

@interface JuPreShareDocumentVC : NSObject<UIDocumentInteractionControllerDelegate>

@end
NS_ASSUME_NONNULL_END
