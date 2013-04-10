//
//  QuestDetailViewController.h
//  enQuest
//
//  Created by Leo on 04/09/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Quest;

@interface QuestDetailViewController : UITableViewController

@property (nonatomic, strong) Quest *quest;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

- (IBAction)play:(id)sender;

@end
