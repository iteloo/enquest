//
//  Site.h
//  enQuest
//
//  Created by Leo on 03/26/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Quest, Site, Visit, DraftSite;

@interface Site : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * siteId;
@property (nonatomic, retain) id location;
@property (nonatomic, retain) NSNumber * radius;
@property (nonatomic, retain) NSString * dialogue;
@property (nonatomic, retain) Quest *quest;
@property (nonatomic, retain) Quest *destinationOf;
@property (nonatomic, retain) NSSet *dependencies;
@property (nonatomic, retain) NSSet *dependents;
@property (nonatomic, retain) NSSet *visits;

- (id)initIntoManagedObjectContext:(NSManagedObjectContext *)context withDraftSite:(DraftSite*)draftSite;

@end

@interface Site (CoreDataGeneratedAccessors)

- (void)addDependenciesObject:(Site *)value;
- (void)removeDependenciesObject:(Site *)value;
- (void)addDependencies:(NSSet *)values;
- (void)removeDependencies:(NSSet *)values;

- (void)addDependentsObject:(Site *)value;
- (void)removeDependentsObject:(Site *)value;
- (void)addDependents:(NSSet *)values;
- (void)removeDependents:(NSSet *)values;

- (void)addVisitsObject:(Visit *)value;
- (void)removeVisitsObject:(Visit *)value;
- (void)addVisits:(NSSet *)values;
- (void)removeVisits:(NSSet *)values;

@end
