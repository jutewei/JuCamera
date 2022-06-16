//
//  PFBAVAuthorizationManage.h
//  PABase
//
//  Created by Juvid on 2018/9/4.
//  Copyright © 2018年 Juvid(zhutianwei). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>
@interface JuAuthorizationManage : NSObject

+(void)juCanRecordCompletion:(void(^)(AVAuthorizationStatus status))completion;
/**
 恢复其他app播放
 */
+(void)juRePlayOthersAppVoice;
@end
