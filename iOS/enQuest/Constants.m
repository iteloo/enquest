//
//  Constants.m
//  enQuest
//
//  Created by Leo on 03/15/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import "Constants.h"


NSString *const EQServerDomain = @"http://enquest.nickadams.ca:80/";
//NSString *const EQServerDomain = @"http://192.168.0.101:8000/";
//NSString *const EQServerDomain = @"http://192.168.1.64:8000/";
NSString *const EQErrorDomain = @"com.iteloolab.enQuest.ErrorDomain";
const NSTimeInterval StandardConnectionTimeoutPeriod = 7.0;
const CGFloat DisabledButtonAlpha = 0.5;

NSString *const LoginNotification = @"LoginNotification";
NSString *const LogoutNotification = @"LogoutNotification";

NSString *const LoginInformationStoredKey = @"LoginInformationStoredKey";
NSString *const StoredUsernameKey = @"StoredUsernameKey";
NSString *const StoredPasswordKey = @"StoredPasswordKey";