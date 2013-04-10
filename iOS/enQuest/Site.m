//
//  Site.m
//  enQuest
//
//  Created by Leo on 03/26/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import "Quest.h"
#import "Site.h"
#import "Visit.h"


@implementation Site

@dynamic name;
@dynamic siteId;
@dynamic location;
@dynamic radius;
@dynamic dialogue;
@dynamic quest;
@dynamic destinationOf;
@dynamic dependencies;
@dynamic dependents;
@dynamic visits;


- (id)initIntoManagedObjectContext:(NSManagedObjectContext *)context;
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    
    if (self = [super initWithEntity:entity insertIntoManagedObjectContext:context]) {
        [self setValue:[self assignObjectId] forKey:[self primaryKeyField]];
        self.radius = [NSNumber numberWithFloat:10.0];
    }
    
    return self;
}

@end
