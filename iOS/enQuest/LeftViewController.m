//
//  LeftViewController.m
//  enQuest
//
//  Created by Leo on 03/26/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import "LeftViewController.h"
#import "UIViewController+JASidePanel.h"
#import "SidePanelViewController.h"
#import "RootViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    RootViewController *rootViewController =  (RootViewController*)self.sidePanelController.centerPanel;
    [rootViewController switchToViewControllerWithTag:cell.tag];
    [self.sidePanelController showCenterPanelAnimated:YES];
}

@end
