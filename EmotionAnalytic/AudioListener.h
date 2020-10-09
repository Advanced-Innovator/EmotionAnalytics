//
//  AudioListener.h
//

#import <Foundation/Foundation.h>

@interface AudioListener : NSObject

- (instancetype) initListener;
- (void) startRecordingAudio;
- (void) stopRecordingAudio;
- (NSData *) recordedData;

@end
