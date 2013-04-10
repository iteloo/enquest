//
//  DraftEditorViewController.m
//  enQuest
//
//  Created by Leo on 03/23/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import "DraftEditorViewController.h"
#import "Quest.h"
#import "CoreDataManager.h"
#import "DraftSitesViewController.h"
#import "Quest.h"

@interface DraftEditorViewController ()

@end

@implementation DraftEditorViewController

@synthesize draft;
@synthesize questNameLabel;
@synthesize questDescriptionLabel;
@synthesize questNoteLabel;
@synthesize sitesLabel;
@synthesize editingCell;

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateViewUsingData];
}

- (void)updateViewUsingData;
{
    self.questNameLabel.text = self.draft.name;
    self.questDescriptionLabel.text = self.draft.questDescription;
    self.questNoteLabel.text = self.draft.initialNote;
    NSUInteger numberOfSites = [self.draft.sites count];
    if (numberOfSites != 1) {
        self.sitesLabel.text = [NSString stringWithFormat:@"%d sites", numberOfSites];
    }
    else {
        self.sitesLabel.text = @"1 site";
    }
}

- (void)saveData
{
    /** save all data except for sites **/
    self.draft.name = self.questNameLabel.text;
    self.draft.questDescription = self.questDescriptionLabel.text;
    self.draft.initialNote = self.questNoteLabel.text;
    
    //save
    NSManagedObjectContext *context = [CoreDataManager sharedManager].dump;
    [context saveOnSuccess:^{
        NSLog(@"draft saved");
    } onFailure:^(NSError *error) {        
        /* present alert */
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:error.localizedDescription message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
    /** might disable offline caching? **/
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /** hack **/
    /** todo: also include bigger textviews **/
    UITableViewCell *senderCell = sender;
    if (senderCell.tag == 1) {
        self.editingCell = senderCell;
        TextFieldInputViewController *controller = segue.destinationViewController;
        controller.initialText = self.editingCell.detailTextLabel.text;
        controller.delegate = self;
    }
    else if (senderCell.tag == 2)
    {
        DraftSitesViewController *controller = segue.destinationViewController;
        controller.draft = self.draft;
    }
}

- (void)textFieldInputViewController:(TextFieldInputViewController *)controller didFinishEditingText:(NSString *)text
{
    self.editingCell.detailTextLabel.text = text;
    self.editingCell = nil;
    [self saveData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)publish:(id)sender {
    // disable button
    self.publishButton.enabled = NO;
    self.publishButton.alpha = DisabledButtonAlpha;
    
    // mark published
    NSManagedObjectContext *context = [CoreDataManager sharedManager].dump;
    self.draft.published = [NSNumber numberWithBool:YES];
    
    // save context
    [context saveOnSuccess:^{
        NSLog(@"Your draft is published!");
        
        // exit editor view
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        // present alert
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Congratulations, your draft is published!" message:@"Go tell everyone about it!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    } onFailure:^(NSError *error) {
        NSLog(@"Error publishing draft: %@", error);
        
        // reset published flag
        self.draft.published = [NSNumber numberWithBool:NO];
        
        // re-enable button
        self.publishButton.enabled = YES;
        self.publishButton.alpha = 1.0;
        
        // present alert
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:error.localizedDescription message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
}

- (IBAction)discard:(id)sender {
    // disable button
    self.discardButton.enabled = NO;
    self.discardButton.alpha = DisabledButtonAlpha;
    
    // delete managed object
    NSManagedObjectContext *context = [CoreDataManager sharedManager].dump;
    [context deleteObject:self.draft];
    [context saveOnSuccess:^{
        NSLog(@"draft deleted");
        
        // exit edit screen
        [self.navigationController popViewControllerAnimated:YES];
    } onFailure:^(NSError *error) {
        /* present alert */
        NSLog(@"cannot delete draft: %@", error);
        
        // display alert
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:error.localizedDescription message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        // re-enable button
        self.discardButton.enabled = YES;
        self.discardButton.alpha = 1.0;
    }];
}

@end
