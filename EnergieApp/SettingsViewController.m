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
	_intervalArray  = @[@"Every hour", @"Every two hours"];
}

- (IBAction)savePrefs:(UIButton *)sender
{
    
 
    

   
        UILocalNotification *localNotification = [[UILocalNotification alloc]init];
        //  localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:self.pickerValue];
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:60*30];
        localNotification.alertBody = @"Energie App";
        localNotification.alertAction = @"How are you feeling now?";
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.applicationIconBadgeNumber +=1;
        localNotification.repeatInterval = NSMinuteCalendarUnit;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:60*30];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    


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
