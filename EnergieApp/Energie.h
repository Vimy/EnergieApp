//
//  Energie.h
//  EnergieApp
//
//  Created by Matthias Vermeulen on 8/02/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Energie : NSManagedObject

@property (nonatomic, retain) NSNumber * mentalEnergy;
@property (nonatomic, retain) NSNumber * physicalEnergy;
@property (nonatomic, retain) NSDate * dayOfEntry;
@property (nonatomic, retain) NSDate * hourOfEntry;
@property (nonatomic, retain) NSDate * timeOfEntry;

@end
