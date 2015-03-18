//
//  SGScoreView.m
//  Letter Soup
//
//  Created by Matthew Stoton on 10-09-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SGScoreViewLayer.h"


@implementation SGScoreViewLayer


- (id)init {
	if ([super init]) {
		self.delegate = self;
		self.anchorPoint = CGPointMake(0.5, 0.5);
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			//self.contents = [[UIImage imageNamed:@"title-abciPad.png"] CGImage];
		} else {
			
		}
		
		#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
				if ([UIScreen mainScreen].scale > 1.0) { 
					self.contentsScale = 2.0f;
				} else {
					self.contentsScale = 1.0f;
				}
		#endif
		[self setNeedsDisplay];
		[self displayIfNeeded];
	}
	return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawInContext:(CGContextRef)theContext {
	NSString *filler = @"last";
	//word size scaling code
	//self.backgroundColor = [[UIColor blueColor] CGColor];
	
	
	
	CGColorSpaceRef myColorSpace = CGColorSpaceCreateDeviceRGB();
	float myColorValues[] = {0, 0, 0, .7};
	CGColorRef myColor = CGColorCreate (myColorSpace, myColorValues);
	CGContextSetFillColorWithColor(theContext, myColor);
	CGContextSetShadowWithColor(theContext, CGSizeMake (0, 0), 3.0, myColor);
	CGContextSetTextDrawingMode (theContext, kCGTextFill); // 5
	CGContextSetRGBFillColor (theContext, 1.0, .8, .2, 1.0);
	CGAffineTransform xform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
	CGContextSetTextMatrix(theContext, xform);
	CGContextSelectFont (theContext, "ArialRoundedMTBold", 20, kCGEncodingMacRoman);
	CGContextSetRGBFillColor (theContext, 1.0, 1.0, 1.0, 1.0);;
	CGContextShowTextAtPoint (theContext, 20, 20, [filler UTF8String], [filler length]);
	CFRelease(myColorSpace);
	CFRelease(myColor);
}

- (void)dealloc {
    [super dealloc];
}


@end
