//
//  MapViewController.m
//  enQuest
//
//  Created by Leo on 03/21/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import "MapViewController.h"
#import "QuestManager.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize mapView;
@synthesize toolbar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // add user tracking bar button
    MKUserTrackingBarButtonItem *trackingItem = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.toolbar.items ];
    [items insertObject:trackingItem atIndex:0];
    [self.toolbar setItems:items animated:NO];
}

/** tmp: choose quest to add to **/
- (IBAction)createDraftSite:(id)sender
{
    QuestManager *qm = [QuestManager sharedManager];
    /** add in GUI support for selecting radius **/
    MKCircle *overlay = [MKCircle circleWithCenterCoordinate:mapView.userLocation.coordinate radius:100.0];
    /** add in identifier **/
    [qm registerRegionWithCircularOverlay:overlay andIdentifier:@"garbage"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
