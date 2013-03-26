//
//  LoginViewController.m
//  enQuest
//
//  Created by Leo on 03/13/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import "LoginViewController.h"
#import "CoreDataManager.h"
#import "StackMob.h"
#import "User.h"
#import "UserManager.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize scrollView;
@synthesize contentView;
@synthesize username_field;
@synthesize password_field;
@synthesize loginButton;
@synthesize registerButton;
@synthesize reg_username_field;
@synthesize reg_password_field;
@synthesize reg_confirm_password_field;
@synthesize reg_email_field;
@synthesize activeField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    // create gesture recognizer to dismiss keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                  initWithTarget:self
                                  action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (IBAction)login:(id)sender
{
    SMClient *client = [SMClient defaultClient];
    NSString *username = self.username_field.text;
    NSString *password = self.password_field.text;
    
    // disable button and textfields
    self.loginButton.enabled = NO;
    self.loginButton.alpha = DisabledButtonAlpha;
    self.username_field.enabled = NO;
    self.password_field.enabled = NO;
    
    [client loginWithUsername:username password:password onSuccess:^(NSDictionary *results) {
        
        NSLog(@"Login Success: %@", results);
        
        /* Uncomment the following if you are using Core Data integration and want to retrieve a managed object representation of the user object.  Store the resulting object or object ID for future use.
         
         Be sure to declare variables you are referencing in this block with the __block storage type modifier, including the managedObjectContext property.
         */
        
        NSFetchRequest *userFetch = [[NSFetchRequest alloc] initWithEntityName:@"User"];
        [userFetch setPredicate:[NSPredicate predicateWithFormat:@"username == %@", [results objectForKey:@"username"]]];
        NSManagedObjectContext *context = [CoreDataManager sharedManager].dump;
        [context executeFetchRequest:userFetch onSuccess:^(NSArray *results) {
            
            User *user = [results lastObject];
            [[UserManager sharedManager] setCurrentUser:user password:password];
            
            // dismiss login screen
            [self dismissViewControllerAnimated:YES completion:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:LoginNotification object:nil];
            
        } onFailure:^(NSError *error) {
            NSLog(@"Error fetching user object: %@", error);
        }];
        
    } onFailure:^(NSError *error) {
        
        NSLog(@"Login Failed: %@",error);
        
        // re-enable button and textfields
        self.loginButton.enabled = YES;
        self.loginButton.alpha = 1.0;
        self.username_field.enabled = YES;
        self.password_field.enabled = YES;
        
        // display alert
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login was unsuccessful." message:[error.userInfo objectForKey:@"error_description"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void)registerNewUser:(id)sender
{
    NSString *u = self.reg_username_field.text;
    NSString *p = self.reg_password_field.text;
    NSString *cp = self.reg_confirm_password_field.text;
    NSString *e = self.reg_email_field.text;
    
    // check that passwords agree
    if (![p isEqualToString:cp]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Passwords don't match",@"Title for alert displayed when passwords don't match.") message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    NSManagedObjectContext *context = [CoreDataManager sharedManager].dump;
    User *newUser = [[User alloc] initIntoManagedObjectContext:context];
    newUser.username = u;
    newUser.password = p;
    newUser.email = e;
    
    /* disable button */
    self.self.registerButton.enabled = NO;
    self.registerButton.alpha = DisabledButtonAlpha;
    self.reg_username_field.enabled = NO;
    self.reg_password_field.enabled = NO;
    self.reg_confirm_password_field.enabled = NO;
    self.reg_email_field.enabled = NO;
    
    [context saveOnSuccess:^{
        
        /* clear registration textfields */
        self.reg_username_field.text = @"";
        self.reg_password_field.text = @"";
        self.reg_confirm_password_field.text = @"";
        self.reg_email_field.text = @"";
        
        /* re-enable button and text field */
        self.registerButton.enabled = YES;
        self.registerButton.alpha = 1.0;
        self.reg_username_field.enabled = YES;
        self.reg_password_field.enabled = YES;
        self.reg_confirm_password_field.enabled = YES;
        self.reg_email_field.enabled = YES;
        
        /* present alert to notify success */
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Registration successful! Please login above.",@"Title for alert displayed when registration is successful.") message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    } onFailure:^(NSError *error) {
        
        NSLog(@"failed to register: %@", error);
        /*
         One optional way to handle an unsuccessful save of a managed object is to delete the object altogether from the managed object context.  For example, you probably won't try to keep saving a user object that returns a duplicate key error. If you delete a user managed object that hasn't been saved yet, you must remove the password you originally set using the removePassword: method.
         */
        
        [context deleteObject:newUser];
        [newUser removePassword];
        
        /* re-enable button and textfield */
        self.registerButton.enabled = YES;
        self.registerButton.alpha = 1.0;
        self.reg_username_field.enabled = YES;
        self.reg_password_field.enabled = YES;
        self.reg_confirm_password_field.enabled = YES;
        self.reg_email_field.enabled = YES;
        
        /* present alert */
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot register user" message:[error.userInfo objectForKey:@"error_description"]  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.username_field) {
        [self.password_field becomeFirstResponder];
    }
    else if (textField == self.password_field) {
        [textField resignFirstResponder];
        [self login:nil];
    }
    else if (textField == self.reg_username_field) {
        [self.reg_password_field becomeFirstResponder];
    }
    else if (textField == self.reg_password_field) {
        [self.reg_confirm_password_field becomeFirstResponder];
    }
    else if (textField == self.reg_confirm_password_field) {
        [self.reg_email_field becomeFirstResponder];
    }
    else if (textField == self.reg_email_field) {
        [textField resignFirstResponder];
        [self registerNewUser:nil];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
}

#pragma mark keyboard management

-(void)dismissKeyboard {
    [activeField resignFirstResponder];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGRect keyboardFrame = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGSize kbSize = [self.view convertRect:keyboardFrame fromView:self.view.window].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    CGRect visibleRect = self.scrollView.bounds;
    visibleRect.size.height -= kbSize.height;
    CGRect activeFieldRect = [activeField convertRect:activeField.bounds toView:scrollView];
    if (!CGRectContainsRect(visibleRect, activeFieldRect) ) {
        CGPoint scrollPoint = CGPointMake(0.0, activeFieldRect.origin.y + activeFieldRect.size.height/2.0-visibleRect.size.height/2.0);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    scrollView.contentInset = UIEdgeInsetsZero;
    scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
    [UIView commitAnimations];
}

- (void)viewDidUnload {
    [self setContentView:nil];
    [super viewDidUnload];
}
@end
