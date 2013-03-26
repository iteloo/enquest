//
//  DraftSite.h
//  enQuest
//
//  Created by Leo on 03/22/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DraftQuest;

@interface DraftSite : NSManagedObject

@property (nonatomic, retain) NSString *draftsiteId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * dialogue;
@property (nonatomic, retain) id location;
@property (nonatomic, retain) NSNumber * radius;
@property (nonatomic, retain) NSSet *dependencies;
@property (nonatomic, retain) NSSet *dependents;
@property (nonatomic, retain) DraftQuest *quest;
@property (nonatomic, retain) DraftQuest *destinationOf;

- (id)initIntoManagedObjectContext:(NSManagedObjectContext *)context;

@end


@interface DraftSite (CoreDataGeneratedAccessors)

- (void)addDependenciesObject:(DraftSite *)value;
- (void)removeDependenciesObject:(DraftSite *)value;
- (void)addDependencies:(NSSet *)values;
- (void)removeDependencies:(NSSet *)values;

- (void)addDependentsObject:(DraftSite *)value;
- (void)removeDependentsObject:(DraftSite *)value;
- (void)addDependents:(NSSet *)values;
- (void)removeDependents:(NSSet *)values;

@end
