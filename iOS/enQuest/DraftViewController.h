//
//  DraftViewController.h
//  enQuest
//
//  Created by Leo on 03/23/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DraftViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (IBAction)enterEditMode:(id)sender;

@end
