//
//  DependenciesViewController.h
//  enQuest
//
//  Created by Leo on 03/26/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Site;

@interface DependenciesViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) Site *site;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
- (IBAction)addNewDependency:(id)sender;

@end
