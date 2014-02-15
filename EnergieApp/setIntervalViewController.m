//
//  SettingsViewController.m
//  EnergieApp
//
//  Created by Matthias Vermeulen on 27/01/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import "setIntervalViewController.H"

@interface setIntervalViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property NSArray *intervalArray;
@property NSTimeInterval pickerValue;
@property NSTimer *userOptionInteractionTimer;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UIDatePicker *myDatePicker;
@property (nonatomic, strong) UIBarButtonItem *doneButton;

@property (nonatomic, strong) NSDateFormatter *dateFormatter1;
@property (nonatomic, strong) NSDateFormatter *dateFormatter2;
@property (nonatomic, strong) NSDateFormatter *dateFormatter3;




#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



@property (nonatomic, strong) UITableView *chooseSleepHoursTableView;

@end

@implementation setIntervalViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	_intervalArray  = @[@"Every hour", @"Every two hours"];
    self.dataArray = [NSArray arrayWithObjects:
                      @"Selected Date",
                      @"Start notifying me from",
                      @"Stop notifying me",
                      nil];
    
    self.view.backgroundColor = UIColorFromRGB(0xF4EEE4);
  
    
    //find the available space on the screen
    CGRect tableViewFrame = self.view.bounds;
    
    //set the background color and create the table view
    self.chooseSleepHoursTableView = [[UITableView alloc] initWithFrame:tableViewFrame
                                                    style:UITableViewStyleGrouped];
    
    //set the delegate for the table view to self
    self.chooseSleepHoursTableView.delegate = self;
    
    //set the data source for the table view to self
    self.chooseSleepHoursTableView.dataSource = self;
    
    self.chooseSleepHoursTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.chooseSleepHoursTableView.backgroundColor = [UIColor redColor];
    
    //add the table view to the current view
    [self.view addSubview:self.chooseSleepHoursTableView];
    
    NSLog(@"View geladen");
    
    
    
    
    
    
}

- (void)startUserOptionInteractionTimer
{
    // Remove any existing timer
    [self.userOptionInteractionTimer invalidate];
    self.userOptionInteractionTimer = [NSTimer scheduledTimerWithTimeInterval:4.f
                                                                       target:self
                                                                     selector:@selector(setupNotifications)
                                                                     userInfo:nil
                                                                      repeats:NO];
}


- (void)applicationWillResignActive
{
    // If the timer is still waiting, fire it so the notifications are setup correctly before the app enters the background.
    if (self.userOptionInteractionTimer.isValid)
        [self.userOptionInteractionTimer fire];
    /*
    // Store the user's selections in NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:self.notificationIgnoreStartTime.date forKey:@"SleepStartDate"];
    [[NSUserDefaults standardUserDefaults] setObject:self.notificationIgnoreEndTime.date forKey:@"SleepEndDate"];
    [[NSUserDefaults standardUserDefaults] setBool:self.sleepToggleSwitch.on forKey:@"SleepEnabled"];
     */
    
}

- (void)setupNotifications
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

    
     NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSString *dateString = @"22:OO";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh-mm";
    NSDate *sleepStartdate = [dateFormatter dateFromString:dateString];

    [comps setDay:14];
    [comps setMonth:2];
    [comps setYear:2014];
    [comps setHour:15];
    [comps setMinute:0];
    [comps setSecond:0];
    NSDate *notificationDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    
    
    dateString = @"08:00";
    NSDate *sleepStopDate = [dateFormatter dateFromString:dateString];
   
    
    [comps setDay:14];
    [comps setMonth:2];
    [comps setYear:2014];
    [comps setHour:22];
    [comps setMinute:0];
    [comps setSecond:0];
    sleepStartdate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    do {
        UILocalNotification *localNotification = [[UILocalNotification alloc]init];
        //  localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:self.pickerValue];
        localNotification.fireDate = notificationDate;
        localNotification.alertBody = @"hoi";
        localNotification.alertAction = @"hoikes! zet u! nootjes? koffie?";
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.applicationIconBadgeNumber +=1;
        localNotification.repeatInterval = NSHourCalendarUnit;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        notificationDate = [notificationDate dateByAddingTimeInterval:3600];
        NSLog(@"NotificationDate: %@", notificationDate);
        NSLog(@"sleepStartDate: %@", sleepStartdate);
        
    } while ([notificationDate compare: sleepStartdate] == NSOrderedAscending);
    
    
}

- (void)scheduleLocalNotificationwithFiredate:(NSDate *)fireDate alertBody:(NSString *)bodyString andAlertAction:(NSString *)actionString
{
    UILocalNotification *localNotification = [[UILocalNotification alloc]init];
    //  localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:self.pickerValue];
    localNotification.fireDate = fireDate;
    localNotification.alertBody = bodyString;
    localNotification.alertAction = actionString;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber +=1;
    localNotification.repeatInterval = NSHourCalendarUnit;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    
}

- (IBAction)segmentedControlIndexChanged
{
   /* switch (self.segmentendControl.selectedSegmentIndex)
    {
        case 0:
         
            
            
        break;
        case 1:
         
            

      
            
        break;
        default:
            break; 
    }
    */
}

