//
//  TextFieldInputViewController.h
//  enQuest
//
//  Created by Leo on 03/23/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextFieldInputViewController;

@protocol TextFieldInputViewControllerDelegate <NSObject>
@optional

-(void)textFieldInputViewController:(TextFieldInputViewController*)controller didFinishEditingText:(NSString*)text;

@end

@interface TextFieldInputViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) NSString *initialText;
@property (weak, nonatomic) IBOutlet id<TextFieldInputViewControllerDelegate> delegate;

@end