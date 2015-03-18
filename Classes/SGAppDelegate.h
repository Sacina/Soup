//
//  SGAppDelegate.h
//  SG
//
//  Created by Matthew Stoton on 19/08/09 for Sacina.
//  Copyright 2009 Sacina. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SGViewControlleriPad.h"

@class SGViewController;
@class SGViewControlleriPad;

@interface SGAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SGViewController *viewController;
	SGViewControlleriPad *viewControlleriPad;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SGViewController *viewController;
@property (nonatomic, retain) IBOutlet SGViewControlleriPad *viewControlleriPad;

@end

