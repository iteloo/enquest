//
//  Site.h
//  enQuest
//
//  Created by Leo on 03/22/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Quest, Site;

@interface Site : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) id location;
@property (nonatomic, retain) NSNumber * radius;
@property (nonatomic, retain) NSSet *dependencies;
@property (nonatomic, retain) NSSet *dependents;
@property (nonatomic, retain) Quest *quest;
@property (nonatomic, retain) NSSet *visits;
@property (nonatomic, retain) Quest *destinationOf;
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

- (void)addVisitsObject:(NSManagedObject *)value;
- (void)removeVisitsObject:(NSManagedObject *)value;
- (void)addVisits:(NSSet *)values;
- (void)removeVisits:(NSSet *)values;

@end
