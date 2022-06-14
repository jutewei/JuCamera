//
//  JuPlayVoice.h
//  PFBPublic
//
//  Created by Juvid on 2017/11/30.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
@interface JuPlayVoice : NSObject<AVAudioPlayerDelegate>

@property (nonatomic ,strong)AVAudioPlayer *ju_Player;//播放

-(void)juPlayVoice:(NSString *)voiceFile isBundle:(BOOL)isBundle;

@end

