//
//  Quest.h
//  enQuest
//
//  Created by Leo on 03/26/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game, Site, User;

@interface Quest : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * createddate;
@property (nonatomic, retain) NSDate * lastmoddate;
@property (nonatomic, retain) NSNumber *published;
@property (nonatomic, retain) NSString * questId;
@property (nonatomic, retain) NSString * initialNote;
@property (nonatomic, retain) NSString * questDescription;
@property (nonatomic, retain) User *author;
@property (nonatomic, retain) NSSet *games;
@property (nonatomic, retain) Site *destination;
@property (nonatomic, retain) NSSet *sites;

- (id)initIntoManagedObjectContext:(NSManagedObjectContext *)context;

@end

@interface Quest (CoreDataGeneratedAccessors)

- (void)addGamesObject:(Game *)value;
- (void)removeGamesObject:(Game *)value;
- (void)addGames:(NSSet *)values;
- (void)removeGames:(NSSet *)values;

- (void)addSitesObject:(Site *)value;
- (void)removeSitesObject:(Site *)value;
- (void)addSites:(NSSet *)values;
- (void)removeSites:(NSSet *)values;

@end
