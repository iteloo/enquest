//
//  TextFieldInputViewController.m
//  enQuest
//
//  Created by Leo on 03/23/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import "TextFieldInputViewController.h"

@interface TextFieldInputViewController ()

@end

@implementation TextFieldInputViewController

@synthesize textField;
@synthesize initialText;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.textField becomeFirstResponder];
    self.textField.text = self.initialText;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.delegate respondsToSelector:@selector(textFieldInputViewController:didFinishEditingText:)]) {
        [self.delegate textFieldInputViewController:self didFinishEditingText:self.textField.text];
    }
}

- (void)viewDidUnload {
    [self setTextField:nil];
    [super viewDidUnload];
}
@end
