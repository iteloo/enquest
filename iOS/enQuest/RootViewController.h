//
//  RootViewController.h
//  enQuest
//
//  Created by Leo on 03/15/13.
//  Copyright (c) 2013 iteloolab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITabBarController

@property (nonatomic, strong) UIViewController *waitScreen;

- (void)displayLoginScreen;
- (void)switchToViewControllerWithTag:(NSInteger)tag;

@end
