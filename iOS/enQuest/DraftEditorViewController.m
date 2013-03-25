//
//  DraftEditorViewController.m
//  enQuest
//
//  Created by Leo on 03/23/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import "DraftEditorViewController.h"
#import "DraftQuest.h"
#import "CoreDataManager.h"
#import "StackMob.h"
#import "DraftSitesViewController.h"

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
    [self updateViewUsingData];
}

- (void)updateViewUsingData;
{
    self.questNameLabel.text = self.draft.name;
    self.questDescriptionLabel.text = self.draft.questDescription;
    self.questNoteLabel.text = self.draft.initialNote;
    self.sitesLabel.text = [NSString stringWithFormat:@"%d sites",[self.draft.sites count]];
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
    [self.tableView reloadData];
    [self saveData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setQuestNameLabel:nil];
    [self setQuestDescriptionLabel:nil];
    [self setQuestNoteLabel:nil];
    [self setSitesLabel:nil];
    [super viewDidUnload];
}

@end
