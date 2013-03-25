//
//  Visit.h
//  enQuest
//
//  Created by Leo on 03/22/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game, DraftSite;

@interface Visit : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * log;
@property (nonatomic, retain) Game *game;
@property (nonatomic, retain) DraftSite *site;

@end
