//
//  MenuCell.m
//  enQuest
//
//  Created by Leo on 03/27/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        ((UIImageView*)self.backgroundView).image = [UIImage imageNamed:@"cell_bg.png"];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
