//
//  EnergyStatsViewController.m
//  EnergieApp
//
//  Created by Matthias Vermeulen on 31/01/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import "EnergyStatsViewController.h"
#import "Energie.h"
#import "DataAccessLayer.h"
#import "ChartViewController.h"
#import "PNChart.h"

@interface EnergyStatsViewController ()
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSArray *energyHistory;
@property (nonatomic, strong) NSMutableDictionary *energyHistoryDict;
@property (nonatomic, strong) NSMutableArray *energyWeekDayUnsorted;
@property (nonatomic, strong) NSMutableArray *energyCollection;
@property (nonatomic, strong) NSMutableArray *energyPhysicalEnergy;
@property (nonatomic, strong) NSArray *energyWeekDaySorted;
@property (nonatomic, strong) NSDateFormatter *fmt;
@property (nonatomic, strong) NSDateFormatter *weekDayStringFormatter;
@end

@implementation EnergyStatsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    DataAccessLayer *accesLayer = [[DataAccessLayer alloc]init];
    self.managedObjectContext = [accesLayer managedObjectContext];
    self.fmt = [[NSDateFormatter alloc] init];
    [self.fmt setDateFormat:@"dd-MM-yyyy"]; //aanpassen voor lokaal gebruik
    
    self.weekDayStringFormatter = [[NSDateFormatter alloc]init];
    [self.weekDayStringFormatter setDateFormat:@"eeee"];
    
    [self fetchData];
    [self.tableView reloadData];
    [self sortDataByDay];
}



- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [self fetchData];
    [self sortDataByDay];
}

- (void)fetchData
{
  
    self.energyWeekDayUnsorted = [[NSMutableArray alloc]init];
    self.energyPhysicalEnergy = [[NSMutableArray alloc]init];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Energie" inManagedObjectContext:self.managedObjectContext];
    NSError *error;
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    self.energyHistory = fetchedObjects;

    for (Energie *energie in fetchedObjects)
    {
        NSLog(@"EnergieTime: %@", energie.timeOfEntry);
        
    }
    
    
}

- (void)sortDataByDay
{
    self.energyHistoryDict = [[NSMutableDictionary alloc]init];
    for (Energie *energie in self.energyHistory)
    {
        NSLog(@"TijdCheck: %@", energie.timeOfEntry);
        
        NSDate *dateRepresentingThisDay = [self dateAtBegiggingOfDayForDate:energie.timeOfEntry];
        NSMutableArray *energyValuesOnThisDay = [self.energyHistoryDict objectForKey:dateRepresentingThisDay];
        if (energyValuesOnThisDay == nil)
        {
            energyValuesOnThisDay = [NSMutableArray array];
            [self.energyHistoryDict setObject:energyValuesOnThisDay forKey:dateRepresentingThisDay];
            
        }
        [energyValuesOnThisDay addObject:energie];
    }
    
    NSArray *energyWeekDaysUnsorted = [self.energyHistoryDict allKeys];
    NSLog(@"Unsorted: %@", energyWeekDaysUnsorted);
    
    self.energyWeekDaySorted = [energyWeekDaysUnsorted sortedArrayUsingSelector:@selector(compare:)];
    NSLog(@"Sorted:%@", self.energyWeekDaySorted);
    
    
    
}

