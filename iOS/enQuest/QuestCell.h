//
//  QuestCell.h
//  enQuest
//
//  Created by Leo on 03/27/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HighlightingTextView.h"

@interface QuestCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *questNameLabel;
@property (nonatomic, weak) IBOutlet HighlightingTextView *questDescriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel *metaDataLabel;

@end
