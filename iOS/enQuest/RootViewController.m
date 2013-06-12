//
//  RootViewController.m
//  enQuest
//
//  Created by Leo on 03/15/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import "RootViewController.h"
#import "LoginViewController.h"
#import "CoreDataManager.h"
#import "UserManager.h"
#import "User.h"

@interface RootViewController ()

@end

@implementation RootViewController

@synthesize waitScreen;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        waitScreen = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBar.hidden = YES;
    self.view.frame = self.view.superview.bounds;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLogout) name:LogoutNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    LoginStatus loginStatus = [UserManager sharedManager].status;
    if (loginStatus == LoggedOut) {
        [self handleLogout];
    }
}

- (void)handleLogout
{
    [self displayLoginScreen];
}

- (void)displayLoginScreen
{
    NSLog(@"...displayLoginScreen");
    [self performSegueWithIdentifier:@"LoginScreen" sender:self];
}

- (void)switchToViewControllerWithTag:(NSInteger)tag
{
    self.selectedIndex = tag;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"WaitScreen"]) {
        self.waitScreen = segue.destinationViewController;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
