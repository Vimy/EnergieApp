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



@property (strong, nonatomic) UILabel *energyLabel;
@property (strong, nonatomic) UILabel *motivationLabel;
@property (strong, nonatomic) UILabel *focusLabel;
@property (strong, nonatomic) PNLineChart *lineChart;
@property (strong, nonatomic) PNCircleChart *energyChart;
@property (strong, nonatomic) PNCircleChart *motivationChart;
@property (strong, nonatomic) PNCircleChart *focusChart;
@property (weak, nonatomic) IBOutlet UIView *motivationView;
@property (weak, nonatomic) IBOutlet UIView *focusView;
@property (weak, nonatomic) IBOutlet UIView *energyView;

@property (weak, nonatomic) IBOutlet UIView *motivationColorUitleg;
@property (weak, nonatomic) IBOutlet UIView *focusColorUItleg;
@property (weak, nonatomic) IBOutlet UIView *energyColorUItleg;

@end

@implementation ChartViewController


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = UIColorFromRGB(0xF4EEE4);
    self.energyColorUItleg.backgroundColor = PNGreen;
    self.focusColorUItleg.backgroundColor = PNTwitterColor;
    self.motivationColorUitleg.backgroundColor = PNStarYellow;
    [self setupChart];
    [self setupRondeCharts];
   //[self setupLabels];
}

#pragma mark - Setup

