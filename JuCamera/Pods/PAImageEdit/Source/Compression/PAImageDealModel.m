//
//  PAImageDealModel.m
//  PAImageEdit
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/9/8.
//

#import "PAImageDealModel.h"

@implementation PAImageDealModel
@synthesize zl_image=_zl_image;

+(PAImageDealModel *)zlDefaultWithImage:(UIImage *)image{
    PAImageDealModel *model=[PAImageDealModel juInitM];
    model.zl_image=image;
    model.zl_type=PAImageCompressTypeMinSide;
    model.zl_quality=60;
    model.zl_sideSize=PAImageDefaultWid;
    return model;
}

-(void)zlSetImage:(UIImage *)image isOriginal:(BOOL)isOriginal{
    self.zl_image=image;
    if (isOriginal) {/// 原图优先原则
        if (self.zlOriginalType==2) {///高清图
            self.zl_type=PAImageCompressTypeHigh;
        }else{///原图
            self.zl_type=PAImageCompressTypeNone;
        }
    }else{
        if (self.zl_type==PAImageCompressTypeNone) {/// 默认压缩为自动压缩
            self.zl_type=PAImageCompressTypeAuto;
        }
    }
}

-(void)setZl_sharpConfig:(NSDictionary *)zl_sharpConfig{
    if ([zl_sharpConfig isKindOfClass:[NSDictionary class]]) {
        _zl_sharpConfig=[PAImageDealModel juToModel:zl_sharpConfig];
    }
}


-(UIImage *)zl_image{
    if (_zl_url.length&&(!_zl_image||![_zl_image isKindOfClass:[UIImage class]])) {
        _zl_image=[UIImage imageWithContentsOfFile:[_zl_url stringByReplacingOccurrencesOfString:@"file://" withString:@""]];
    }
    return _zl_image;
}

-(NSInteger)zlOriginalType{
    if (_zl_originalModel.length==0) {
        return 1;
    }
    return _zl_originalModel.intValue;
}

-(NSInteger)zl_sideSize{
    if (self.zl_type==PAImageCompressTypeHigh) {//高清图最小边
        if (_zl_sharpConfig&&_zl_sharpConfig.zl_sideSize>0) {
            return _zl_sharpConfig.zl_sideSize;
        }
        return 3024;
    }
//    if (self.zl_type==PAImageCompressTypeAuto||_zl_sideSize==0) {
//        return 1200;
//    }
//
    return _zl_sideSize;
}

-(CGFloat)zl_quality{
    if (self.zl_type==PAImageCompressTypeHigh) {//高清图最小质量
        if (_zl_sharpConfig&&_zl_sharpConfig.zl_quality>0) {
            return _zl_sharpConfig.zl_quality;
        }
        return 65;
    }
    return _zl_quality;
}

//-(void)setZl_image:(id)zl_image{
//    if ([zl_image isKindOfClass:[NSData class]]) {
//        _zl_data=zl_image;
//    }else if([zl_image isKindOfClass:[UIImage class]]){
//        _zl_image=zl_image;
//    }
//}

@end
