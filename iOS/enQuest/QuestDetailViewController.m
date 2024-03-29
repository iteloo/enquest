//
//  QuestDetailViewController.m
//  enQuest
//
//  Created by Leo on 04/09/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import "QuestDetailViewController.h"
#import "Quest.h"
#import "Game.h"
#import "CoreDataManager.h"
#import "UserManager.h"
#import "User.h"

@interface QuestDetailViewController ()

@end

@implementation QuestDetailViewController

@synthesize quest;
@synthesize playButton;

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
    [self.playButton setTitle:@"Already playing" forState:UIControlStateDisabled];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // disable button if already playing (label will be set)
    if ([[UserManager sharedManager].currentUser.games intersectsSet:self.quest.games]) {
        self.playButton.enabled = NO;
        self.playButton.alpha = DisabledButtonAlpha;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)play:(id)sender {
    
    // disable button
    self.playButton.enabled = NO;
    self.playButton.alpha = DisabledButtonAlpha;
    
    // create new game object
    NSManagedObjectContext *context = [CoreDataManager sharedManager].dump;
    Game *newGame = [[Game alloc] initIntoManagedObjectContext:context];
    newGame.quest = self.quest;
    newGame.player = [UserManager sharedManager].currentUser;
    
    //save
    [context saveOnSuccess:^{
        NSLog(@"New game created");
        
        // re-enable button
        self.playButton.enabled = YES;
        self.playButton.alpha = 1.0;
        
        // exit detail view
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } onFailure:^(NSError *error) {
        NSLog(@"Error creating game: %@", error);
        
        [context deleteObject:newGame];
        
        // re-enable button
        self.playButton.enabled = YES;
        self.playButton.alpha = 1.0;
        
        // present alert
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:error.localizedDescription message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void)viewDidUnload {
    [self setPlayButton:nil];
    [super viewDidUnload];
}
@end
