//
//  QuestManager.m
//  enQuest
//
//  Created by Leo on 03/21/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import "SYNTHESIZE_GOD.h"

#import "QuestManager.h"

@implementation QuestManager

SYNTHESIZE_GOD(QuestManager, sharedManager);

@synthesize quests;
@synthesize locationManager;


- (id)init
{
    if (self = [super init]) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        
        /** check regionMonitoringAvailable and authorizationStatus **/
        
        
    }
    return self;
}

- (BOOL)registerRegionWithCircularOverlay:(MKCircle*)overlay andIdentifier:(NSString*)identifier {
    
    /** add in error handling **/
    // Do not create regions if support is unavailable or disabled
    if ( ![CLLocationManager regionMonitoringAvailable])
        return NO;
    
    // Check the authorization status
    if (([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) &&
        ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusNotDetermined))
        return NO;
    
    /** tmp: Clear out any old regions to prevent buildup. **/
    if ([self.locationManager.monitoredRegions count] > 0) {
        for (id obj in locationManager.monitoredRegions)
            [locationManager stopMonitoringForRegion:obj];
    }
    
    // If the overlay's radius is too large, registration fails automatically,
    // so clamp the radius to the max value.
    CLLocationDegrees radius = overlay.radius;
    CLLocationDegrees maxRadius = locationManager.maximumRegionMonitoringDistance;
    if (radius > maxRadius) {
        radius = maxRadius;
    }
    
    // Create and monitor region
    CLRegion* region = [[CLRegion alloc] initCircularRegionWithCenter:overlay.coordinate radius:radius identifier:identifier];
    [locationManager startMonitoringForRegion:region];
    return YES;
}



@end
