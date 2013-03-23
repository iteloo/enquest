//
//  UserManager.m
//  enQuest
//
//  Created by Leo on 03/22/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import "SYNTHESIZE_GOD.h"
#import "UserManager.h"
#import "User.h"

@implementation UserManager

SYNTHESIZE_GOD(UserManager, sharedManager);

@synthesize currentUser = _currentUser;
@synthesize currentUsername = _currentUsername;
@synthesize currentPassword = _currentPassword;

- (void)setCurrentUser:(User*)u password:(NSString *)p
{
    self.currentUser = u;
    self.currentUsername = u.username;
    self.currentPassword = p;
    
    // save preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:LoginInformationStoredKey];
    [defaults setObject:u.username forKey:StoredUsernameKey];
    [defaults setObject:p forKey:StoredPasswordKey];
    BOOL success = [defaults synchronize];
    NSAssert(success, @"login info save failed");
    NSLog(@"...Login info saved: { %@ : %@ }", u.username, p);
}

- (BOOL)retrieveSavedUser
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:LoginInformationStoredKey]) {
        NSString *username = [defaults objectForKey:StoredUsernameKey];
        NSString *password = [defaults objectForKey:StoredPasswordKey];
        NSLog(@"...Login info retrieved: { %@ : %@ }", username, password);
        self.currentUsername = username;
        self.currentPassword = password;
        return YES;
    }
    return NO;
}

- (void)setCurrentUser:(User *)u
{
    _currentUser = u;
    if (!u) {
        self.currentPassword = nil;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:NO forKey:LoginInformationStoredKey];
        [defaults setObject:nil forKey:StoredUsernameKey];
        [defaults setObject:nil forKey:StoredPasswordKey];
        BOOL success = [defaults synchronize];
        NSAssert(success, @"login info reset save failed");
        NSLog(@"...Login info reset.");
    }
}


@end
