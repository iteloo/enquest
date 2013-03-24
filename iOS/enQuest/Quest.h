//
//  Quest.h
//  enQuest
//
//  Created by Leo on 03/22/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Site;

@interface Quest : NSManagedObject

@property (nonatomic, retain) NSString * initialNote;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * questDescription;
@property (nonatomic, retain) Site *destination;
@property (nonatomic, retain) NSSet *sites;
@end

@interface Quest (CoreDataGeneratedAccessors)

- (void)addSitesObject:(Site *)value;
- (void)removeSitesObject:(Site *)value;
- (void)addSites:(NSSet *)values;
- (void)removeSites:(NSSet *)values;

@end
