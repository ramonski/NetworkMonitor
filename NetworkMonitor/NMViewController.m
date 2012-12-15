//
//  NMViewController.m
//  NetworkMonitor
//
//  Created by Ramon Bartl on 15.12.12.
//  Copyright (c) 2012 Ramon Bartl. All rights reserved.
//

#import "NMViewController.h"

#define REMOTEHOST @"www.brk.de"

@interface NMViewController ()

@end

@implementation NMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    summaryLabel.hidden = YES;
    
    // 1. Synchronous reachability
    //    Reachability *r = [Reachability reachabilityForInternetConnection];
    //    NetworkStatus status = [r currentReachabilityStatus];
    //    UIAlertView *alert = [[UIAlertView alloc]
    //                          initWithTitle:@"Reachability"
    //                          message:[self stringFromStatus:status]
    //                          delegate:nil
    //                          cancelButtonTitle:@"OK"
    //                          otherButtonTitles:nil];
    //    [alert show];
    
    // 2. Asynchronous reachability
    // Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
    // method "reachabilityChanged" will be called.
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    //Change the host name here to change the server your monitoring
    remoteHostLabel.text = [NSString stringWithFormat: @"Remote Host: %@", REMOTEHOST];
    hostReach = [Reachability reachabilityWithHostName: REMOTEHOST];
	[hostReach startNotifier];
    
    internetReach = [Reachability reachabilityForInternetConnection];
	[internetReach startNotifier];
	[self updateInterfaceWithReachability: internetReach];
    
    wifiReach = [Reachability reachabilityForLocalWiFi];
	[wifiReach startNotifier];
	[self updateInterfaceWithReachability: wifiReach];
    
}

- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    if(curReach == hostReach)
	{
		[self configureTextField: remoteHostStatusField imageView: remoteHostIcon reachability: curReach];
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        BOOL connectionRequired= [curReach connectionRequired];
        
        summaryLabel.hidden = (netStatus != ReachableViaWWAN);
        NSString* baseLabel=  @"";
        if(connectionRequired)
        {
            baseLabel=  @"Cellular data network is available.\n  Internet traffic will be routed through it after a connection is established.";
        }
        else
        {
            baseLabel=  @"Cellular data network is active.\n  Internet traffic will be routed through it.";
        }
        summaryLabel.text= baseLabel;
    }
	if(curReach == internetReach)
	{
		[self configureTextField: internetConnectionStatusField imageView: internetConnectionIcon reachability: curReach];
	}
	if(curReach == wifiReach)
	{
		[self configureTextField: localWiFiConnectionStatusField imageView: localWiFiConnectionIcon reachability: curReach];
	}
	
}

- (void) configureTextField: (UITextField*) textField imageView: (UIImageView*) imageView reachability: (Reachability*) curReach
{
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    BOOL connectionRequired= [curReach connectionRequired];
    NSString* statusString= @"";
    switch (netStatus)
    {
        case NotReachable:
        {
            statusString = @"Access Not Available";
            imageView.image = [UIImage imageNamed: @"stop-32.png"] ;
            //Minor interface detail- connectionRequired may return yes, even when the host is unreachable.  We cover that up here...
            connectionRequired= NO;
            break;
        }
            
        case ReachableViaWWAN:
        {
            statusString = @"Reachable WWAN";
            imageView.image = [UIImage imageNamed: @"WWAN5.png"];
            break;
        }
        case ReachableViaWiFi:
        {
            statusString= @"Reachable WiFi";
            imageView.image = [UIImage imageNamed: @"Airport.png"];
            break;
        }
    }
    if(connectionRequired)
    {
        statusString= [NSString stringWithFormat: @"%@, Connection Required", statusString];
    }
    textField.text= statusString;
}


- (void)reachabilityChanged:(NSNotification *)notification
{
    Reachability *reach = [notification object];
    if([reach isKindOfClass:[Reachability class]])
    {
        NetworkStatus status = [reach currentReachabilityStatus];
        NSLog(@"reachabilityChanged: status=%@", [self stringFromStatus:status]);
        [self updateInterfaceWithReachability: reach];
    }
}

- (NSString *)stringFromStatus:(NetworkStatus)status
{
    NSString *string;
    
    switch (status) {
        case NotReachable:
            string = @"Not Reachable";
            break;
        case ReachableViaWiFi:
            string = @"Reachable via WiFi";
            break;
        case ReachableViaWWAN:
            string = @"Reachable via WWAN";
            break;
        default:
            string = @"Unknown";
            break;
    }
    return string;
}


@end