- (NSDate *)dateAtBegiggingOfDayForDate:(NSDate *)inputDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit  fromDate:inputDate];
    
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
        NSLog(@"Rows: %lu", (unsigned long)[[self.energyHistoryDict allKeys] count]);
    return [[self.energyHistoryDict allKeys] count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EnergyHistoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
   
  
    
    

    NSDate *weekDate = [self.energyWeekDaySorted objectAtIndex:indexPath.row];
  
    NSString *dateString = [self.fmt stringFromDate:weekDate];

    //NSArray *daysOfWeek = @[@"",@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday"];
    NSInteger weekdayNumber = (NSInteger)[[self.fmt stringFromDate:weekDate] integerValue];
    NSLog(@"WeekdayNumber: %i", weekdayNumber);

    UILabel *weekDayLabel = (UILabel *)[cell viewWithTag:103];
    weekDayLabel.text = [self.weekDayStringFormatter stringFromDate:weekDate];
    
    UILabel *datumLabel = (UILabel *) [cell viewWithTag:110];
    datumLabel.text = dateString;
    
    UIImageView *graphSegueIcon = (UIImageView *) [cell viewWithTag:104];
    graphSegueIcon.image = [UIImage imageNamed:@"Chart_Up@2x.png"];
    
   // UIImageView *circleIcon = (UIImageView *) [cell viewWithTag:105];
    //circleIcon.image = [UIImage imageNamed:@"cirkel.png"];
    
    
    
    
    CGRect frameCircleSubView = CGRectMake(0, 0, 36, 44);
    UIView *circleSubView = [[UIView alloc]initWithFrame:frameCircleSubView];
    //circleSubView.backgroundColor = [UIColor redColor];
     NSMutableArray *data = [[NSMutableArray alloc]init];
    NSDate *date = [self.energyWeekDaySorted objectAtIndex:indexPath.row];
    NSArray *test = [self.energyHistoryDict objectForKey:date];
    NSLog(@"Test array is: %@", test);
    for (Energie *energie in test)
    {
        [data addObject:energie.mentalEnergy];
    }
    
    NSNumber *average = [data valueForKeyPath:@"@avg.self"];

    
    PNCircleChart * circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(5, 2, 36, 36) andTotal:[NSNumber numberWithInt:10] andCurrent:average];
    circleChart.backgroundColor = [UIColor clearColor];
    [circleChart setLineWidth:[NSNumber numberWithInt:4]];
    [circleChart setStrokeColor:PNGreen];
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
    [circleSubView addSubview:circleChart];
    
    
     [cell addSubview:circleSubView];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
- (void)prepareChartViewController:(ChartViewController *)cvc toDisplayMentalChart:(NSArray *)chartDataMentalEnergy andFysicalChart:(NSArray *)chartDataFysicalEnergy withHourLabels:(NSArray *)labelData andTitle:(NSString *)title
{
    cvc.chartDataMentalEnergy = chartDataMentalEnergy;
    cvc.chartDataFysicalEnergy = chartDataFysicalEnergy;
    cvc.chartHourLabels = labelData;
    cvc.title = title;
    
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 if([sender isKindOfClass:[UITableViewCell class]])
 {
     NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
     if (indexPath)
     {
         if ([segue.identifier isEqualToString:@"Energy in detail"])
         {
             if ([segue.destinationViewController isKindOfClass:[ChartViewController class]])
             {
                 NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                 [formatter setDateFormat:@"HH"];
                 
                 NSMutableArray *data = [[NSMutableArray alloc]init];
                 NSMutableArray *dataPhysical = [[NSMutableArray alloc]init];

                 NSMutableArray *labelData = [[NSMutableArray alloc]init];
                 NSDate *date = [self.energyWeekDaySorted objectAtIndex:indexPath.row];
                 NSArray *test = [self.energyHistoryDict objectForKey:date];
                 NSLog(@"Test array is: %@", test);
                for (Energie *energie in test)
                {
                    [data addObject:energie.mentalEnergy];
                    [dataPhysical addObject:energie.focusLevel];
                    //[dataPhysical addObject:energie.physicalEnergy];
                    [labelData addObject:[formatter stringFromDate:energie.timeOfEntry]];    
                }
                 NSDate *weekDate = [self.energyWeekDaySorted objectAtIndex:indexPath.row];
                 
                 
                 NSInteger weekdayNumber = (NSInteger)[[self.fmt stringFromDate:weekDate] integerValue];
                 NSLog(@"WeekdayNumber: %i", weekdayNumber);
                 
                 NSString *title = [self.weekDayStringFormatter stringFromDate:weekDate];
                 [self prepareChartViewController:segue.destinationViewController toDisplayMentalChart:data andFysicalChart:dataPhysical withHourLabels:labelData andTitle:title];
                 
            
                
          //       [self prepareChartViewController:segue.destinationViewController toDisplayChart:
             }
             
         }
         
         
         
     }
     
 }

}



@end
