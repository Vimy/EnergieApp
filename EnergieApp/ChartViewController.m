//
//  ViewController.m
//  ChartTest
//
//  Created by Matthias Vermeulen on 2/02/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import "ChartViewController.h"
#import "PNChart.h"
@interface ChartViewController ()

@end

@implementation ChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
 
    
    PNLineChart *lineChart = [[PNLineChart alloc]initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
   // [lineChart setXLabels:@[@"10u",@"11u",@"12u",@"13u",@"14u",@"15u",@"16u",@"17u" ]];
    [lineChart setXLabels:self.chartHourLabels];
    NSArray *data01Array = self.chartData;
    NSLog(@"Self.ChartData: %@", self.chartData);
   //NSArray * data01Array = @[@8, @9, @9, @8, @8, @8, @7,@8];
    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = PNFreshGreen;
    data01.itemCount = lineChart.xLabels.count;
    data01.getData = ^(NSUInteger index) {
            CGFloat yValue = [[data01Array objectAtIndex:index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
            };

    /*
    // Line Chart No.2
    NSArray * data02Array = @[@20.1, @180.1, @26.4, @202.2, @126.2, @167.2, @276.2,@20.1, @180.1, @26.4, @202.2, @126.2];
    PNLineChartData *data02 = [PNLineChartData new];
    data02.color = PNTwitterColor;
    data02.itemCount = lineChart.xLabels.count;
    data02.getData = ^(NSUInteger index) {
        CGFloat yValue = [[data02Array objectAtIndex:index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    */
    
   // lineChart.chartData = @[data01, data02];
    lineChart.chartData = @[data01];
    [lineChart strokeChart];
    [self.view addSubview:lineChart];
    
    
    PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 135, SCREEN_WIDTH, 100.0)];
    [barChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];
    [barChart setYValues:@[@1,  @10, @2, @6, @3]];
    [barChart strokeChart];
   // [self.view addSubview:barChart];
    
    NSNumber *average = [data01Array valueForKeyPath:@"@avg.self"];
    
    
    PNCircleChart * circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 190, SCREEN_WIDTH, 50.0) andTotal:[NSNumber numberWithInt:10] andCurrent:average];
    circleChart.backgroundColor = [UIColor clearColor];
    if ([average intValue] >= 5 )
    {
        [circleChart setStrokeColor:PNGreen];
        
    }
    else if ([average intValue] >= 4 )
    {
        [circleChart setStrokeColor:PNYellow];
    }
    else if ([average intValue] >= 1 )
    {
        [circleChart setStrokeColor:PNRed];
    }
    
    [circleChart strokeChart];
    [self.view addSubview:circleChart];
    
    
    NSLog(@"Chart getekend");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
