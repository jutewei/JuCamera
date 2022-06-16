//
//  JuDataManage.m
//  PABase
//
//  Created by Juvid on 2019/12/9.
//  Copyright © 2019 Juvid. All rights reserved.
//

#import "JuDataManage.h"
//#import "JuStringsManager.h"
@implementation JuDataManage
+(JuDataManage *)zlSowMessage:(NSString *)message{
    JuDataManage *model=[JuDataManage new];
    model.zl_noDataText=message;
    model.zl_imageName=@"net_data_loadfail";
    return model;
}
//-(PAPageModel *)zl_pageSize{
//    if (!_zl_pageSize) {
//        _zl_pageSize=[PAPageModel juInitM];
//    }
//    return _zl_pageSize;
//}
-(void)zlSetDataHint:(BOOL)isNoData{
    if (!self.zl_showNoDataHint) {///默认分页加载数据才有提示语
        self.zl_showNoDataHint=isNoData;
    }
    if (!self.zl_showFailHint) {
         self.zl_showFailHint=JUShowHintTypeShow;
    }
}
-(void)zlShowErrorStatus:(JUDataLoadStatus)status {
    if (status==JUDataLoadStatusFail){
        [self.zl_vieStatus juSetStatusView:@"加载失败" Image:@"data_loadFail" withAction:nil];
    }else if (status==JUDataLoadStatusNoNet){
        [self.zl_vieStatus juSetStatusView:@"无网络" Image:@"data_loadFail" withAction:@"重新加载"];
    }else if (status==JUDataLoadStatusNoData){
        [self.zl_vieStatus juSetStatusView:self.zl_noDataText Image:@"upload_noData" withAction:self.zl_actName];
    }
    if (status>JUDataLoadStatusNoData) {
        self.zl_vieStatus.ju_reLoad=YES;
    }
    
}
@end
