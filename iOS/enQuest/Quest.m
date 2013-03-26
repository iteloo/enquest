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
#import "DraftQuest.h"
#import "DraftSite.h"


@implementation Quest

@dynamic name;
@dynamic createddate;
@dynamic lastmoddate;
@dynamic questId;
@dynamic initialNote;
@dynamic questDescription;
@dynamic author;
@dynamic games;
@dynamic destination;
@dynamic sites;

- (id)initIntoManagedObjectContext:(NSManagedObjectContext *)context withDraft:(DraftQuest*)draft
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    
    if (self = [super initWithEntity:entity insertIntoManagedObjectContext:context]) {
        [self setValue:[self assignObjectId] forKey:[self primaryKeyField]];
        self.name = draft.name;
        self.initialNote = draft.initialNote;
        self.questDescription = draft.questDescription;
        self.author = draft.author;
        
        // use a dictionary to record correspondence so we can copy dependencies
        NSMutableDictionary *draftSiteToSite = [[NSMutableDictionary alloc] initWithCapacity:[draft.sites count]];
        for (DraftSite *draftSite in draft.sites) {
            Site *site = [[Site alloc] initIntoManagedObjectContext:context withDraftSite:draftSite];
            [draftSiteToSite setObject:site forKey:draftSite.draftsiteId];
            [self addSitesObject:site];
            if (draftSite.destinationOf) {
                self.destination = site;
            }
            
        }
        
        // add dependencies
        for (DraftSite *draftSite in draft.sites) {
            Site *site = [draftSiteToSite objectForKey:draftSite.draftsiteId];
            for (DraftSite *draftDependent in draftSite.dependents) {
                Site *dependent = [draftSiteToSite objectForKey:draftDependent.draftsiteId];
                [site addDependentsObject:dependent];
            }
        }
    }

    return self;
}

@end
