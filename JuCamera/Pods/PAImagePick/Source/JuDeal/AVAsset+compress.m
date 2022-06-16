//
//  AVAsset+compress.m
//  PAImagePick
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2022/4/12.
//

#import "AVAsset+compress.h"
#import "PHAsset+juDeal.h"
#import "AVAssetTrack+extends.h"

@implementation AVAsset (Export)

- (void)juExportWithPreset:(NSString *)presetName
                  progress:(JuProgresHandle)progress
                    handle:(JuVideoHandle)handle{
    // Find compatible presets by video asset.
    NSLog(@"开始时间：%@",NSDate.date);
    NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:self];
    if ([presets containsObject:presetName]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:self presetName:presetName];
        //转换完成保存的文件路径
        // NSLog(@"video outputPath = %@",outputPath);
        NSString *outputPath=[NSObject juGetTmpPath:@"mp4"];
        exportSession.outputURL = [NSURL fileURLWithPath:outputPath];
        //转换的数据是否对网络使用优化
        exportSession.shouldOptimizeForNetworkUse = true;
        NSArray *supportedTypeArray = exportSession.supportedFileTypes;
        if (supportedTypeArray.count == 0) {
            NSLog(@"视频类型暂不支持导出");
           if (handle) {
               handle(NO,@"视频类型暂不支持导出");
           }
            return;
        }else if ([supportedTypeArray containsObject:AVFileTypeMPEG4]) {//要转换的格式，这里使用 MP4
            exportSession.outputFileType = AVFileTypeMPEG4;
        } else {
            exportSession.outputFileType = [supportedTypeArray objectAtIndex:0];
        }
        AVMutableVideoComposition *videoComposition = [self getComposition];
        if (videoComposition.renderSize.width>0) {// 修正视频转向
            exportSession.videoComposition = videoComposition;
        }
        
//        进度回调
        __block BOOL isDealing = YES;
        if (progress) {
            dispatch_queue_t video_writer_queue = dispatch_queue_create("ju.videoprogress", DISPATCH_QUEUE_CONCURRENT);
            dispatch_async(video_writer_queue, ^{
                while (isDealing) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        progress(exportSession.progress);
                    });
                    [NSThread sleepForTimeInterval:0.1];
                }
            });
        }
        
        // Begin to export video to the output path asynchronously.
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
            isDealing=NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (progress) {
                    progress(exportSession.progress);
                }
                NSLog(@"结束时间：%@",NSDate.date);
                switch (exportSession.status) {
                    case AVAssetExportSessionStatusUnknown: {
                        NSLog(@"AVAssetExportSessionStatusUnknown");
                    }  break;
                    case AVAssetExportSessionStatusWaiting: {
                        NSLog(@"AVAssetExportSessionStatusWaiting");
                    }  break;
                    case AVAssetExportSessionStatusExporting: {
                        NSLog(@"AVAssetExportSessionStatusExporting");
                    }  break;
                    case AVAssetExportSessionStatusCompleted: {
                        NSLog(@"AVAssetExportSessionStatusCompleted");
                        if (handle) {
                            handle(YES,outputPath);
                        }
                    }  break;
                    case AVAssetExportSessionStatusFailed: {
                        NSLog(@"AVAssetExportSessionStatusFailed");
                        if (handle) {
                            handle(NO,@"导出失败");
                        }
                    }  break;
                    case AVAssetExportSessionStatusCancelled: {
                        NSLog(@"AVAssetExportSessionStatusCancelled");
                        if (handle) {
                            handle(NO,@"导出取消");
                        }
                    }  break;
                    default: break;
                }
            });
        }];
    }
    else {
        if (handle) {
            NSString *errorMessage = [NSString stringWithFormat:@"当前设备不支持该预设:%@", presetName];
            NSLog(@"%@", errorMessage);
            handle(NO,@"当前设备不支持该预设");
        }
    }
}
/// 获取优化后的视频转向信息
- (AVMutableVideoComposition *)getComposition{
    AVMutableVideoComposition *juVideoComposition = [AVMutableVideoComposition videoComposition];
    // 视频转向
    int degrees = [self setDegress];
    if (degrees != 0) {
        CGAffineTransform translateToCenter;
        CGAffineTransform mixedTransform;
        juVideoComposition.frameDuration = CMTimeMake(1, 30);
        
        NSArray *tracks = [self tracksWithMediaType:AVMediaTypeVideo];
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        
        AVMutableVideoCompositionInstruction *roateInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        roateInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, [self duration]);
        AVMutableVideoCompositionLayerInstruction *roateLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        
        if (degrees == 90) {
            // 顺时针旋转90°
            translateToCenter = CGAffineTransformMakeTranslation(videoTrack.naturalSize.height, 0.0);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI_2);
            juVideoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height,videoTrack.naturalSize.width);
            [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        } else if(degrees == 180){
            // 顺时针旋转180°
            translateToCenter = CGAffineTransformMakeTranslation(videoTrack.naturalSize.width, videoTrack.naturalSize.height);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI);
            juVideoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.width,videoTrack.naturalSize.height);
            [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        } else if(degrees == 270){
            // 顺时针旋转270°
            translateToCenter = CGAffineTransformMakeTranslation(0.0, videoTrack.naturalSize.width);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI_2*3.0);
            juVideoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height,videoTrack.naturalSize.width);
            [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        }
        
        roateInstruction.layerInstructions = @[roateLayerInstruction];
        // 加入视频方向信息
        juVideoComposition.instructions = @[roateInstruction];
    }
    return juVideoComposition;
}

