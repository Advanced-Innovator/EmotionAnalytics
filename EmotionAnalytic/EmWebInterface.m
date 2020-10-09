//
//  EmWebDataInterface.m
//

#import "EmWebInterface.h"

#define BOUNDARY @"---------------------------14737809831466499882746641449"
#define API_URL          @"https://api.webempath.net/v2/analyzeWav"
#define API_KEY          @"B4Nu-U92OVduluw_mNtVBvvxrw-q20jT5th3krqYFLg"

@implementation EmWebInterface

- (void) analyseWavData:(NSData *)data
         withCompletion:(void (^)(NSObject *, NSError *))completion {
    NSString *formFormat = @"multipart/form-data; boundary=%@";
    NSString *contentType = [NSString stringWithFormat:formFormat, BOUNDARY];
    NSData *body = [self obtainPostDataFromFileData:data];
    NSString *contentLength = [NSString stringWithFormat:@"%ld", body.length];
    NSURL *url = [NSURL URLWithString:API_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:body];
    [request setValue:contentLength forHTTPHeaderField:@"Content-Length"];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:
      ^(NSData *data, NSURLResponse *res, NSError *err) {
        int options = NSJSONReadingAllowFragments;
        completion([NSJSONSerialization JSONObjectWithData:data options:options error:&err], err);
    }] resume];
}

- (NSData *) obtainPostDataFromFileData:(NSData *)filedata {
    int encoding = NSUTF8StringEncoding;
    NSString * fileParam = @"Content-Disposition: form-data; name=\"wav\";\r\n";
    NSString *disposition = @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n";
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BOUNDARY] dataUsingEncoding:encoding]];
    [body appendData:[[NSString stringWithFormat:disposition, @"apikey"] dataUsingEncoding:encoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", API_KEY] dataUsingEncoding:encoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BOUNDARY] dataUsingEncoding:encoding]];
    [body appendData:[fileParam dataUsingEncoding:encoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:encoding]];
    [body appendData:filedata];
    [body appendData:[@"\r\n" dataUsingEncoding:encoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BOUNDARY] dataUsingEncoding:encoding]];
    return body;
}

@end
