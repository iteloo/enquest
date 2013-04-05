//
//  RootViewController.m
//  enQuest
//
//  Created by Leo on 03/15/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import "RootViewController.h"
#import "LoginViewController.h"
#import "StackMob.h"
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
    UserManager *userManager = [UserManager sharedManager];
    if (!userManager.currentUser) {
        if (userManager.currentUsername) {
            // present wait screen
            [self performSegueWithIdentifier:@"WaitScreen" sender:self];
            
            // login
            NSString *username = userManager.currentUsername;
            NSString *password = userManager.currentPassword;
            
            SMClient *client = [SMClient defaultClient];
            [client loginWithUsername:username password:password onSuccess:^(NSDictionary *results) {
                
                NSLog(@"Login Success %@ with results:", results);
                
                NSFetchRequest *userFetch = [[NSFetchRequest alloc] initWithEntityName:@"User"];
                [userFetch setPredicate:[NSPredicate predicateWithFormat:@"username == %@", [results objectForKey:@"username"]]];
                NSManagedObjectContext *context = [CoreDataManager sharedManager].dump;
                [context executeFetchRequest:userFetch onSuccess:^(NSArray *results) {
                    User *user = [results lastObject];
                    [[UserManager sharedManager] setCurrentUser:user password:password];
                    
                    // dismiss wait screen
                    [self.waitScreen dismissViewControllerAnimated:YES completion:nil];
                    
                } onFailure:^(NSError *error) {
                    /** handle this **/
                    NSLog(@"Error fetching user object: %@", error);
                }];
                
            } onFailure:^(NSError *error) {
                
                NSLog(@"Login Failed: %@",error);
                
                // dismiss wait screen
                [self.waitScreen dismissViewControllerAnimated:YES completion:nil];
                
                // display login screen
                [self displayLoginScreen];
                
                // display alert
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login was unsuccessful." message:[error.userInfo objectForKey:@"error_description"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }];
            
        }
        else
        {
            NSLog(@"...Cannot retrieve login info.");
            [self displayLoginScreen];
        }
        
    }
}

- (void)handleLogout
{
    [self displayLoginScreen];
}

- (void)switchToViewControllerWithTag:(NSInteger)tag
{
    self.selectedIndex = tag;
}

- (void)displayLoginScreen
{
    NSLog(@"...displayLoginScreen");
    [self performSegueWithIdentifier:@"LoginScreen" sender:self];
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
