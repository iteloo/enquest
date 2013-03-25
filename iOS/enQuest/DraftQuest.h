//
//  DraftQuest.h
//  enQuest
//
//  Created by Leo on 03/22/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User, DraftSite;

@interface DraftQuest : NSManagedObject

@property (nonatomic, retain) NSString *draftquestId;
@property (nonatomic, retain) NSDate *createddate;
@property (nonatomic, retain) NSDate *lastmoddate;
@property (nonatomic, retain) User *author;
@property NSString *initialNote;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * questDescription;
@property (nonatomic, retain) DraftSite *destination;
@property (nonatomic, retain) NSSet *sites;

- (id)initIntoManagedObjectContext:(NSManagedObjectContext *)context;

@end

@interface DraftQuest (CoreDataGeneratedAccessors)

- (void)addAuthorObject:(User *)value;
- (void)removeAuthorObject:(User *)value;

- (void)addDraftSitesObject:(DraftSite *)value;
- (void)removeDraftSitesObject:(DraftSite *)value;
- (void)addDraftSites:(NSSet *)values;
- (void)removeDraftSites:(NSSet *)values;

@end