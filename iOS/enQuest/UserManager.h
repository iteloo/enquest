//
//  UserManager.h
//  enQuest
//
//  Created by Leo on 03/22/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface UserManager : NSObject

@property (nonatomic, strong) User *currentUser;
/** tmp **/
@property (nonatomic, strong) NSString *currentUsername;
@property (nonatomic, strong) NSString *currentPassword;

+ (UserManager*)sharedManager;

/** tmp **/
- (void)setCurrentUser:(User*)u password:(NSString *)p;
- (BOOL)retrieveSavedUser;

@end
