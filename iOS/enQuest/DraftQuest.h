//
//  DraftQuest.h
//  enQuest
//
//  Created by Leo on 03/22/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Quest.h"

@class User;

@interface DraftQuest : Quest

@property (nonatomic, retain) NSString *draftquestId;
@property (nonatomic, retain) NSDate *createddate;

- (id)initIntoManagedObjectContext:(NSManagedObjectContext *)context;

@end

@interface DraftQuest (CoreDataGeneratedAccessors)

- (void)addAuthorObject:(User *)value;
- (void)removeAuthorObject:(User *)value;

@end