//
//  LoginViewController.h
//  enQuest
//
//  Created by Leo on 03/13/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>

- (IBAction)login:(id)sender;
- (IBAction)registerNewUser:(id)sender;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *username_field;
@property (strong, nonatomic) IBOutlet UITextField *password_field;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;

@property (strong, nonatomic) IBOutlet UITextField *reg_username_field;
@property (strong, nonatomic) IBOutlet UITextField *reg_password_field;
@property (strong, nonatomic) IBOutlet UITextField *reg_confirm_password_field;
@property (strong, nonatomic) IBOutlet UITextField *reg_email_field;
@property (strong, nonatomic) UITextField *activeField;

@end