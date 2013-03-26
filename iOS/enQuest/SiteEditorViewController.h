//
//  SiteEditorViewController.h
//  enQuest
//
//  Created by Leo on 03/25/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldInputViewController.h"

@class DraftSite;

@interface SiteEditorViewController : UITableViewController <MKMapViewDelegate, TextFieldInputViewControllerDelegate>

@property (strong, nonatomic) DraftSite *site;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *siteNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dialogueLabel;
@property (weak, nonatomic) IBOutlet UILabel *coordinateLabel;
@property (weak, nonatomic) IBOutlet UILabel *radiusLabel;
@property (strong, nonatomic) UITableViewCell *editingCell;

@end
