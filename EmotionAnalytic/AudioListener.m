//
//  AudioListener.m
//

#import "AudioListener.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#define AV_NO_OF_CHANNEL @1
#define AV_SAMPLE_RATE @11025.0f
#define AUDIO_FILE @"recording.wav"

@interface AudioListener () <AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation AudioListener


- (instancetype) initListener {
    self = [super init];
    if (self) {
        NSError *error=nil;
        NSURL *audioURL = [self _audioRecordingPath:AUDIO_FILE];
        NSDictionary *settings = @{AVEncoderAudioQualityKey:@(AVAudioQualityMin),
                                   AVEncoderBitRateKey:@16,
                                   AVSampleRateKey:AV_SAMPLE_RATE,
                                   AVNumberOfChannelsKey:AV_NO_OF_CHANNEL,
                                   AVLinearPCMBitDepthKey:@8};
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:audioURL
                                                     settings:settings
                                                        error:&error];
    }
    return self;
}

- (void) startRecordingAudio {
    if (_audioRecorder != nil) {
        _audioRecorder.delegate = self;
        bool success = [_audioRecorder prepareToRecord] && [_audioRecorder record];
        if (!success) {
            _audioRecorder = nil;
        }
    }
    else
        NSLog(@"Failed to create an instance of the audio recorder.");
}

- (void) stopRecordingAudio {
    [_audioRecorder stop];
}

- (NSData *) recordedData {
    NSURL *url = [self _audioRecordingPath:AUDIO_FILE];
    return[NSData dataWithContentsOfURL:url options:NSDataReadingMapped error:nil];
}

- (NSURL *) _audioRecordingPath:(NSString *)audioFile {
    NSFileManager *fileMgr = [[NSFileManager alloc] init];
    NSURL *docFolderUrl = [fileMgr URLForDirectory:NSDocumentDirectory
                                          inDomain:NSUserDomainMask
                                 appropriateForURL:nil create:NO error:nil];
    return [docFolderUrl URLByAppendingPathComponent:audioFile];
}

@end
