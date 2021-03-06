//
//  ShadowedUILabel.m
//  Letter Soup
//
//  Created by Matthew Stoton on 10-09-28.
//  Copyright 2010 Sacina. All rights reserved.
//

#import "ShadowedUILabel.h"


@implementation ShadowedUILabel


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
		self.textColor = [UIColor colorWithRed:1.0 green:0.8 blue:.2 alpha:1.0];
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			fontSize = 44;
		} else {
			fontSize = 22;
		}
		
		self.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:fontSize];
		
		
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    CGSize myShadowOffset = CGSizeMake(4, -4);
    float myColorValues[] = {0, 0, 0, .7};
	
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(myContext);
	
    CGContextSetShadow (myContext, myShadowOffset, 1);
    CGColorSpaceRef myColorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef myColor = CGColorCreate(myColorSpace, myColorValues);
	CGContextSetShadowWithColor(myContext, CGSizeMake (0, 0), 3.0, myColor);
    [super drawTextInRect:rect];
	
    CGColorRelease(myColor);
    CGColorSpaceRelease(myColorSpace); 
	
    CGContextRestoreGState(myContext);
}


- (void)dealloc {
    [super dealloc];
}


@end
