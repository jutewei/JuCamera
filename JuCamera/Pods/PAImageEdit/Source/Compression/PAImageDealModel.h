//
//  PAImageDealModel.h
//  PAImageEdit
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/9/8.
//

#import "PABaseModel.h"
#define PAImageDefaultWid 1200

typedef NS_ENUM(NSInteger, PAImageCompressType) {
    PAImageCompressTypeNone         = 0,//不压缩
    PAImageCompressTypeAuto         = 1,//自动压缩
    PAImageCompressTypeMinSide      = 2,//最小边 1080
    PAImageCompressTypeMaxSide      = 3,//最大边 1080
    PAImageCompressTypeHigh         = 4,//高清图

};

NS_ASSUME_NONNULL_BEGIN

@interface PAImageDealModel : PABaseModel

@property (nonatomic, assign) PAImageCompressType zl_type;///type值为1、2、3。除原图外，默认为（type=1）自动压缩
@property (nonatomic, assign) CGFloat zl_quality;
@property (nonatomic, assign) NSInteger zl_sideSize;
@property (nonatomic, copy)   NSString *zl_url;
@property (nonatomic, strong) UIImage *zl_image;

//高清图配置
@property (nonatomic, copy)   NSString *zl_originalModel;///0:不显示原图/超清按钮  1:原图 2:超清  默认1
@property (nonatomic, strong)   PAImageDealModel *zl_sharpConfig;

//最小边默认值初始化
+(PAImageDealModel *)zlDefaultWithImage:(UIImage *)image;

-(void)zlSetImage:(UIImage *)image isOriginal:(BOOL)isOriginal;

-(NSInteger)zlOriginalType;

//@property (nonatomic, strong) NSData *zl_data;

@end

NS_ASSUME_NONNULL_END
