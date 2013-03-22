//
//  Quest.h
//  enQuest
//
//  Created by Leo on 03/21/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Quest : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSMutableArray *sites;


@end
