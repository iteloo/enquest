//
//  GamesViewController.m
//  enQuest
//
//  Created by Leo on 04/10/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import "GamesViewController.h"
#import "GameDetailViewController.h"
#import "CoreDataManager.h"
#import "UserManager.h"
#import "Game.h"
#import "User.h"
#import "Quest.h"
#import "QuestCell.h"

@interface GamesViewController ()

@end

@implementation GamesViewController

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
    __weak GamesViewController *bself = self;
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
    // attach game to detail view controller
    UITableViewCell *senderCell = sender;
    NSIndexPath *path = [self.tableView indexPathForCell:senderCell];
    GameDetailViewController *controller = segue.destinationViewController;
    controller.game = [self.fetchedResultsController objectAtIndexPath:path];
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
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:dataManager.dump];
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"lastmoddate" ascending:NO];
        /** fix problem of deletion when changing sites **/
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"player == %@", user];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = entity;
        request.predicate = predicate1;
        request.sortDescriptors = [NSArray arrayWithObjects:sort, nil];
        
        NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:dataManager.dump sectionNameKeyPath:nil cacheName:nil];
        controller.delegate = self;
        
        NSError *error = nil;
        if (![controller performFetch:&error]) {
            NSLog(@"in gamesView: fetchedResultsController");
            NSLog(@"...initial fetch failed with error: %@",error);
        }
        
        _fetchedResultsController = controller;
    }
	return _fetchedResultsController;
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
	NSLog(@"in games::controller:didChangeObject:...:");
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
    /** todo: specialized cell? **/
    Game *game = [self.fetchedResultsController objectAtIndexPath:indexPath];
    Quest *quest = game.quest;
    QuestCell *questCell = (QuestCell*)cell;
    questCell.questNameLabel.text = quest.name;
    questCell.authorLabel.text = quest.author.username;
    questCell.questDescriptionLabel.text = quest.questDescription;
    NSUInteger numberOfSites = [quest.sites count];
    questCell.metaDataLabel.text = [NSString stringWithFormat:(numberOfSites==1 ? @"%d / %d site visitied" : @"%d / %d sites visited"), [game.visits count], numberOfSites];
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
    
    static NSString *CellIdentifier = @"GameCell";
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

@end
