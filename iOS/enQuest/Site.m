//
//  Site.m
//  enQuest
//
//  Created by Leo on 03/26/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import "Site.h"
#import "Quest.h"
#import "Site.h"
#import "Visit.h"
#import "DraftSite.h"
#import "StackMob.h"


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

- (id)initIntoManagedObjectContext:(NSManagedObjectContext *)context withDraftSite:(DraftSite*)draftSite
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    
    if (self = [super initWithEntity:entity insertIntoManagedObjectContext:context]) {
        [self setValue:[self assignObjectId] forKey:[self primaryKeyField]];
        self.name = draftSite.name;
        self.dialogue = draftSite.dialogue;
        self.location = draftSite.location;
        self.radius = draftSite.radius;
    }
    
    return self;
}

@end