// 获取视频角度
- (int)setDegress{
    int degress = 0;
    NSArray *tracks = [self tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
            // Portrait
            degress = 90;
        } else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
            // PortraitUpsideDown
            degress = 270;
        } else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
            // LandscapeRight
            degress = 0;
        } else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
            // LandscapeLeft
            degress = 180;
        }
    }
    return degress;
}

@end



@implementation AVAsset (compress)

+(void)juCompressWithPath:(NSString *)path
                      preset:(NSString*)presetName
                 progress:(JuProgresHandle)progress
                      handle:(JuVideoHandle)handle{
    if (!path) {
        return;
    }
//    AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:path]];
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:path] options:nil];
    [avAsset juCompressWithAsset:presetName progress:progress handle:handle];
}

-(void)juCompressWithAsset:(NSString*)presetName
                  progress:(JuProgresHandle)progressHandle
                    handle:(JuVideoHandle)handle{
    NSLog(@"开始时间：%@",NSDate.date);
//    读取视频流相关准备
    NSError *error;
    //创建AVAssetReader对象用来读取asset数据
    AVAssetReader *assetReader = [AVAssetReader assetReaderWithAsset:self error:&error];
    AVAsset *localAsset = assetReader.asset;

    AVAssetTrack *videoTrack = [[localAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    AVAssetTrack *audioTrack = [[localAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    if (!videoTrack||!audioTrack) {
        if (handle) {
            handle(NO,@"格式错误");
        }
        return;
    }

    //AVAssetReaderTrackOutput用来设置怎么读数据
    AVAssetReaderTrackOutput *videoOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:videoTrack outputSettings:self.videoSetting];
    //音频以pcm流的形似读数据
    AVAssetReaderTrackOutput *audioOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:audioTrack outputSettings:self.audioSetting];

    NSDictionary *videoCompress=[self videoCompressSetting:videoTrack presetName:presetName];
    if (!videoCompress) {
        if (handle) {
            AVURLAsset *avAsset = (AVURLAsset *)self;
            handle(YES,[NSString juSwitchFilePath:avAsset.URL.absoluteString]);
        }
        return;
//        返回原视频
    }
    if ([assetReader canAddOutput:videoOutput]) {
        [assetReader addOutput:videoOutput];
    }
    if ([assetReader canAddOutput:audioOutput]) {
        [assetReader addOutput:audioOutput];
    }
    //开始读
    [assetReader startReading];
    
//    写入视频流相关准备
    NSString *outputPath=[NSObject juGetTmpPath:@"mp4"];
    NSURL *outputUrl = [NSURL fileURLWithPath:outputPath];

    //AVAssetWriterInput用来说明怎么写数据
    AVAssetWriterInput* videoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoCompress];
    AVAssetWriterInput *audioInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:self.audioCompressSetting];
    
    //创建一个写数据对象
    AVAssetWriter *assetWriter = [[AVAssetWriter alloc] initWithURL:outputUrl fileType:AVFileTypeMPEG4 error:nil];
    
    if ([assetWriter canAddInput:videoInput]) {
        [assetWriter addInput:videoInput];
    }
    
    if ([assetWriter canAddInput:audioInput]) {
        [assetWriter addInput:audioInput];
    }
    //开始写
    [assetWriter startWriting];
    [assetWriter startSessionAtSourceTime:kCMTimeZero];
//    开始读写
    dispatch_group_t group = dispatch_group_create();
//    __block BOOL isVideoComplete = NO;
    dispatch_queue_t video_writer_queue = dispatch_queue_create("ju.videoWriter", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t audio_writer_queue = dispatch_queue_create("ju.audioWriter", DISPATCH_QUEUE_SERIAL);
    //要想写数据;就带有数据源;以下是将readerVideoTrackOutput读出来的数据加入到assetVideoWriterInput中再写入本地;音频和视频读取写入方式一样
//    图片流编码
    dispatch_group_enter(group);
    [videoInput requestMediaDataWhenReadyOnQueue:video_writer_queue usingBlock:^{
        while (videoInput.isReadyForMoreMediaData) {
            //样本数据
           @autoreleasepool {
                //每次读取一个buffer
                CMSampleBufferRef sampleBuffer = [videoOutput copyNextSampleBuffer];
                if (sampleBuffer) {
                    // update the video progress
                    CMTime  timeDuration = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
                    CGFloat progress = CMTimeGetSeconds(timeDuration)/CMTimeGetSeconds(self.duration);//self.duration;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (progressHandle) {
                            progressHandle(progress);
                        }
                    });
                    BOOL isReslut = [videoInput appendSampleBuffer:sampleBuffer];
                    CFRelease(sampleBuffer);
                    sampleBuffer = NULL;
                    if (!isReslut) {
                        [assetReader cancelReading];
                        dispatch_group_leave(group);
                        break;
                    }
                } else {
                    [videoInput markAsFinished];
                    dispatch_group_leave(group);
                    break;
                }
            }
        }
    }];
    
