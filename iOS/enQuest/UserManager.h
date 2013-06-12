//
//  UserManager.h
//  enQuest
//
//  Created by Leo on 03/22/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LoggedIn,
    LoggedOut
} LoginStatus;

@class User;

@interface UserManager : NSObject

@property (nonatomic, readonly) LoginStatus status;
@property (nonatomic, readonly) User *currentUser;

+ (UserManager*)sharedManager;
- (void)refreshLoginStatus;
- (BOOL)retrieveSavedUser;

// tmp
- (void)handleLogout;

@end
