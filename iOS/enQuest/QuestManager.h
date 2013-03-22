//
//  QuestManager.h
//  enQuest
//
//  Created by Leo on 03/21/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) NSArray *quests;
@property (nonatomic, strong) CLLocationManager *locationManager;

+ (QuestManager *)sharedManager;
- (BOOL)registerRegionWithCircularOverlay:(MKCircle*)overlay andIdentifier:(NSString*)identifier;

@end
