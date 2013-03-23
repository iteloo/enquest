//
//  User.m
//  enQuest
//
//  Created by Leo on 03/22/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import "User.h"
#import "DraftQuest.h"
#import "Game.h"
#import "PublishedQuest.h"


@implementation User

@dynamic email;
@dynamic username;
@dynamic games;
@dynamic drafts;
@dynamic publishedQuests;

- (id)initIntoManagedObjectContext:(NSManagedObjectContext *)context {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    
    if (self) {
        // assign local variables and do other init stuff here
    }
    
    return self;
}

@end
