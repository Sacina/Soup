//
//  SGWordView.m
//  SG
//
//  Created by Matthew Stoton on 19/08/09 for Sacina.
//  Copyright 2009 Sacina. All rights reserved.
//

#import "SGWordView.h"


@implementation SGWordView
@synthesize valid;

- (id)init {
	if ([super init]) {
		
		self.delegate = self;
		self.anchorPoint = CGPointMake(0.5, 0.5);

		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			self.frame = CGRectMake(0, 407, 270, 83);
		} else {
			self.frame = CGRectMake(0, 414, 262, 183);
		}
	#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([UIScreen mainScreen].scale > 1.0) { 
			self.contentsScale = 2.0f;
		} else {
			self.contentsScale = 1.0f;
		}
	#endif
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			
			fontsize = 60;
			midfontsize = 24;
			smallfontsize = 20;
			originalfontsize = fontsize;
			midoriginalfontsize = midfontsize;
		} else {
			
			fontsize = 36;
			midfontsize = 18;
			smallfontsize = 14;
			originalfontsize = fontsize;
			midoriginalfontsize = midfontsize;
		}
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			wordPosition = CGPointMake(18, 52);
			fillerPosition = CGPointMake(20, 78);
			previouswordPosition = CGPointMake(60, 78);
		} else {
			wordPosition = CGPointMake(18, 35);
			fillerPosition = CGPointMake(20, 53);
			previouswordPosition = CGPointMake(48, 53);
		}
		valid = YES;
		word = @"";
		previousWord = @"";
		
		[self setNeedsDisplay];
		[self displayIfNeeded];
	}
	return self;
}

- (void)setnewWord:(NSString *)newWord oldWord:(NSString *)oldWord {
	word = newWord;
	previousWord = oldWord;

	[self setNeedsDisplay];
	[self displayIfNeeded];
}

- (void)drawInContext:(CGContextRef)theContext {
	NSString *filler = @"last";
	
	if ([word length] > 4) {
		NSInteger trim = fontsize * 0.13;
		fontsize = fontsize - trim;
	} else {
		fontsize = originalfontsize;
	}
	if ([previousWord length] > 8) {
		NSInteger trim = [previousWord length] / 1.5;
		midfontsize = midfontsize - trim;
	} else {
		midfontsize = midoriginalfontsize;
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
	CGContextShowTextAtPoint (theContext, wordPosition.x, wordPosition.y, [word UTF8String], [word length]);
	CGContextSelectFont (theContext, "ArialRoundedMTBold", smallfontsize, kCGEncodingMacRoman);
	CGContextSetRGBFillColor (theContext, 1.0, 1.0, 1.0, 1.0);;
	CGContextShowTextAtPoint (theContext, fillerPosition.x, fillerPosition.y, [filler UTF8String], [filler length]);
	CGContextSelectFont (theContext, "ArialRoundedMTBold", midfontsize, kCGEncodingMacRoman);
	if (self.valid == YES) {
		CGContextSetRGBFillColor (theContext, 1.0, .8, .2, 1.0);
	} else  {
		CGContextSetRGBFillColor (theContext, 1.0, .0, .0, 1.0);
	}
	CGContextShowTextAtPoint (theContext, previouswordPosition.x, previouswordPosition.y, [previousWord UTF8String], [previousWord length]);
	
	CFRelease(myColorSpace);
	CFRelease(myColor);
}

@end
