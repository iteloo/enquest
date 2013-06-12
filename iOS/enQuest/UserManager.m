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
#import "CoreDataManager.h"

@implementation UserManager

SYNTHESIZE_GOD(UserManager, sharedManager);

@synthesize status = _status;
@synthesize currentUser = _currentUser;

- (void)refreshLoginStatus
{
    SMClient *client = [SMClient defaultClient];
    if (client.networkMonitor.currentNetworkStatus == SMNetworkStatusReachable) {
        NSLog(@"...attempting to retrieve user info from StackMob");
        /* if network is reacheable, try to get user from server */
        [client getLoggedInUserOnSuccess:^(NSDictionary *result) {
            NSLog(@"...already logged in: %@", result);
            
            /* todo: assert same username as one in user defaults */
            
            // fetch user object
            NSFetchRequest *userFetch = [[NSFetchRequest alloc] initWithEntityName:@"User"];
            [userFetch setPredicate:[NSPredicate predicateWithFormat:@"username == %@", [result objectForKey:@"username"]]];
            NSManagedObjectContext *context = [CoreDataManager sharedManager].dump;
            [context executeFetchRequest:userFetch onSuccess:^(NSArray *results) {                
                // update current user data
                [self setCurrentUser:[results lastObject]];
                
                [self updateStatus:LoggedIn];
            } onFailure:^(NSError *error) {
                NSLog(@"Error fetching user object: %@", error);
                /** todo: handle this **/
            }];
            
        } onFailure:^(NSError *error) {
            /* if not logged in, change status and */
            NSLog(@"...not logged in yet");
            [self updateStatus:LoggedOut];
        }];
    }
    else {
        /* if network is unreacheable, try to read username from user defaults */
        if (!self.currentUser) {
            /* if username is not stored, change status to logout */
            if (![self retrieveSavedUser]) {
                NSLog(@"...no login info stored");
                [self updateStatus:LoggedOut];
            }
        }
        else {
            [self updateStatus:LoggedIn];
        }
    }
}

- (void)updateStatus:(LoginStatus)newStatus
{
    LoginStatus currentStatus = self.status;
    _status = newStatus;
    
    if (newStatus == LoggedIn && currentStatus == LoggedOut) {
        NSLog(@"...Sending Login Notification!");
        [[NSNotificationCenter defaultCenter] postNotificationName:LoginNotification object:nil];
    }
    else if (newStatus == LoggedOut && currentStatus == LoggedIn) {
        NSLog(@"...Sending Logout Notification!");
        [[NSNotificationCenter defaultCenter] postNotificationName:LogoutNotification object:nil];
    }
}

- (void)handleLogout
{
    [self setCurrentUser:nil];
    [self refreshLoginStatus];
}

- (BOOL)retrieveSavedUser
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:LoginInformationStoredKey]) {
        NSString *username = [defaults objectForKey:StoredUsernameKey];
        NSLog(@"...Login info retrieved: { username : %@ }", username);
        
        // fetch user object (synchronously)
        NSFetchRequest *userFetch = [[NSFetchRequest alloc] initWithEntityName:@"User"];
        userFetch.predicate = [NSPredicate predicateWithFormat:@"username == %@", username];
        NSManagedObjectContext *context = [CoreDataManager sharedManager].dump;
        
        NSError *err = nil;
        NSArray *results = [context executeFetchRequest:userFetch error:&err];
        if ([results count] == 1) {
            // update current user data
            _currentUser = [results lastObject];
            return YES;
        }
        else {
            NSLog(@"Error fetching user object: %@", err);
            return NO;
        }
    }
    return NO;
}

- (void)setCurrentUser:(User *)u
{
    _currentUser = u;
    
    // save preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (u) {
        [defaults setBool:YES forKey:LoginInformationStoredKey];
    }
    else {
        [defaults setBool:NO forKey:LoginInformationStoredKey];
    }
    [defaults setObject:u.username forKey:StoredUsernameKey];
    BOOL success = [defaults synchronize];
    NSAssert(success, @"login info save failed");
    NSLog(@"...Login info saved: { username : %@ }", u.username);
}


@end
