//
//  Energie.h
//  EnergieApp
//
//  Created by Matthias Vermeulen on 13/02/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Energie : NSManagedObject

@property (nonatomic, retain) NSDate * dayOfEntry;
@property (nonatomic, retain) NSNumber * focusLevel;
@property (nonatomic, retain) NSDate * hourOfEntry;
@property (nonatomic, retain) NSNumber * energyLevel;
@property (nonatomic, retain) NSNumber * motivationLevel;
@property (nonatomic, retain) NSDate * timeOfEntry;

@end