//    音频流编码
    dispatch_group_enter(group);
    [audioInput requestMediaDataWhenReadyOnQueue:audio_writer_queue usingBlock:^{
        while (audioInput.isReadyForMoreMediaData) {
            //样本数据
            @autoreleasepool {
                CMSampleBufferRef buffer = [audioOutput copyNextSampleBuffer];
                if (buffer) {
                    BOOL isReslut = [audioInput appendSampleBuffer:buffer];
                    CFRelease(buffer);
    //                buffer = NULL;
                    if (!isReslut) {
                        [assetReader cancelReading];
                        dispatch_group_leave(group);
                        break;
                    }
                } else {
                    //关闭写入会话
                    [audioInput markAsFinished];
                    dispatch_group_leave(group);
                    break;
                }
            }
        }
    }];

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (assetReader.status==AVAssetReaderStatusReading) {
            [assetReader cancelReading];
        }
        [assetWriter finishWritingWithCompletionHandler:^{
            AVAssetWriterStatus status = assetWriter.status;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (progressHandle) {
                    progressHandle(1);
                }
                if (handle) {
                    NSLog(@"结束时间：%@",NSDate.date);
                    handle(status == AVAssetWriterStatusCompleted?YES:NO,outputPath);
                    [assetWriter cancelWriting];
                }
            });
        }];
    });
}

-(NSDictionary *)audioSetting{
    return @{AVFormatIDKey : [NSNumber numberWithUnsignedInt:kAudioFormatLinearPCM]};
}

-(NSDictionary *)videoSetting{
    NSDictionary *dic=@{(id)kCVPixelBufferPixelFormatTypeKey     : [NSNumber  numberWithUnsignedInt:kCVPixelFormatType_32BGRA],
                        (id)kCVPixelBufferIOSurfacePropertiesKey: [NSDictionary dictionary],
    };
    return  dic;
}

