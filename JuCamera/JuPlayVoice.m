//
//  JuPlayVoice.m
//  PFBPublic
//
//  Created by Juvid on 2017/11/30.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import "JuPlayVoice.h"

@implementation JuPlayVoice
@synthesize ju_Player;
-(id)init{
    self=[super init];
    if (self) {
        //添加监听
    }
    return self;
}
//处理监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES){
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else
    {
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

-(void)juPlayVoice:(NSString *)voiceFile isBundle:(BOOL)Bundle{

    if ([ju_Player isPlaying]) {
        return;
    }

//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    NSError *sessionError;
//    [session setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
//
//    if(session == nil){
//        NSLog(@"初始化失败");
//        return;
//    }
//    else
//        [session setActive:YES error:nil];

    NSError *error;

    NSURL *voiceUrl;
    if (Bundle) {
        voiceUrl=[[NSBundle mainBundle] URLForResource:voiceFile withExtension:nil];
    }else{
        voiceUrl=[NSURL URLWithString:voiceFile];
    }

    ju_Player=[[AVAudioPlayer alloc]initWithContentsOfURL:voiceUrl
                                                   error:&error];

    ju_Player.delegate=self;
    ju_Player.volume=1.0;
    //准备播放
    if(ju_Player!=nil) [ju_Player prepareToPlay];
    //播放
    if(error==nil){
        [ju_Player play];
        NSLog(@"正在播放语音");
        [self shStartNotification];
    }else{
          NSLog(@"文件损坏、播放失败");
    }
}



- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
        NSLog(@"语音播放完成");
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{

  NSLog(@"语音播放失败");

}
//播放器遇到中断的时候（如来电），调用该方法
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    NSLog(@"语音播放停止");
}
//中断事件结束后调用下面的方法
-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags{
    //可以什么都不做，让用户决定是继续播放还是暂停
}
-(void)dealloc{
    [self shStopNotification];
}
-(void)shStopNotification{
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
}
-(void)shStartNotification{
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sensorStateChange:)
                                                 name:@"UIDeviceProximityStateDidChangeNotification"
                                               object:nil];
}
@end
