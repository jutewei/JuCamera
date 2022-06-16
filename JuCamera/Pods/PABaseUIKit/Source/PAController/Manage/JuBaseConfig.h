
//
//  JuBaseConfig.h
//  PABase
//
//  Created by Juvid on 2019/12/5.
//  Copyright © 2019 Juvid. All rights reserved.
//

#ifndef JuBaseConfig_h
#define JuBaseConfig_h
//导航栏状态
typedef NS_ENUM(NSInteger,JuNavBarStatus) {
    JuNavBarStatusNone          =0, ///< 默认正常
    JuNavBarStatusTranslucent   =2, ///< 半透明
    JuNavBarStatusHidden        =3, ///< 隐藏
    JuNavBarStatusSpecially     =4, ///< 指定颜色
    JuNavBarStatusLarge         =5, ///< 大标题
    JuNavBarStatusClear         =6, ///< 透明 到 不透明

//    JuNavBarStatusChange    =5, ///< 透明到不透明
};

typedef NS_ENUM(NSUInteger,JUDataLoadStatus) {
    JUDataLoadStatusNormal = 0,///< 数据正常
    JUDataLoadStatusNoData ,///< 无数据
    JUDataLoadStatusFail ,///< 加载失败
    JUDataLoadStatusNoNet ,///< 无网络
};

typedef NS_ENUM(NSInteger, JUWebContentType) {
    JUWebContentNone = 0,//普通网页
    JUWebContentShare = 1,//需要分享网页
};

typedef NS_ENUM(NSInteger, JUShowHintType) {
    JUShowHintTypeNone = 0,//未赋值
    JUShowHintTypeShow = 1,//显示
    JUShowHintTypeHide = 2,//隐藏
};

#define BV_Exception_Format @"在%@的子类中必须override:%@方法"
typedef  void (^JuDataResult) (id error);

#endif /* JuBaseConfig_h */
