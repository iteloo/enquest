//
//  DraftSitesViewController.h
//  enQuest
//
//  Created by Leo on 03/23/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DraftQuest;

@interface DraftSitesViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) DraftQuest *draft;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;


@end
