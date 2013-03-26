//
//  SettingsViewController.m
//  enQuest
//
//  Created by Leo on 03/14/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import "SettingsViewController.h"
#import "StackMob.h"
#import "UserManager.h"
#import "RootViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize loginStatus;
@synthesize logoutButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateLoginField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLoginField) name:LoginNotification object:nil];
}

- (void)updateLoginField
{
    NSString *username = [UserManager sharedManager].currentUsername;
    self.loginStatus.text = [NSString stringWithFormat:@"Logged in as %@.", username];
}

- (IBAction)logout:(id)sender
{
    [[SMClient defaultClient] logoutOnSuccess:^(NSDictionary *result) {
        [UserManager sharedManager].currentUser = nil;
        NSLog(@"Success, you are logged out");
        /* re-enable logout button */
        logoutButton.enabled = YES;
        logoutButton.alpha = 1.0;
        
        // reset login status label (for safety; not technically needed since login page will block everything)
        self.loginStatus.text = @"You are not logged in.";
        
        // present login screen again
        /** perhaps move to notification **/
        RootViewController *rootViewController = (RootViewController*)[UIApplication sharedApplication].delegate.window.rootViewController;
        [rootViewController displayLoginScreen];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LogoutNotification object:nil];
        
    } onFailure:^(NSError *error) {
        NSLog(@"Logout Fail: %@",error);
        /** present some kind of alert **/
        /** need to wait for better error handling objects **/
        
        /* re-enable logout button */
        logoutButton.enabled = YES;
        logoutButton.alpha = 1.0;
    }];
    
    /* disable logout button */
    logoutButton.enabled = NO;
    logoutButton.alpha = DisabledButtonAlpha;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
