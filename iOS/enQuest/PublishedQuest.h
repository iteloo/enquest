//
//  PublishedQuest.h
//  enQuest
//
//  Created by Leo on 03/22/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Quest.h"

@class Game, User;

@interface PublishedQuest : Quest

@property (nonatomic, retain) NSDate * publishDate;
@property (nonatomic, retain) NSString * questDescription;
@property (nonatomic, retain) User *author;
@property (nonatomic, retain) NSSet *games;
@end

@interface PublishedQuest (CoreDataGeneratedAccessors)

- (void)addGamesObject:(Game *)value;
- (void)removeGamesObject:(Game *)value;
- (void)addGames:(NSSet *)values;
- (void)removeGames:(NSSet *)values;

@end
