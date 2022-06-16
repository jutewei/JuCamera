//
//  APPConfig.h
//  PABase
//
//  Created by Juvid on 2019/5/20.
//  Copyright © 2019 Juvid. All rights reserved.
//

#ifndef APPConfig_h
#define APPConfig_h
    #import "JuLogLevel.h"

#ifdef DEBUG
/*=====================开发环境可配置=====================*/
#define APPAPI_NUMBER 1 //0为可配置IP，1为正式环境IP

/**********log配置************/
#define JuLogLevel LogLevelDebug

#else

/*======================发布环境禁止更改（除特殊情况）=====================*/
#define APPAPI_NUMBER 1
/********log配置*********/
#define JuLogLevel LogLevelOff


#endif

#endif /* APPConfig_h */
