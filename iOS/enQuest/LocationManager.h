//
//  LocationManager.h
//  enQuest
//
//  Created by Leo on 04/08/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

+ (LocationManager*)sharedManager;
- (void)updateSitesTracked;

@end
