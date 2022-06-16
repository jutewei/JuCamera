//
//  JuThreadManage.h
//  PABase
//
//  Created by Juvid on 2018/5/22.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#ifndef JuThreadManage_h
#define JuThreadManage_h

/**回主线程*/
#define juDis_main_sync(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define juDis_main_async(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

//线程单利（并行）
#define juDis_global_default_async(block)\
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{\
if (block){\
block();\
}\
});
//线程单利（并行）
#define juDis_global_low_async(block)\
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{\
if (block){\
block();\
}\
});

//延迟执行
#define juDis_mian_after(time,block)\
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{\
    if (block){\
        block();\
    }\
});

//创建串行
#define juDis_queue_serial_create(name)\
    dispatch_queue_create(name, DISPATCH_QUEUE_SERIAL)

//创建并行
#define juDis_queue_concurrent_create(name)\
dispatch_queue_create(name, DISPATCH_QUEUE_CONCURRENT)

//串行执行
#define juDis_serial_async(name,block)\
dispatch_async(dispatch_queue_create(name, DISPATCH_QUEUE_SERIAL), ^{\
if (block){\
block();\
}\
});

//并行执行
#define juDis_concurrent_async(name,block)\
dispatch_async(dispatch_queue_create(name, DISPATCH_QUEUE_CONCURRENT), ^{\
if (block){\
block();\
}\
});

#endif /* JuThreadManage_h */
