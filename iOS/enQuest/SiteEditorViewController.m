//
//  SiteEditorViewController.m
//  enQuest
//
//  Created by Leo on 03/25/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import "SiteEditorViewController.h"
#import "DraftSite.h"
#import "StackMob.h"
#import "CoreDataManager.h"
#import "TextFieldInputViewController.h"

@interface SiteEditorViewController ()

@end

@implementation SiteEditorViewController

@synthesize site;
@synthesize mapView;
@synthesize siteNameLabel;
@synthesize dialogueLabel;
@synthesize coordinateLabel;
@synthesize radiusLabel;
@synthesize editingCell;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateViewUsingData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewCell *senderCell = sender;
    self.editingCell = senderCell;
    TextFieldInputViewController *controller = segue.destinationViewController;
    controller.delegate = self;
    controller.initialText = senderCell.detailTextLabel.text;
}

- (void)updateViewUsingData;
{
    self.siteNameLabel.text = self.site.name;
    self.dialogueLabel.text = self.site.dialogue;
    SMGeoPoint *location = [NSKeyedUnarchiver unarchiveObjectWithData:self.site.location];
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([location.latitude floatValue], [location.longitude floatValue]);
    self.coordinateLabel.text = [NSString stringWithFormat:@"%.6f\n%.6f", coord.latitude, coord.longitude];
    self.radiusLabel.text = [NSString stringWithFormat:@"%@ m", [self.site.radius stringValue]];
    
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:coord radius:[self.site.radius floatValue]];
    [self.mapView addOverlay:circle];
    [self.mapView setVisibleMapRect:circle.boundingMapRect edgePadding:UIEdgeInsetsMake(5, 5, 5, 5) animated:NO];
}

- (void)saveData
{
    /** save all data except for sites **/
    self.site.name = self.siteNameLabel.text;
    self.site.dialogue = self.dialogueLabel.text;
    //self.site.radius = self.radiusLabel.text;
    
    //save
    NSManagedObjectContext *context = [CoreDataManager sharedManager].dump;
    [context saveOnSuccess:^{
        NSLog(@"draft site saved");
    } onFailure:^(NSError *error) {
        /* present alert */
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:error.localizedDescription message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldInputViewController:(TextFieldInputViewController *)controller didFinishEditingText:(NSString *)text
{
    self.editingCell.detailTextLabel.text = text;
    self.editingCell = nil;
    [self saveData];
}

- (MKOverlayView *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay
{
    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
    circleView.strokeColor = [UIColor redColor];
    circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
    return circleView;
}

@end
