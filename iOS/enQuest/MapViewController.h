//
//  MapViewController.h
//  enQuest
//
//  Created by Leo on 03/21/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;

- (IBAction)createDraftSite:(id)sender;

@end
