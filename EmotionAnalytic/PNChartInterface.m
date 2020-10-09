//
//  PNChartInterface.m
//

#import "PNChartInterface.h"
#import "PNChartDelegate.h"
#import "PNChart.h"

@interface PNChartInterface () <PNChartDelegate>

@property (nonatomic, strong) PNBarChart *barChart;
@property (nonatomic, strong) NSNumberFormatter *barChartFormatter;

@end

@implementation PNChartInterface

- (instancetype) initInterface {
    self = [super init];
    CGFloat dh = [[UIScreen mainScreen] bounds].size.height;
    CGRect frame = CGRectMake(0, 2*dh/4, SCREEN_WIDTH, dh/3);
    _barChart = [self _createBarCharWithFrame:frame];
    _barChart.hidden = YES;
    _barChartFormatter = [[NSNumberFormatter alloc] init];
    _barChartFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    _barChartFormatter.allowsFloats = NO;
    _barChartFormatter.maximumFractionDigits = 0;
    return self;
}

- (PNBarChart *) barChart {
    return _barChart;
}

- (void) hideChart {
    [_barChart setHidden:YES];
}

- (void) showBarChartWithColors:(NSArray *)colors
                         labels:(NSArray *)labels
                      andValues:(NSArray *)values {
    [_barChart setStrokeColors:colors];
    [_barChart setXLabels:labels];
    [_barChart setYValues:values];
    [_barChart strokeChart];
    [_barChart setHidden:NO];
}

- (PNBarChart *) _createBarCharWithFrame:(CGRect)frame {
    PNBarChart *barChart = [[PNBarChart alloc] initWithFrame:frame];
    barChart.backgroundColor = [UIColor clearColor];
    barChart.yLabelFormatter = ^(CGFloat yValue) {
        NSNumber *num = [NSNumber numberWithFloat:yValue];
        return [self.barChartFormatter stringFromNumber:num];
    };
    barChart.yChartLabelWidth = 20.0;
    barChart.chartMarginLeft = 30.0;
    barChart.chartMarginRight = 10.0;
    barChart.chartMarginTop = 5.0;
    barChart.chartMarginBottom = 10.0;
    barChart.labelMarginTop = 5.0;
    barChart.showChartBorder = YES;
    barChart.isGradientShow = NO;
    barChart.isShowNumbers = NO;
    barChart.displayAnimated = NO;
    barChart.delegate = self;
    return barChart;
}

@end
