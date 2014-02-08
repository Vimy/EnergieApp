//
//  SettingsViewController.m
//  EnergieApp
//
//  Created by Matthias Vermeulen on 27/01/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property NSArray *intervalArray;
@property NSTimeInterval pickerValue;

@end

@implementation SettingsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	_intervalArray  = @[@"Every 30 min", @"Every hour", @"Every two hours"];
}

- (IBAction)savePrefs:(UIButton *)sender
{

    UILocalNotification *localNotification = [[UILocalNotification alloc]init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:self.pickerValue];
    localNotification.alertBody = @"Hoi";
    localNotification.alertAction = @"Time for your daily input";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber +=1;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    localNotification.repeatInterval = NSHourCalendarUnit;
    
    
    ////////////
    /*
    
    UILocalNotification *notif = [[cls alloc] init];
    notif.fireDate = [datePicker date];
    notif.timeZone = [NSTimeZone defaultTimeZone];
    
    notif.alertBody = @"Did you forget something?";
    notif.alertAction = @"Show me";
    notif.soundName = UILocalNotificationDefaultSoundName;
    notif.applicationIconBadgeNumber = 1;
    
    NSInteger index = [scheduleControl selectedSegmentIndex];
    switch (index) {
        case 1:
            notif.repeatInterval = NSMinuteCalendarUnit;
            break;
        case 2:
            notif.repeatInterval = NSHourCalendarUnit;
            break;
        case 3:
            notif.repeatInterval = NSDayCalendarUnit;
            break;
        case 4:
            notif.repeatInterval = NSWeekCalendarUnit;
            break;
        default:
            notif.repeatInterval = 0;
            break;
    }
    
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:reminderText.text
                                                         forKey:kRemindMeNotificationDataKey];
    notif.userInfo = userDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notif];
    [notif release];
    */
    
    
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
