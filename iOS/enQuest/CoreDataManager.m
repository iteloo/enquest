//
//  CoreDataManager.m
//  enQuest
//
//  Created by Leo on 03/22/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import "SYNTHESIZE_GOD.h"
#import "CoreDataManager.h"
#import "StackMob.h"

@implementation CoreDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;

SYNTHESIZE_GOD(CoreDataManager, sharedManager);

- (void)setUp
{
    SMClient *client = [SMClient defaultClient];
    SMCoreDataStore *coreDataStore = [client coreDataStoreWithManagedObjectModel:self.managedObjectModel];
    self.managedObjectContext = [coreDataStore contextForCurrentThread];
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

@end
