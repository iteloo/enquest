//
//  SidePanelViewController.h
//  enQuest
//
//  Created by Leo on 03/26/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import "JASidePanelController.h"

@interface SidePanelViewController : JASidePanelController
{
    IBOutlet UIViewController *leftPanel;
    IBOutlet UIViewController *centerPanel;
    IBOutlet UIViewController *rightPanel;
}

@end
