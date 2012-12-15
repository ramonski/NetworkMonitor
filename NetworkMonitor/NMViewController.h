//
//  NMViewController.h
//  NetworkMonitor
//
//  Created by Ramon Bartl on 15.12.12.
//  Copyright (c) 2012 Ramon Bartl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface NMViewController : UIViewController {

    IBOutlet UIView* contentView;
    IBOutlet UILabel* summaryLabel;

    IBOutlet UITextField* remoteHostLabel;
    IBOutlet UIImageView* remoteHostIcon;
    IBOutlet UITextField* remoteHostStatusField;

    IBOutlet UIImageView* internetConnectionIcon;
    IBOutlet UITextField* internetConnectionStatusField;

    IBOutlet UIImageView* localWiFiConnectionIcon;
    IBOutlet UITextField* localWiFiConnectionStatusField;

    Reachability* hostReach;
    Reachability* internetReach;
    Reachability* wifiReach;
}

- (NSString *)stringFromStatus:(NetworkStatus)status;

@end
