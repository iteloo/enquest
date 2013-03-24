//
//  DraftEditorViewController.h
//  enQuest
//
//  Created by Leo on 03/23/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldInputViewController.h"

@class DraftQuest;

@interface DraftEditorViewController : UITableViewController <TextFieldInputViewControllerDelegate>

@property (nonatomic, strong) DraftQuest *draft;
@property (weak, nonatomic) IBOutlet UILabel *questNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *questDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *questNoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *sitesLabel;

// used to keep track of which cell is being edited
@property (weak, nonatomic) UITableViewCell *editingCell;


@end
