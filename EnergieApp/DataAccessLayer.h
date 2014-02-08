//
//  DataAccessLayer.h
//  EnergieApp
//
//  Created by Matthias Vermeulen on 31/01/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface DataAccessLayer : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *storeCoordinator;

+ (DataAccessLayer *)sharedInstance;
- (void)saveContext;

@end
