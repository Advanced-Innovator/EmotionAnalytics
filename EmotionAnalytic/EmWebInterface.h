//
//  EmWebInterface.h
//

#import <Foundation/Foundation.h>

@interface EmWebInterface : NSObject

- (void) analyseWavData:(NSData *)data
         withCompletion: (void (^)(NSObject *, NSError *))completion;

@end
