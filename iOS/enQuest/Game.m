//
//  Game.m
//  enQuest
//
//  Created by Leo on 03/22/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import "Game.h"
#import "User.h"


@implementation Game

@dynamic status;
@dynamic player;
@dynamic quest;
@dynamic visits;

- (id)initIntoManagedObjectContext:(NSManagedObjectContext *)context
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    
    if (self = [super initWithEntity:entity insertIntoManagedObjectContext:context]) {
        [self setValue:[self assignObjectId] forKey:[self primaryKeyField]];
        self.status = [NSNumber numberWithInt:GameStatusActive];
    }
    
    return self;
}

@end
