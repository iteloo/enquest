//
//  Game.h
//  enQuest
//
//  Created by Leo on 03/22/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef enum {
    GameStatusActive = 0
} GameStatus;

@class User, Quest;

@interface Game : NSManagedObject

@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) User *player;
@property (nonatomic, retain) Quest *quest;
@property (nonatomic, retain) NSSet *visits;

- (id)initIntoManagedObjectContext:(NSManagedObjectContext *)context;

@end

@interface Game (CoreDataGeneratedAccessors)

- (void)addVisitsObject:(NSManagedObject *)value;
- (void)removeVisitsObject:(NSManagedObject *)value;
- (void)addVisits:(NSSet *)values;
- (void)removeVisits:(NSSet *)values;

@end
