//
//  DraftQuest.h
//  enQuest
//
//  Created by Leo on 03/22/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Quest.h"

@class User;

@interface DraftQuest : Quest

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) User *author;

@end
