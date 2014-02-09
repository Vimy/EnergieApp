//
//  DataInputViewController.m
//  EnergieApp
//
//  Created by Matthias Vermeulen on 24/01/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import "DataInputViewController.h"
#import "Energie.h"
#import "AppDelegate.h"
#import "DataAccessLayer.h"


@interface DataInputViewController ()
@property (weak, nonatomic) IBOutlet UIButton *dataSubmitButton;
@property (weak, nonatomic) IBOutlet UILabel *physicalEnergyValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *energyLevelSlider;
@property (weak, nonatomic) IBOutlet UISlider *mentalEnergyLevelSlider;
@property (weak, nonatomic) IBOutlet UILabel *mentalEnergyValueLabel;

@property (strong, nonatomic) NSDate *timeOfEntry;
@property (strong, nonatomic) NSDate *dayOfEntry;
@property (strong, nonatomic) NSDate *hourOfEntry;
@property (strong, nonatomic) NSMutableArray *energieData;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@end

@implementation DataInputViewController

- (void)viewDidLoad
{
    
    DataAccessLayer *accesLayer = [[DataAccessLayer alloc]init];
    self.managedObjectContext = [accesLayer managedObjectContext];
  //  self.view.backgroundColor = UIColorFromRGB(0xC0272A);
    //  self.managedObjectContext = [appDelegate managedObjectContext];
    self.energyLevelSlider.value = 6;
    self.mentalEnergyLevelSlider.value = 6;
    self.physicalEnergyValueLabel.text = @"Redelijk";
    self.mentalEnergyValueLabel.text = @"Redelijk";
}


- (NSMutableArray*)energieData
{
    if(!_energieData)
    {
        _energieData = [[NSMutableArray alloc]init];
        
        
    }
    return _energieData;
}

- (IBAction)energyLevelSlider:(UISlider *)sender
{
    int value = sender.value;
   // physicalEnergyValueLabel.text
    
    switch (value)
    {
        case 0:
            self.physicalEnergyValueLabel.text = @"Vreselijk";
            break;
        case 2:
            self.physicalEnergyValueLabel.text = @"Slecht";
            break;
        case 4:
            self.physicalEnergyValueLabel.text = @"Minder";
            break;
        case 6:
            self.physicalEnergyValueLabel.text = @"Redelijk";
            break;
        case 8:
            self.physicalEnergyValueLabel.text = @"Goed";
            break;
        case 10:
            self.physicalEnergyValueLabel.text = @"Super";
            break;
    }
}


- (IBAction)mentalEnergyLevelSlider:(UISlider *)sender
{
    int value = sender.value;
    // physicalEnergyValueLabel.text
    
    switch (value)
    {
        case 0:
            self.mentalEnergyValueLabel.text = @"Vreselijk";
            break;
        case 2:
            self.mentalEnergyValueLabel.text = @"Slecht";
            break;
        case 4:
            self.mentalEnergyValueLabel.text = @"Minder";
            break;
        case 6:
            self.mentalEnergyValueLabel.text = @"Redelijk";
            break;
        case 8:
            self.mentalEnergyValueLabel.text = @"Goed";
            break;
        case 10:
            self.mentalEnergyValueLabel.text = @"Super";
            break;
    }

    
}

- (IBAction)submitData:(UIButton *)sender
{

    // Get the Gregorian calendar
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate* now = [NSDate date];
    self.timeOfEntry = now;
 
    NSDateComponents *components = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit   fromDate:now];
    NSLog(@"Year: %d", [components year]);
    NSLog(@"Month: %d", [components month]);
    NSLog(@"Day: %d", [components day]);
    NSLog(@"Hour: %d:%d", [components hour], [components minute]);

    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"dd-MM-yyyy"];
    NSString *stringOut = [fmt stringFromDate:now];
    NSLog(@"Datum: %@", stringOut);
    
    //--------------------------------------------------
    
    NSNumber *physical = [NSNumber numberWithFloat:self.energyLevelSlider.value];
    NSNumber *mental = [NSNumber numberWithFloat:self.mentalEnergyLevelSlider.value];

    
    NSManagedObjectContext *context = [self managedObjectContext];
    Energie *energieData = [NSEntityDescription insertNewObjectForEntityForName:@"Energie" inManagedObjectContext:self.managedObjectContext];
    energieData.timeOfEntry = self.timeOfEntry;
    //energieData.hourOfEntry =
    energieData.physicalEnergy = physical;
    energieData.mentalEnergy = mental;
    
    NSError *error;
    if (![context save:&error])
    {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
 
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Energie" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
  for (Energie *energie in fetchedObjects)
  {
      NSLog(@"Tijd: %@", energie.timeOfEntry);
  }
    
}

@end
