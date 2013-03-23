//
//  User.h
//  enQuest
//
//  Created by Leo on 03/22/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "StackMob.h"

@class DraftQuest, Game, PublishedQuest;

@interface User : SMUserManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *games;
@property (nonatomic, retain) NSSet *drafts;
@property (nonatomic, retain) NSSet *publishedQuests;

- (id)initIntoManagedObjectContext:(NSManagedObjectContext *)context;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addGamesObject:(Game *)value;
- (void)removeGamesObject:(Game *)value;
- (void)addGames:(NSSet *)values;
- (void)removeGames:(NSSet *)values;

- (void)addDraftsObject:(DraftQuest *)value;
- (void)removeDraftsObject:(DraftQuest *)value;
- (void)addDrafts:(NSSet *)values;
- (void)removeDrafts:(NSSet *)values;

- (void)addPublishedQuestsObject:(PublishedQuest *)value;
- (void)removePublishedQuestsObject:(PublishedQuest *)value;
- (void)addPublishedQuests:(NSSet *)values;
- (void)removePublishedQuests:(NSSet *)values;

@end