- (void)setupChart {
    
    PNLineChartData *data01;
    PNLineChartData *data02;
    PNLineChartData *data03;
    
    NSArray *data01Array;
    NSArray *data02Array;
    NSArray *data03Array;
    
    _lineChart = [[PNLineChart alloc]initWithFrame:CGRectMake(0, 64, WIDTH(self.view), 200.0)]; //64 = navbar + statusbar hoogte
//    _lineChart.backgroundColor = [UIColor redColor]; //om duidelijk te zien waar de view ligt
    
    // [lineChart setXLabels:@[@"10u",@"11u",@"12u",@"13u",@"14u",@"15u",@"16u",@"17u" ]];
    [_lineChart setXLabels:self.chartHourLabels];
    data01Array = self.chartDataEnergy;
    NSLog(@"Self.ChartData: %@", self.chartDataEnergy);
    //NSArray * data01Array = @[@8, @9, @9, @8, @8, @8, @7,@8];
    data01 = [PNLineChartData new];
    data01.color = PNFreshGreen;
    data01.itemCount = _lineChart.xLabels.count;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [[data01Array objectAtIndex:index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    
    //    NSArray * data02Array = @[@20.1, @180.1, @26.4, @202.2, @126.2, @167.2, @276.2,@20.1, @180.1, @26.4, @202.2, @126.2];
    data02 = [PNLineChartData new];
    data02Array = self.chartDataFocus;
    NSLog(@"Data02Array: %@", data02Array);
    data02.color = PNTwitterColor;
    data02.itemCount = _lineChart.xLabels.count;
    data02.getData = ^(NSUInteger index) {
        CGFloat yValue = [[data02Array objectAtIndex:index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    data03 = [PNLineChartData new];
    data03Array = self.chartDataMotivation;
    NSLog(@"Data03Array: %@", data03Array);
    data03.color = PNStarYellow;
    data03.itemCount = _lineChart.xLabels.count;
    data03.getData = ^(NSUInteger index) {
        CGFloat yValue = [[data03Array objectAtIndex:index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    
    _lineChart.chartData = @[data01, data02, data03];
    // lineChart.chartData = @[data01];
    _lineChart.backgroundColor = UIColorFromHex(0xDCD5CC);
    [_lineChart strokeChart];
    [self.view addSubview:_lineChart];
    
    PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 100.0)];
    [barChart setXLabels:self.chartHourLabels];
    [barChart setYValues:self.chartDataEnergy];
    [barChart strokeChart];
    //[self.view addSubview:barChart];
    
    PNBarChart * barChartPhysical = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 135, SCREEN_WIDTH, 100.0)];
    [barChartPhysical setXLabels:self.chartHourLabels];
    [barChartPhysical setYValues:self.chartDataFocus];
    [barChartPhysical strokeChart];
    // [self.view addSubview:barChartPhysical];
    
      
//    NSNumber *average = [data01Array valueForKeyPath:@"@avg.self"];
//    NSNumber *averageFocus = [data02Array valueForKeyPath:@"@avg.self"];
//    NSLog(@"FOCUS average: %@", averageFocus);
//    
//    CGRect tet = CGRectMake(0, 190, SCREEN_WIDTH, 50.0);
//    CGRect nipple = CGRectMake(0, 190, SCREEN_WIDTH/2, 50.0);
//    
//    
//    [self drawCircleChart:&tet maxValueOfCircle:[NSNumber numberWithInt:10] andCurrentNumberOfCircle:average];
//    [self drawCircleChart:&nipple maxValueOfCircle:[NSNumber numberWithInt:3] andCurrentNumberOfCircle:averageFocus];

}

- (void)setupRondeCharts { //Verzin maar een betere naam
    
    
    self.energyView.backgroundColor = [UIColor clearColor];
    self.motivationView.backgroundColor = [UIColor clearColor];
    self.focusView.backgroundColor = [UIColor clearColor];
    
    //Al die shit moei nie hier berekenen maar in een aparte methode of whatever.
    //Zelfde met al jon arrays in [self setupChart]
    //Backgroundcolors zijn geset omdak dan gemakkelijker kan zien waar da de view staat, da mag weg.
    NSNumber *average = [self.chartDataEnergy valueForKeyPath:@"@avg.self"];
    NSNumber *averageFocus = [self.chartDataFocus valueForKeyPath:@"@avg.self"];
    NSLog(@"FOCUS average: %@", averageFocus);
    
    //    CGRect tet = CGRectMake(0, 190, SCREEN_WIDTH, 50.0);
    //    CGRect nipple = CGRectMake(0, 190, SCREEN_WIDTH/2, 50.0);
    
  _energyChart = [self drawCircleChart:CGRectMake(0,0, 75,75)maxValueOfCircle:[NSNumber numberWithInt:10]andCurrentNumberOfCircle:average];

    [self.energyView addSubview:self.energyChart];
    
    _motivationChart = [self drawCircleChart:CGRectMake(0,0, 75,75)
                                          maxValueOfCircle:[NSNumber numberWithInt:10]
                                  andCurrentNumberOfCircle:average];
    _motivationChart.lineWidth = [NSNumber numberWithInt:5];
   [self.motivationView addSubview:_motivationChart];
    
    
    _focusChart = [self drawCircleChart:CGRectMake(0,0, 75,75)
                                     maxValueOfCircle:[NSNumber numberWithInt:10]
                             andCurrentNumberOfCircle:averageFocus];
   [self.focusView addSubview:_focusChart];

}

- (void)setupLabels {
    
    PNCircleChart *circleTiet = [[PNCircleChart alloc]initWithFrame:CGRectMake(100,130,106.666664,100) andTotal:[NSNumber numberWithInt:10] andCurrent:[NSNumber numberWithInt:7]];
    
    [self.view addSubview:circleTiet];
    _energyLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(_energyChart), BOTTOM(_energyChart) + 10, WIDTH(self.view) / 3, 20)];
    _energyLabel.text = @"Energy";
    _energyLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_energyLabel];
    
    _motivationLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(_motivationChart), BOTTOM(_motivationChart) + 10, WIDTH(self.view) / 3, 20)];
    _motivationLabel.text = @"Motivation";
    _motivationLabel.backgroundColor = [UIColor redColor];
    _motivationLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_motivationLabel];
    
    _focusLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(_focusChart), BOTTOM(_focusChart) + 10, WIDTH(self.view) / 3, 20)];
    _focusLabel.text = @"Focus";
    _focusLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_focusLabel];
}

- (PNCircleChart *)drawCircleChart:(CGRect)circleFrame maxValueOfCircle:(NSNumber *)maxNumber andCurrentNumberOfCircle:(NSNumber *)currentNumber
{
    PNCircleChart *circleChart = [[PNCircleChart alloc]initWithFrame:circleFrame
                                                             andTotal:maxNumber
                                                           andCurrent:currentNumber];
    
    NSLog(@"Method drawCicrcleChart called");
    
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
   //[self.view addSubview:circleChart];
    
    return circleChart;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
