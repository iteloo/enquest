//
//  CoreDataMacros.h
//  enQuest
//
//  Created by Leo on 03/23/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#define FETCH(managedObjectContext, request, results) \
\
{ \
NSError *my_error; \
results = [managedObjectContext executeFetchRequest:request error:&my_error]; \
if (!results) { \
NSLog(@"...fetch failed with error: %@ userInfo:%@", my_error, my_error.userInfo); \
exit(EXIT_FAILURE); \
} \
}

#define FETCH_FROM_DUMP(request, results) \
\
FETCH([CoreDataManager sharedManager].dump, request, results)

#define SAVE(managedObjectContext) \
\
{ \
NSError *my_error; \
if (![managedObjectContext save:&my_error]) { \
NSLog(@"...save failed with error: %@ userInfo:%@", my_error, my_error.userInfo); \
exit(EXIT_FAILURE); \
} \
}

#define SAVE_TO_DUMP() SAVE([CoreDataManager sharedManager].dump)