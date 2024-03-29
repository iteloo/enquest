//
//  DraftViewController.m
//  enQuest
//
//  Created by Leo on 03/23/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import "DraftViewController.h"
#import "CoreDataManager.h"
#import "Quest.h"
#import "DraftEditorViewController.h"
#import "UserManager.h"
#import "QuestCell.h"
#import "User.h"

@interface DraftViewController ()

@end

@implementation DraftViewController

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
    __weak DraftViewController *bself = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [bself.fetchedResultsController performFetch:nil];
        [bself.tableView reloadData];
        [bself.tableView.pullToRefreshView stopAnimating];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLogin) name:LoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLogout) name:LogoutNotification object:nil];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // attach draft to DraftViewController
    UITableViewCell *senderCell = sender;
    NSIndexPath *path = [self.tableView indexPathForCell:senderCell];
    DraftEditorViewController *controller = segue.destinationViewController;
    controller.draft = [self.fetchedResultsController objectAtIndexPath:path];
}

- (void)handleLogin
{
    NSLog(@"...deleting fetchedResultsController");
    
    // change fetchedResultsController
    [NSFetchedResultsController deleteCacheWithName:self.fetchedResultsController.cacheName];
    /** need to make sure fetchcontroller is set up properly **/    
    [self.tableView reloadData];
}

- (void)handleLogout
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    self.fetchedResultsController = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (!_fetchedResultsController) {
        CoreDataManager *dataManager = [CoreDataManager sharedManager];
        User *user = [UserManager sharedManager].currentUser;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Quest" inManagedObjectContext:dataManager.dump];
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"lastmoddate" ascending:NO];
        /** fix problem of deletion when changing sites **/
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"author == %@", user];
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"published == NO"];
        NSPredicate *andPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:predicate1, predicate2, nil]];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = entity;
        request.predicate = predicate2; //hack: compound predicates currently not supported
        request.sortDescriptors = [NSArray arrayWithObjects:sort, nil];
        
        NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:dataManager.dump sectionNameKeyPath:nil cacheName:nil];
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

- (IBAction)addNewDraft:(id)sender {
    
    //make new draft
    NSManagedObjectContext *context = [CoreDataManager sharedManager].dump;
    Quest *newDraft = [[Quest alloc] initIntoManagedObjectContext:context];
    newDraft.author = [UserManager sharedManager].currentUser;
    newDraft.name = @"Untitled Draft";
    newDraft.published = [NSNumber numberWithBool:NO];
    
    //save (change will be picked up by fetchedResultsController)
    [context saveOnSuccess:^{
        NSLog(@"New draft created");
    } onFailure:^(NSError *error) {
        [context deleteObject:newDraft];
        NSLog(@"Error creating draft: %@", error);
        
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
	NSLog(@"in drafts::controller:didChangeObject:...:");
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
            /** hack: sometimes update gets reported as move **/
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
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
    Quest *draft = [self.fetchedResultsController objectAtIndexPath:indexPath];
    QuestCell *questCell = (QuestCell*)cell;
    questCell.questNameLabel.text = draft.name;
    questCell.authorLabel.text = draft.author.username;
    questCell.questDescriptionLabel.text = draft.questDescription;
    NSUInteger numberOfSites = [draft.sites count];
    questCell.metaDataLabel.text = [NSString stringWithFormat:(numberOfSites==1 ? @"%d site" : @"%d sites"), numberOfSites];
}

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
