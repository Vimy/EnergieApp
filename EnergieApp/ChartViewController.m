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
@property (weak, nonatomic) IBOutlet UILabel *Energy;
@property (weak, nonatomic) IBOutlet UILabel *Motivation;
@property (weak, nonatomic) IBOutlet UILabel *Focus;

@end

@implementation ChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
 
    
    PNLineChart *lineChart = [[PNLineChart alloc]initWithFrame:CGRectMake(0, 100.0, SCREEN_WIDTH, 200.0)];
   // [lineChart setXLabels:@[@"10u",@"11u",@"12u",@"13u",@"14u",@"15u",@"16u",@"17u" ]];
    [lineChart setXLabels:self.chartHourLabels];
    NSArray *data01Array = self.chartDataMentalEnergy;
    NSLog(@"Self.ChartData: %@", self.chartDataMentalEnergy);
   //NSArray * data01Array = @[@8, @9, @9, @8, @8, @8, @7,@8];
    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = PNFreshGreen;
    data01.itemCount = lineChart.xLabels.count;
    data01.getData = ^(NSUInteger index) {
            CGFloat yValue = [[data01Array objectAtIndex:index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
            };


//    NSArray * data02Array = @[@20.1, @180.1, @26.4, @202.2, @126.2, @167.2, @276.2,@20.1, @180.1, @26.4, @202.2, @126.2];
    PNLineChartData *data02 = [PNLineChartData new];
    NSArray *data02Array = self.chartDataPhyysicalEnergy;
    NSLog(@"Data02Array: %@", data02Array);
    data02.color = PNTwitterColor;
    data02.itemCount = lineChart.xLabels.count;
    data02.getData = ^(NSUInteger index) {
        CGFloat yValue = [[data02Array objectAtIndex:index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
   
    lineChart.chartData = @[data01, data02];
   // lineChart.chartData = @[data01];
    [lineChart strokeChart];
   [self.view addSubview:lineChart];
    
    
    PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 100.0)];
    [barChart setXLabels:self.chartHourLabels];
    [barChart setYValues:self.chartDataMentalEnergy];
    [barChart strokeChart];
    //[self.view addSubview:barChart];
    
    
    PNBarChart * barChartPhysical = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 135, SCREEN_WIDTH, 100.0)];
    [barChartPhysical setXLabels:self.chartHourLabels];
    [barChartPhysical setYValues:self.chartDataPhyysicalEnergy];
    [barChartPhysical strokeChart];
   // [self.view addSubview:barChartPhysical];
    
    
    NSNumber *average = [data01Array valueForKeyPath:@"@avg.self"];
    NSNumber *averageFocus = [data02Array valueForKeyPath:@"@avg.self"];
    NSLog(@"FOCUS average: %@", averageFocus);
    
    CGRect tet = CGRectMake(0, 190, SCREEN_WIDTH, 50.0);
    CGRect nipple = CGRectMake(0, 190, SCREEN_WIDTH/2, 50.0);

    
    [self drawCircleChart:&tet maxValueOfCircle:[NSNumber numberWithInt:10] andCurrentNumberOfCircle:average];
    [self drawCircleChart:&nipple maxValueOfCircle:[NSNumber numberWithInt:3] andCurrentNumberOfCircle:averageFocus];

}


- (void)drawCircleChart:(CGRect *)circleFrame maxValueOfCircle:(NSNumber *)maxNumber andCurrentNumberOfCircle:(NSNumber *)currentNumber
{
    PNCircleChart * circleChart = [[PNCircleChart alloc] initWithFrame:*circleFrame andTotal:maxNumber andCurrent:currentNumber];
    circleChart.backgroundColor = [UIColor clearColor];
    if ([currentNumber intValue] >= 5 )
    {
        [circleChart setStrokeColor:PNGreen];
        
    }
    else if ([currentNumber intValue] >= 4 )
    {
        [circleChart setStrokeColor:PNYellow];
    }
    else if ([currentNumber intValue] >= 1 )
    {
        [circleChart setStrokeColor:PNRed];
    }
    
    [circleChart strokeChart];
    [self.view addSubview:circleChart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
