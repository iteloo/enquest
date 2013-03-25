//
//  DraftSite.m
//  enQuest
//
//  Created by Leo on 03/22/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import "DraftSite.h"
#import "DraftSite.h"
#import "StackMob.h"


@implementation DraftSite

@dynamic draftsiteId;
@dynamic name;
@dynamic note;
@dynamic location;
@dynamic radius;
@dynamic dependencies;
@dynamic dependents;
@dynamic quest;
@dynamic visits;
@dynamic destinationOf;

- (id)initIntoManagedObjectContext:(NSManagedObjectContext *)context;
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    
    if (self = [super initWithEntity:entity insertIntoManagedObjectContext:context]) {
        [self setValue:[self assignObjectId] forKey:[self primaryKeyField]];
    }
    
    return self;
}

@end
