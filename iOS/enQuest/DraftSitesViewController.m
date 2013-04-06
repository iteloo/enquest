//
//  DraftSitesViewController.m
//  enQuest
//
//  Created by Leo on 03/23/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import "DraftSitesViewController.h"
#import "CoreDataManager.h"
#import "Quest.h"
#import "Site.h"
#import "StackMob.h"
#import "SiteEditorViewController.h"

@interface DraftSitesViewController ()

@end

@implementation DraftSitesViewController

@synthesize draft;
@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // attach site to SiteEditorViewController
    UITableViewCell *senderCell = sender;
    NSIndexPath *path = [self.tableView indexPathForCell:senderCell];
    SiteEditorViewController *controller = segue.destinationViewController;
    controller.site = [self.fetchedResultsController objectAtIndexPath:path];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (!_fetchedResultsController) {
        CoreDataManager *dataManager = [CoreDataManager sharedManager];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Site" inManagedObjectContext:dataManager.dump];
        /** change sort method **/
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
        /** fix predicate problem of not getting local updates **/
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"quest == %@", self.draft.questId];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = entity;
        request.predicate = predicate;
        request.sortDescriptors = [NSArray arrayWithObjects:sort, nil];
        
        NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:dataManager.dump sectionNameKeyPath:nil cacheName:nil];
        controller.delegate = self;
        
        NSError *error = nil;
        if (![controller performFetch:&error]) {
            NSLog(@"in siteView: fetchedResultsController");
            NSLog(@"...initial fetch failed with error: %@",error);
        }
        
        _fetchedResultsController = controller;
    }
	return _fetchedResultsController;
}

- (IBAction)addNewSite:(id)sender {
    
    //make new site
    NSManagedObjectContext *context = [CoreDataManager sharedManager].dump;
    Site *newSite = [[Site alloc] initIntoManagedObjectContext:context];
    newSite.quest = self.draft;
    newSite.name = @"Untitled Site";
    
    [SMGeoPoint getGeoPointForCurrentLocationOnSuccess:^(SMGeoPoint *geoPoint) {
        
        newSite.location = [NSKeyedArchiver archivedDataWithRootObject:geoPoint];
        
        /** test **/
        SMGeoPoint *a = [NSKeyedUnarchiver unarchiveObjectWithData:newSite.location];
        NSLog(@"new location:%f,%f", [[a latitude] floatValue], [[a longitude] floatValue]);
        
        // save context
        [context saveOnSuccess:^{
            NSLog(@"New site created");
            NSError *error = nil;
            if (![self.fetchedResultsController performFetch:&error]) {
                NSLog(@"in siteView: addNewSite:");
                NSLog(@"...new fetch failed with error: %@",error);
            }
            [self.tableView reloadData];
            
        } onFailure:^(NSError *error) {
            [context deleteObject:newSite];
            NSLog(@"Error creating site: %@", error);
            
            /* present alert */
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:error.localizedDescription message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }];
        
    } onFailure:^(NSError *error) {
        NSLog(@"Error getting SMGeoPoint: %@", error);
        [context deleteObject:newSite];
        
        /* present alert */
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:error.localizedDescription message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
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
	NSLog(@"in sites::controller:didChangeObject:...:");
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
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
			
        case NSFetchedResultsChangeMove:
			NSLog(@"...Move");
            [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

#pragma mark -
#pragma mark UITableViewDataSource methods

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    Site *site = [self.fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = site.name;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%@",self.fetchedResultsController);
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    NSLog(@"%d",sectionInfo.numberOfObjects);
	return sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"DraftSiteCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    [self configureCell:cell atIndexPath:indexPath];
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo name];
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSManagedObject *objToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
		NSManagedObjectContext *context = [CoreDataManager sharedManager].dump;
        [context deleteObject:objToDelete];
		[context saveOnSuccess:^{
            NSLog(@"draft deleted");
        } onFailure:^(NSError *error) {
            /* present alert */
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:error.localizedDescription message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }];
    }
}


@end
