//
//  DraftViewController.m
//  enQuest
//
//  Created by Leo on 03/23/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import "DraftViewController.h"
#import "CoreDataManager.h"
#import "DraftQuest.h"
#import "StackMob.h"

@interface DraftViewController ()

@end

@implementation DraftViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    /** tmp for testing **/
    NSManagedObjectContext *context = [CoreDataManager sharedManager].dump;
    DraftQuest *newDraft = [[DraftQuest alloc] initIntoManagedObjectContext:context];
    [context saveOnSuccess:^{
        NSLog(@"New draft created");
    } onFailure:^(NSError *error) {
        [context deleteObject:newDraft];
        
        /* present alert */
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:error.localizedDescription message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (!_fetchedResultsController) {
        CoreDataManager *dataManager = [CoreDataManager sharedManager];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"DraftQuest" inManagedObjectContext:dataManager.dump];
        /** change to createddate after solving key-value coding error **/
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"createddate" ascending:NO];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = entity;
        request.sortDescriptors = [NSArray arrayWithObjects:sort, nil];
        
        NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:dataManager.dump sectionNameKeyPath:nil cacheName:@"Draft Results Cache"];
        controller.delegate = self;
        
        NSError *error = nil;
        if (![controller performFetch:&error]) {
            NSLog(@"in draftView: fetchedResultsController");
            NSLog(@"...initial fetch failed with error: %@",error);
        }
        
        _fetchedResultsController = controller;
    }
	return _fetchedResultsController;
}

- (IBAction)enterEditMode:(id)sender {
}

#pragma mark -
#pragma mark NSFetchedResultsControllerDelegate methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	NSLog(@"in hist::controller:didChangeObject:...:");
    switch(type) {
			
        case NSFetchedResultsChangeInsert:
			NSLog(@"...Insert");
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
            break;
			
        case NSFetchedResultsChangeDelete:
			NSLog(@"...Delete");
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            break;
			
        case NSFetchedResultsChangeUpdate:
			NSLog(@"...Update");
			/** implement **/
            break;
			
        case NSFetchedResultsChangeMove:
			NSLog(@"...Move");
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
	return sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"DraftCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
	
	DraftQuest *draft = [self.fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = draft.name;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo name];
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSManagedObject *objToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
		[[CoreDataManager sharedManager].dump deleteObject:objToDelete];
		SAVE_TO_DUMP()
    }
}

@end
