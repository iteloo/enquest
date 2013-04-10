//
//  LocationManager.m
//  enQuest
//
//  Created by Leo on 04/08/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import "SYNTHESIZE_GOD.h"
#import "LocationManager.h"
#import "CoreDataManager.h"
#import "UserManager.h"
#import "User.h"
#import "Site.h"
#import "Game.h"
#import "Quest.h"

@implementation LocationManager

@synthesize locationManager;

SYNTHESIZE_GOD(LocationManager, sharedManager);

- (id)init
{
    if (self = [super init]) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSitesTracked) name:LoginNotification object:nil];
        

        /** check regionMonitoringAvailable and authorizationStatus **/
    }
    return self;
}

- (void)updateSitesTracked
{
    // get current location
    [SMGeoPoint getGeoPointForCurrentLocationOnSuccess:^(SMGeoPoint *geoPoint) {
        
        CoreDataManager *cdm = [CoreDataManager sharedManager];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Site" inManagedObjectContext:cdm.dump];
        NSSet *games = [UserManager sharedManager].currentUser.games;
        __block NSMutableArray *siteIds = [[NSMutableArray alloc] init];
        [games enumerateObjectsUsingBlock:^(Game *game, BOOL *stop) {
            [game.quest.sites enumerateObjectsUsingBlock:^(Site *site, BOOL *stop) {
                [siteIds addObject:site.siteId];
            }];
        }];
        /** hack: empty array seems to create bug **/
        [siteIds addObject:@"xxx"];
        
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"siteId IN %@", siteIds];
        //SMPredicate *predicate2 = [SMPredicate predicateWhere:@"location" isWithin:10 milesOfGeoPoint:geoPoint];
        //NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:predicate1, predicate2, nil]];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.entity = entity;
        fetchRequest.predicate = predicate1;
        
        [cdm.dump executeFetchRequest:fetchRequest onSuccess:^(NSArray *results) {
            NSLog(@"Successful geoquery.");
            [results enumerateObjectsUsingBlock:^(Site *siteToTrack, NSUInteger idx, BOOL *stop) {
                SMGeoPoint *point = [NSKeyedUnarchiver unarchiveObjectWithData:siteToTrack.location];
                CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake([[point latitude] floatValue], [[point longitude] floatValue]);
                MKCircle *overlay = [MKCircle circleWithCenterCoordinate:coordinates radius:[siteToTrack.radius floatValue]];
                [self registerRegionWithCircularOverlay:overlay andIdentifier:siteToTrack.siteId];
                NSLog(@"SMGeoPoint for site %@ in results: %@", siteToTrack, point);
            }];
        } onFailure:^(NSError *error) {
            NSLog(@"Error fetching closeby sites: %@", error);
        }];
        
    } onFailure:^(NSError *error) {
        NSLog(@"Error getting current location: %@", error);
    }];
}

- (BOOL)registerRegionWithCircularOverlay:(MKCircle*)overlay andIdentifier:(NSString*)identifier {
    
    /** add in error handling **/
    // Do not create regions if support is unavailable or disabled
    if (![CLLocationManager regionMonitoringAvailable])
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
