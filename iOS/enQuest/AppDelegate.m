//
//  AppDelegate.m
//  enQuest
//
//  Created by Leo on 03/13/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "User.h"
#import "CoreDataManager.h"
#import "UserManager.h"
#import "LocationManager.h"

@implementation AppDelegate

@synthesize client = _client;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //SM_CORE_DATA_DEBUG = YES;
    //SM_CACHE_ENABLED = YES;
    
    self.client = [[SMClient alloc] initWithAPIVersion:@"0" publicKey:@"8bbc858b-eb60-4e6b-a620-f74c7add5413"];
    [[CoreDataManager sharedManager] setUp];
    
    // init location manager
    [LocationManager sharedManager];
    
    // retrieve current user
    UserManager *userManager = [UserManager sharedManager];
    [userManager retrieveSavedUser];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
