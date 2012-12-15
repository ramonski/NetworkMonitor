//
//  NMAppDelegate.h
//  NetworkMonitor
//
//  Created by Ramon Bartl on 15.12.12.
//  Copyright (c) 2012 Ramon Bartl. All rights reserved.
//

#import <UIKit/UIKit.h>


@class NMViewController;

@interface NMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NMViewController *viewController;

@end