#pragma mark TableView


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger result = 0;
    result = [self.dataArray count];
    return result;
}


//this to initialize the table view cell with data from the array
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    
    //check if this our table view
    if ([tableView isEqual:self.chooseSleepHoursTableView]){
        
        static NSString *TableViewCellIdentifier = @"MyCells";
        cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
        if (cell == nil){
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TableViewCellIdentifier];
        }
        
        //set the text for the cell with the data from the array
        cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
        
        //depending on the row set the date to current date with the proper format
        switch (indexPath.row) {
            case 0:
                cell.detailTextLabel.text = [self.dateFormatter1 stringFromDate:[NSDate date]];
                break;
            case 1:
                cell.detailTextLabel.text = [self.dateFormatter2 stringFromDate:[NSDate date]];
                break;
            case 2:
                cell.detailTextLabel.text = [self.dateFormatter2 stringFromDate:[NSDate date]];
                break;
            default:
                break;
        }
    }
    
    return cell;
    
}

//listen to changes in the date picker and just log them
- (void) datePickerDateChanged:(UIDatePicker *)paramDatePicker{
    if ([paramDatePicker isEqual:self.myDatePicker]){
        NSLog(@"Selected date = %@", paramDatePicker.date);
    }
}

//when the cell is selected in the table view we need to display the picker
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //which section and row  was clicked on
    NSLog(@"Clicked on Section %d and Row %d", indexPath.section, indexPath.row);
    
    //get reference to the cell based on the index
    UITableViewCell *targetCell = [tableView cellForRowAtIndexPath:indexPath];
    
    //if date picker doesn't exists then create it
    if(self.myDatePicker == nil){
        self.myDatePicker = [[UIDatePicker alloc] init];
        
        //set the action method that will listen for changes to picker value
        [self.myDatePicker addTarget:self
                              action:@selector(datePickerDateChanged:)
                    forControlEvents:UIControlEventValueChanged];
    }
    
    
    //set the value of the picker based on the cell value and also set the proper picker mode
    switch (indexPath.row) {
        case 0:
            self.myDatePicker.date = [self.dateFormatter1 dateFromString:targetCell.detailTextLabel.text];
            self.myDatePicker.datePickerMode = UIDatePickerModeDate;
            break;
        case 1:
            self.myDatePicker.date = [self.dateFormatter2 dateFromString:targetCell.detailTextLabel.text];
            self.myDatePicker.datePickerMode = UIDatePickerModeTime;
            break;
        case 2:
            self.myDatePicker.date = [self.dateFormatter3 dateFromString:targetCell.detailTextLabel.text];
            self.myDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
            break;
        default:
            break;
    }
    
    //find the current table view size
    CGRect screenRect = [self.view frame];
    NSLog(@"Screen frame %f %f", screenRect.origin.y, screenRect.size.height);
    
    //find the date picker size
    CGSize pickerSize = [self.myDatePicker sizeThatFits:CGSizeZero];
    
    //set the picker frame
    CGRect pickerRect = CGRectMake(0.0,
                                   screenRect.origin.y + screenRect.size.height - pickerSize.height,
                                   pickerSize.width,
                                   pickerSize.height);
    self.myDatePicker.frame = pickerRect;
    
    //add the picker to the view
    [self.view addSubview:self.myDatePicker];
    
    //create the navigation button if it doesn't exists
    if(self.doneButton == nil){
        self.doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(dateSelected:)];
    }
    //add the "Done" button to the right side of the navigation bar
    self.navigationItem.rightBarButtonItem = self.doneButton;
    
    
}

//method to call when the "Done" button is clicked
- (void) dateSelected:(id)sender {
    
    //remove the "Done" button in the navigation bar
    self.navigationItem.rightBarButtonItem = nil;
    
    //find the current selected cell row in the table view
    NSIndexPath *indexPath = [self.chooseSleepHoursTableView indexPathForSelectedRow];
    UITableViewCell *cell = [self.chooseSleepHoursTableView cellForRowAtIndexPath:indexPath];
    NSLog(@"Selected Section %d and Row %d", indexPath.section, indexPath.row);
    
    //set the cell value from the date picker value and format it properly
    switch (indexPath.row) {
        case 0:
            cell.detailTextLabel.text = [self.dateFormatter1 stringFromDate:self.myDatePicker.date];
            break;
        case 1:
            cell.detailTextLabel.text = [self.dateFormatter2 stringFromDate:self.myDatePicker.date];
            break;
        case 2:
            cell.detailTextLabel.text = [self.dateFormatter3 stringFromDate:self.myDatePicker.date];
            break;
        default:
            break;
    }
    
    //remove the date picker view form the super view
    [self.myDatePicker removeFromSuperview];
    
    //deselect the current table row
    [self.chooseSleepHoursTableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return self.intervalArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return self.intervalArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch(row) {
        case 0:
            self.pickerValue = 30;
            NSLog(@"Tijd gekozen: 30 min");
            break;
        case 1:
           self.pickerValue = 3600;
            NSLog(@"Tijd gekozen: 60 min");
            break;
        case 2:
            self.pickerValue = 7200;
            NSLog(@"Tijd gekozen: 120 min");
            break;
    }
}
@end
