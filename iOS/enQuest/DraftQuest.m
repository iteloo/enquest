//
//  DraftQuest.m
//  enQuest
//
//  Created by Leo on 03/22/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import "DraftQuest.h"
#import "User.h"


@implementation DraftQuest

@dynamic draftquestId;
@dynamic createddate;
@dynamic lastmoddate;
@dynamic author;

- (id)initIntoManagedObjectContext:(NSManagedObjectContext *)context {
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    
    if (self = [super initWithEntity:entity insertIntoManagedObjectContext:context]) {
        [self setValue:[self assignObjectId] forKey:[self primaryKeyField]];
    }
    
    return self;
}

@end
