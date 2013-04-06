//
//  DraftSitesViewController.h
//  enQuest
//
//  Created by Leo on 03/23/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Quest;

@interface DraftSitesViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) Quest *draft;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;


@end
