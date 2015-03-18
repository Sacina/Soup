//
//  SGLetterLayer.m
//  SG
//
//  Created by Matthew Stoton on 19/08/09 for Sacina.
//  Copyright 2009 Sacina. All rights reserved.
//

#import "SGLetterLayer.h"


@implementation SGLetterLayer

@synthesize letter;
@synthesize directionX;
@synthesize directionY;

//CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};

- (id)init {
	if ([super init]) {
		self.delegate = self;
		self.anchorPoint = CGPointMake(0.5, 0.5);
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			self.frame = CGRectMake(0, 0, 75, 65);
		} else {
			self.frame = CGRectMake(0, 0, 30, 30);
		}
		self.name = @"letter";
		self.masksToBounds = YES;
		#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
				/*if ([UIScreen mainScreen].scale > 1.0) { 
					self.contentsScale = 2.0f;
				} else {
					self.contentsScale = 1.0f;
					
				}*/
		self.contentsScale = 2.0f;
		#endif
		
		//self.backgroundColor = [[UIColor blueColor] CGColor];
		letter = @"A";
		[self setNeedsDisplay];
		[self displayIfNeeded];
	}
	return self;
}


- (void)setLetterTo:(NSString *)theLetter {
	letter = theLetter;
	[self setNeedsDisplay];
	[self displayIfNeeded];
}

- (void)drawInContext:(CGContextRef)theContext {
	NSUInteger fontsize;
	CGPoint letterPosition;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		fontsize = 80;
		letterPosition = CGPointMake(1, 59);
	} else {
		fontsize = 30;
		letterPosition = CGPointMake(1, 24);
	}
	CGColorSpaceRef myColorSpace = CGColorSpaceCreateDeviceRGB();
	float myColorValues[] = {0, 0, 0, .7};
	CGColorRef myColor = CGColorCreate (myColorSpace, myColorValues);
	CGContextSetFillColorWithColor(theContext, myColor);
	CGContextSelectFont (theContext, "ArialRoundedMTBold", fontsize, kCGEncodingMacRoman);
	CGContextSetShadowWithColor(theContext, CGSizeMake (0, 0), 3.0, myColor);
	CGContextSetTextDrawingMode (theContext, kCGTextFill); // 5
	CGContextSetRGBFillColor (theContext, 1.0, .8, .2, 1.0);
	CGAffineTransform xform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
	CGContextSetTextMatrix(theContext, xform);
	CGContextShowTextAtPoint (theContext, letterPosition.x, letterPosition.y, [letter UTF8String], [letter length]);
	CFRelease(myColorSpace);
	CFRelease(myColor);
}

@end
