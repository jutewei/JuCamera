//
//  JuVideoEditManage.m
//  PAImagePick
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2022/4/11.
//

#import "JuVideoEditManage.h"
#import "PHAsset+juDeal.h"

@implementation JuVideoEditManage{
    dispatch_queue_t video_writer_queue;
    dispatch_queue_t audio_writer_queue;
}

+ (instancetype) sharedInstance{
    static JuVideoEditManage *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(instancetype)init{
    self=[super init];
    if (self) {
        video_writer_queue = dispatch_queue_create("ju.videoWriter", DISPATCH_QUEUE_SERIAL);
        audio_writer_queue = dispatch_queue_create("ju.audioWriter", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

-(void)juCompressionWithPath:(NSString *)path
                      preset:(NSString*)presetName
                      handle:(void (^)(BOOL success,NSString *result))handle{
    if (!path) {
        return;
    }
    AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:path]];
    [self juCompressionWithAsset:asset preset:presetName handle:handle];
}

-(void)juCompressionWithAsset:(AVAsset *)asset
                       preset:(NSString*)presetName
                       handle:(void (^)(BOOL success,NSString *result))handle{
    NSLog(@"开始时间：%@",NSDate.date);
    NSError *error;
    //创建AVAssetReader对象用来读取asset数据
    AVAssetReader *assetReader = [AVAssetReader assetReaderWithAsset:asset error:&error];
    AVAsset *localAsset = assetReader.asset;

    AVAssetTrack *videoTrack = [[localAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    AVAssetTrack *audioTrack = [[localAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];

    //AVAssetReaderTrackOutput用来设置怎么读数据
    AVAssetReaderTrackOutput *videoOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:videoTrack outputSettings:self.videoSetting];
    //音频以pcm流的形似读数据
    AVAssetReaderTrackOutput *audioOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:audioTrack outputSettings:self.audioSetting];

    if ([assetReader canAddOutput:videoOutput]) {
        [assetReader addOutput:videoOutput];
    }
    if ([assetReader canAddOutput:audioOutput]) {
        [assetReader addOutput:audioOutput];
    }
    //开始读
    [assetReader startReading];
    
    NSString *outputPath=[NSObject juGetTmpPath:@"mp4"];
    NSURL *outputUrl = [NSURL fileURLWithPath:outputPath];
    //创建一个写数据对象
    AVAssetWriter *assetWriter = [[AVAssetWriter alloc] initWithURL:outputUrl fileType:AVFileTypeMPEG4 error:nil];
    NSString *strSize=[presetName stringByReplacingOccurrencesOfString:@"AVAssetExportPreset" withString:@""];
    NSArray *sizes=[strSize componentsSeparatedByString:@"x"];
    //AVAssetWriterInput用来说明怎么写数据
    AVAssetWriterInput* videoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:[self videoCompressSetting:videoTrack.naturalSize minSize:[sizes.lastObject floatValue]]];
    
    AVAssetWriterInput *audioInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:self.audioCompressSetting];

    if ([assetWriter canAddInput:videoInput]) {
        [assetWriter addInput:videoInput];
    }
    
    if ([assetWriter canAddInput:audioInput]) {
        [assetWriter addInput:audioInput];
    }
    //开始写
    [assetWriter startWriting];
    [assetWriter startSessionAtSourceTime:kCMTimeZero];
    dispatch_group_t group = dispatch_group_create();
//    __block BOOL isVideoComplete = NO;
    dispatch_group_enter(group);
    //要想写数据&#xff0c;就带有数据源&#xff0c;以下是将readerVideoTrackOutput读出来的数据加入到assetVideoWriterInput中再写入本地&#xff0c;音频和视频读取写入方式一样
    [videoInput requestMediaDataWhenReadyOnQueue:video_writer_queue usingBlock:^{
        while (videoInput.isReadyForMoreMediaData) {
            //样本数据
           @autoreleasepool {
                //每次读取一个buffer
                CMSampleBufferRef sampleBuffer = [videoOutput copyNextSampleBuffer];
                if (sampleBuffer) {
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
    return  @{(id)kCVPixelBufferPixelFormatTypeKey     : [NSNumber  numberWithUnsignedInt:kCVPixelFormatType_32BGRA],
                                   (id)kCVPixelBufferIOSurfacePropertiesKey: [NSDictionary dictionary],
                                   };
}

-(NSDictionary *)videoCompressSetting:(CGSize)naturalSize minSize:(CGFloat)minSize{
    //配置写数据&#xff0c;设置比特率&#xff0c;帧率等
    if (minSize==0) {
        minSize=720;
    }
    CGFloat width=0,height=0;
    if (MIN(naturalSize.height, naturalSize.width)<=minSize) {
        width=naturalSize.width;
        height=naturalSize.height;
    }
    else if (naturalSize.width>naturalSize.height) {
        height=minSize;
        width=(height/naturalSize.height)*naturalSize.width;
    }else{
        width=minSize;
        height=(width/naturalSize.width)*naturalSize.height;
    }
    NSDictionary *compressionProperties=@{AVVideoAverageBitRateKey :@(1.8*1024*1024),
                                           AVVideoExpectedSourceFrameRateKey:@(25),
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