-(NSDictionary *)videoCompressSetting:(AVAssetTrack *)videoTrack presetName:(NSString *)presetName{
    //配置写数据&#xff0c;设置比特率&#xff0c;帧率等
    NSString *strSize=[presetName stringByReplacingOccurrencesOfString:@"AVAssetExportPreset" withString:@""];
    NSArray *sizes=[strSize componentsSeparatedByString:@"x"];
    CGFloat minSize=[sizes.lastObject floatValue];

    CGSize naturalSize = videoTrack.naturalSize;
    if (minSize==0) {
        minSize=720;
    }
    CGFloat width=0,height=0;
    if (MIN(naturalSize.height, naturalSize.width)<=minSize) {
        width=naturalSize.width;
        height=naturalSize.height;
        if ([videoTrack estimatedDataRate]<(1.6*1024*1024)&&videoTrack.isH264) {
            NSLog(@"已经压缩过");
            return nil;
        }
    }
    else if (naturalSize.width>naturalSize.height) {
        height=minSize;
        width=(height/naturalSize.height)*naturalSize.width;
    }else{
        width=minSize;
        height=(width/naturalSize.width)*naturalSize.height;
    }
 
    NSDictionary *compressionProperties=@{AVVideoAverageBitRateKey :@(MIN(1.7*height*width, [videoTrack estimatedDataRate])),
                                           AVVideoExpectedSourceFrameRateKey:@(MIN(30, [videoTrack nominalFrameRate])),
                                           AVVideoProfileLevelKey : AVVideoProfileLevelH264HighAutoLevel};
    //配置编码器宽高等
    NSDictionary *compressionSetting =@{
                              AVVideoCodecKey                   :AVVideoCodecH264,
                              AVVideoWidthKey                   :@(width),
                              AVVideoHeightKey                  :@(height),
                              AVVideoCompressionPropertiesKey   : compressionProperties,
                              AVVideoScalingModeKey             :AVVideoScalingModeResizeAspectFill
                              };
    return compressionSetting;
}

-(NSDictionary *)audioCompressSetting{
    AudioChannelLayout stereoChannelLayout = {
        .mChannelLayoutTag = kAudioChannelLayoutTag_Stereo,
        .mChannelBitmap = 0,
        .mNumberChannelDescriptions = 0
    };
    NSData *channelLayoutAsData = [NSData dataWithBytes:&stereoChannelLayout length:offsetof(AudioChannelLayout, mChannelDescriptions)];
    //写入音频配置
    NSDictionary *compressionAudioSetting =@{
                                               AVFormatIDKey         : @(kAudioFormatMPEG4AAC),
                                               AVEncoderBitRateKey   : @(64000),
                                               AVSampleRateKey       : @(44100),
                                               AVChannelLayoutKey    : channelLayoutAsData,
                                               AVNumberOfChannelsKey : [NSNumber numberWithUnsignedInteger:2]
                                               };
    return compressionAudioSetting;
}
@end
/**
 要获取视频的分辨率，请使用： -
 AVAssetTrack * videoTrack = nil;
 AVURLAsset * asset = [AVAsset assetWithURL：[NSURL fileURLWithPath：originalVideo]];
 NSArray * videoTracks = [asset tracksWithMediaType：AVMediaTypeVideo];
 CMFormatDescriptionRef formatDescription = NULL;
 NSArray * formatDescriptions = [videoTrack formatDescriptions];
 if（[formatDescriptions count]> 0） formatDescription =（CMFormatDescriptionRef）[formatDescriptions objectAtIndex：0];
 if（[videoTracks count]> 0） videoTrack = [videoTracks objectAtIndex：0];
 CGSize trackDimensions = { .width = 0.0， .height = 0.0，};
 trackDimensions = [videoTrack naturalSize];   int width = trackDimensions.width;
 int height = trackDimensions.height;
 NSLog（@Resolution =％d X％d，width，height）;
 */
/*
 您可以得到frameRate和bitrate如下： -
 float frameRate = [videoTrack nominalFrameRate];
 float bps = [videoTrack estimatedDataRate];
 NSLog（@Frame rate ==％f，frameRate）;  NSLog（@bps rate ==％f，bps）;
 **/
