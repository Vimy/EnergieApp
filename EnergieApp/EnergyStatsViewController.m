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


@interface EnergyStatsViewController ()
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSArray *energyHistory;
@property (nonatomic, strong) NSMutableDictionary *energyHistoryDict;
@property (nonatomic, strong) NSMutableArray *energyWeekDayUnsorted;
@property (nonatomic, strong) NSMutableArray *energyCollection;
@property (nonatomic, strong) NSMutableArray *energyPhysicalEnergy;
@property (nonatomic, strong) NSArray *energyWeekDaySorted;

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
  
  
    
    UILabel *weekDayLabel = (UILabel *)[cell viewWithTag:103];
    weekDayLabel.text = [NSString stringWithFormat:@"%@ ",[self.energyWeekDaySorted objectAtIndex:indexPath.row]];
    
    UIImageView *graphSegueIcon = (UIImageView *) [cell viewWithTag:104];
    graphSegueIcon.image = [UIImage imageNamed:@"Chart_Up@2x.png"];
    
    UIImageView *circleIcon = (UIImageView *) [cell viewWithTag:105];
    circleIcon.image = [UIImage imageNamed:@"cirkel.png"];
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
