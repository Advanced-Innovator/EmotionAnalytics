//
//  EMPathViewController.m
//

#import "EMPathViewController.h"
#import "EmWebInterface.h"
#import "AudioListener.h"
#import "PNChartInterface.h"

#define RECORD_DURATION 4

@interface EMPathViewController ()

@property (nonatomic, strong) PNChartInterface *chartInterface;
@property (nonatomic, strong) AudioListener *audioListener;
@property (nonatomic, strong) EmWebInterface *emWebInterface;
@property (weak, nonatomic) IBOutlet UILabel *actionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *recordButton;

@end

@implementation EMPathViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    _emWebInterface = [[EmWebInterface alloc] init];
    _audioListener = [[AudioListener alloc] initListener];
    _chartInterface = [[PNChartInterface alloc] initInterface];
    [self.view addSubview:_chartInterface.barChart];
}

- (IBAction) recordButtonPressed:(id)sender {
    [_recordButton setEnabled:NO];
    [_chartInterface hideChart];
    [_audioListener startRecordingAudio];
    _actionLabel.text = @"Start Talking ...";
    _imageView.image = [UIImage imageNamed:@"icon_voice"];
    [self performSelector:@selector(analyseData)
               withObject:nil afterDelay:RECORD_DURATION];
}

- (void) analyseData {
    _actionLabel.text = @"Analysing Voice...";
    [_audioListener stopRecordingAudio];
    NSData *data = [_audioListener recordedData];
    [_emWebInterface analyseWavData:data
                     withCompletion:^(NSObject *obj, NSError *err) {
         dispatch_async(dispatch_get_main_queue(), ^{
             [self.recordButton setEnabled:YES];
             NSDictionary *dict = (NSDictionary *)obj;
             if (dict[@"error"] && ((NSNumber *)dict[@"error"]).intValue == 0) {
                 [self _displayResult:dict];
             } else {
                 self.actionLabel.text = @"Unable to analyse data.";
             }
         });
     }];
}

- (void) _displayResult:(NSDictionary *) result {
    NSArray *colors = @[PNYellow, PNGreen, PNMauve, PNRed, PNLightBlue];
    NSArray *labels = @[@"Energy", @"Joy", @"Sorrow", @"Anger", @"Calm"];
    NSArray *values = @[result[@"energy"],
                        result[@"joy"],
                        result[@"sorrow"],
                        result[@"anger"],
                        result[@"calm"]];
    id maxValue = [values valueForKeyPath:@"@max.intValue"];
    NSString *mood = labels[[values indexOfObject:maxValue]];
    self.actionLabel.text = [NSString stringWithFormat:@"You are %@", mood];
    [self.chartInterface showBarChartWithColors:colors
                                         labels:labels
                                      andValues:values];
}

@end
