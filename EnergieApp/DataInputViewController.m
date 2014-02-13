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
@property (weak, nonatomic) IBOutlet UIButton *submitDataButton;
@property (weak, nonatomic) IBOutlet UIButton *submitNoteButton;
@property (weak, nonatomic) IBOutlet UISlider *energyLevelSlider;
@property (weak, nonatomic) IBOutlet UILabel *energyValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *focusLevelSlider;
@property (weak, nonatomic) IBOutlet UILabel *focusValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *motivationLevelSlider;
@property (weak, nonatomic) IBOutlet UILabel *motivationValueLabel;

@property (strong, nonatomic) NSDate *timeOfEntry;
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

    
    
    
    NSError* err = nil;
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSArray* Banks = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
                                                     options:kNilOptions
                                                       error:&err];
    NSLog(@"Imported Banks: %@", Banks);
}


- (NSMutableArray*)energieData
{
    if(!_energieData)
    {
        _energieData = [[NSMutableArray alloc]init];
 
    }
    return _energieData;
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
    
 

    
    NSManagedObjectContext *context = [self managedObjectContext];
    Energie *energieData = [NSEntityDescription insertNewObjectForEntityForName:@"Energie" inManagedObjectContext:self.managedObjectContext];
    energieData.timeOfEntry = self.timeOfEntry;
    //energieData.hourOfEntry =
  
    energieData.energyLevel =  [NSNumber numberWithFloat:self.energyLevelSlider.value];
    energieData.focusLevel = [NSNumber numberWithFloat:self.focusLevelSlider.value];
    energieData.motivationLevel = [NSNumber numberWithFloat:self.motivationLevelSlider.value];
    
    
    NSError *error;
    if (![context save:&error])
    {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
 /*
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Energie" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
  for (Energie *energie in fetchedObjects)
  {
      NSLog(@"Tijd: %@", energie.timeOfEntry);
  }
    */
    
}

@end
