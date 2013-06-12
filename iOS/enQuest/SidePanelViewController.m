//
//  SidePanelViewController.m
//  enQuest
//
//  Created by Leo on 03/26/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import "SidePanelViewController.h"

@interface SidePanelViewController ()

@end

@implementation SidePanelViewController

-(void) awakeFromNib
{
    [self setLeftPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"leftViewController"]];
    [self setCenterPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"centerViewController"]];
    //[self setRightPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"]];
    //self.panningLimitedToTopViewController = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
