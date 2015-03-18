//
//  SGAppDelegate.m
//  SG
//
//  Created by Matthew Stoton on 19/08/09 for Sacina.
//  Copyright 2009 Sacina. All rights reserved.
//

#import "SGAppDelegate.h"
#import "SGViewController.h"
#import "SGViewControlleriPad.h"

@implementation SGAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize viewControlleriPad;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		viewControlleriPad = [[SGViewControlleriPad alloc] initWithNibName:@"SGViewControlleriPad" bundle:nil];
		[window addSubview:viewControlleriPad.view];
	} else {
		viewController = [[SGViewController alloc] initWithNibName:@"SGViewController" bundle:nil];
		[window addSubview:viewController.view];
	}
    
    [window makeKeyAndVisible];
	
	

}

- (void)applicationWillResignActive:(UIApplication *)application {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		[viewControlleriPad freezeTimer];
	} else {
		[viewController freezeTimer];
	}
}
//This may need a 4.0+ flag, see SGTitleLayer line 82
- (void)applicationWillEnterForeground:(UIApplication *)application {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		[viewControlleriPad thawTimer];
	} else {
		[viewController thawTimer];
	}
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
