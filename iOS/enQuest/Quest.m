//
//  Quest.m
//  enQuest
//
//  Created by Leo on 03/26/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import "Quest.h"
#import "Game.h"
#import "Site.h"
#import "User.h"


@implementation Quest

@dynamic name;
@dynamic createddate;
@dynamic lastmoddate;
@dynamic published;
@dynamic questId;
@dynamic initialNote;
@dynamic questDescription;
@dynamic author;
@dynamic games;
@dynamic destination;
@dynamic sites;

- (id)initIntoManagedObjectContext:(NSManagedObjectContext *)context
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    
    if (self = [super initWithEntity:entity insertIntoManagedObjectContext:context]) {
        [self setValue:[self assignObjectId] forKey:[self primaryKeyField]];
    }

    return self;
}

@end
