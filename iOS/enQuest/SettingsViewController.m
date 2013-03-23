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
}

- (void)updateLoginField
{
    /**if (manager.status == LoggedIn) {
        self.loginStatus.text = [NSString stringWithFormat:@"Logged in as %@.", manager.username];
    } else {
        self.loginStatus.text = nil;
    }**/
}

- (IBAction)logout:(id)sender
{
    [[SMClient defaultClient] logoutOnSuccess:^(NSDictionary *result) {
        [UserManager sharedManager].currentUser = nil;
        NSLog(@"Success, you are logged out");
        /* re-enable logout button */
        logoutButton.enabled = YES;
        logoutButton.alpha = 1.0;
        
        // present login screen again
        /** perhaps move to notification **/
        RootViewController *rootViewController = (RootViewController*)[UIApplication sharedApplication].delegate.window.rootViewController;
        [rootViewController displayLoginScreen];
        
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
