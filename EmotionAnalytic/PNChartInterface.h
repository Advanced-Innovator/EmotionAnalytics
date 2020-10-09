//
//  PNChartInterface.h
//

#import <Foundation/Foundation.h>
#import "PNChart.h"

@interface PNChartInterface : NSObject

- (instancetype) initInterface;
- (PNBarChart *) barChart;
- (void) hideChart;
- (void) showBarChartWithColors:(NSArray *)colors
                         labels:(NSArray *)labels
                      andValues:(NSArray *)values;

@end
