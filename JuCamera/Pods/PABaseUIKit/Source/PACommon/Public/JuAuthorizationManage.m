//
//  PFBAVAuthorizationManage.m
//  PABase
//
//  Created by Juvid on 2018/9/4.
//  Copyright © 2018年 Juvid(zhutianwei). All rights reserved.
//

#import "JuAuthorizationManage.h"
#import "JuAlertView+actiont.h"
#import <UserNotifications/UserNotifications.h>
#import <Photos/Photos.h>


@implementation JuAuthorizationManage

+(void)juCanRecordCompletion:(void(^)(AVAuthorizationStatus status))completion
{
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (videoAuthStatus == AVAuthorizationStatusNotDetermined) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            juDis_main_async(^{
                if (!granted) {
                    [JuAlertView juAlertTitle:@"无法使用麦克风" message:@"请在iPhone的“设置-隐私-麦克风”中允许访问麦克风"];
                }
            });
        }];
        if (completion) {
            completion(videoAuthStatus);
        }
    }
    else if(videoAuthStatus == AVAuthorizationStatusRestricted || videoAuthStatus == AVAuthorizationStatusDenied) {
        [JuAlertView juAlertTitle:@"无法使用麦克风" message:@"请在iPhone的“设置-隐私-麦克风”中允许访问麦克风"];
        completion(videoAuthStatus);
    }
    else{
        completion(videoAuthStatus);
    }
}
/*
 *首先，我们需要先向设备注册激活声音打断AudioSessionSetActive(YES);,当然我们也可以通过 [AVAudioSession sharedInstance].otherAudioPlaying;这个方法来判断还有没有其它业务的声音在播放。 当我们播放完视频后，需要恢复其它业务或App的声音，这时我们可以在退到后台的事件中调用如下方法:
 */
+(void)juRePlayOthersAppVoice{
    NSError *error =nil;
    AVAudioSession *session = [AVAudioSession sharedInstance];

    // [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    BOOL isSuccess = [session setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];

    if (!isSuccess) {
        NSLog(@"__%@",error);
    }else{
        NSLog(@"成功了");
    }
}

+(void)mtNotificationCheck{
    if (!TARGET_IPHONE_SIMULATOR){///< 真机提示
        if (@available(iOS 10.0, *)) {
            [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *settings) {
                if(settings.authorizationStatus == UNAuthorizationStatusDenied){
                    juDis_main_async(^{
//                        [self mtShowMessage];
                    });
                }
            }];
        }else{
            if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
                juDis_main_async(^{
                    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
                    if (UIUserNotificationTypeNone == setting.types) {
//                        [self mtShowMessage];
                    }
                })
            }
        }
    }
}
+(void)photoCheck{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) {
            if (status==PHAuthorizationStatusDenied||status==PHAuthorizationStatusRestricted) {
                [JuAlertView juAlertTitle:@"无法使用iPhone相册" message:@"请在iPhone的“设置-隐私-照片”中允许访问相册"];
            }
//             imageHandle(nil);
            return;
        }
        
    }];
}
/*
+(BOOL)systemCamera:(UIImagePickerControllerSourceType)paramSourceType{
    if (paramSourceType==UIImagePickerControllerSourceTypePhotoLibrary) {
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if (authStatus ==ALAuthorizationStatusDenied || authStatus==ALAuthorizationStatusRestricted) {
            [JuAlertView shAlertTitle:@"无法使用iPhone相册" message:@"请在iPhone的“设置-隐私-照片”中允许访问相册"];
            return NO;
        }
    }
    else{
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus ==AVAuthorizationStatusDenied || authStatus==AVAuthorizationStatusRestricted){
            [JuAlertView shAlertTitle:@"无法使用iPhone相机" message:@"请在iPhone的“设置-隐私-相机”中允许访问相机"];
            return NO;
        }
    }
}*/
@end
