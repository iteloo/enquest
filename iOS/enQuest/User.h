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

@class Game, Quest;

@interface User : SMUserManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSSet *games;
@property (nonatomic, retain) NSSet *quests;

- (id)initIntoManagedObjectContext:(NSManagedObjectContext *)context;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addGamesObject:(Game *)value;
- (void)removeGamesObject:(Game *)value;
- (void)addGames:(NSSet *)values;
- (void)removeGames:(NSSet *)values;

- (void)addQuestsObject:(Quest *)value;
- (void)removeQuestsObject:(Quest *)value;
- (void)addQuests:(NSSet *)values;
- (void)removeQuests:(NSSet *)values;

@end
