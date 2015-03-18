//
//  SGTitleLayer.m
//  SG
//
//  Created by Matthew Stoton on 19/08/09 for Sacina.
//  Copyright 2009 Sacina. All rights reserved.
//

#import "SGTitleLayer.h"


@implementation SGTitleLayer
@synthesize horizontal;

- (id)init {
	if ([super init]) {
		self.delegate = self;
		self.anchorPoint = CGPointMake(0.5, 0.5);
		self.horizontal = NO;
		bowlBadge = [CALayer layer];
		scoreBadge = [CALayer layer];
		bowlBadge.hidden = YES;		
		scoreBadge.hidden = YES;
		bowlBadge.anchorPoint = CGPointMake(0.5, 0.5);
		scoreBadge.anchorPoint = CGPointMake(0.5, 0.5);
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			self.frame = CGRectMake(0, 0, 520, 300);
			titlefontsize = 60;
			subtitlefontsize = 25;
			scorefontsize = 45;

			menuPosition = CGPointMake(200, 100);
			scoresPosition = CGPointMake(183, 100);
			recipePosition = CGPointMake(200, 98);
			subtitlePosition = CGPointMake(220, 128);
			timerStage = CGPointMake(102, 100);
			timerScore = CGPointMake(202, 100);
			timerTime = CGPointMake(372, 100);
			
			bowlBadge.frame = CGRectMake(50, 68, 38, 45);
			scoreBadge.frame = CGRectMake(150, 85, 38, 48);
			bowlBadge.contents = [[UIImage imageNamed:@"title-bowliPad.png"] CGImage];
			scoreBadge.contents = [[UIImage imageNamed:@"title-abciPad.png"] CGImage];
			bowlBadge.contentsGravity = kCAGravityCenter;
			scoreBadge.contentsGravity = kCAGravityCenter;
			
		} else {
			self.frame = CGRectMake(30, -20, 250, 100);
			titlefontsize = 40;
			subtitlefontsize = 13;
			scorefontsize = 30;
			
			menuPosition = CGPointMake(90, 42);
			scoresPosition = CGPointMake(75, 42);
			recipePosition = CGPointMake(85, 37);
			subtitlePosition = CGPointMake(105, 50);
			timerStage = CGPointMake(32, 40);
			timerScore = CGPointMake(90, 39);
			timerTime = CGPointMake(177, 39);
			
			bowlBadge.frame = CGRectMake(8, 21, 19, 23);
			scoreBadge.frame = CGRectMake(65, 28, 21, 24);
			bowlBadge.contents = [[UIImage imageNamed:@"title-bowl.png"] CGImage];
			scoreBadge.contents = [[UIImage imageNamed:@"title-abc.png"] CGImage];
		}
		[self addSublayer:bowlBadge];
		[self addSublayer:scoreBadge];
			#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
			if ([UIScreen mainScreen].scale > 1.0) { 
				self.contentsScale = 2.0f;
			} else {
				self.contentsScale = 1.0f;
			}
		#endif
		
		titleText = @"MENU";
		[self setNeedsDisplay];
		[self displayIfNeeded];
	}
	return self;
}

- (void)setTitle:(NSString *)title {
	titleText = title;
	bowlBadge.hidden = YES;
	scoreBadge.hidden = YES;
	[self setNeedsDisplay];
	[self displayIfNeeded];
	//last uncommented that didnt work
}

- (void)setTitleWithTime:(NSString *)thetime withScore:(NSString *)thescore withStage:(NSString *)thestage {
	score = thescore;
	time = thetime;
	stage = thestage;
	titleText = @"TIMER";
	bowlBadge.hidden = NO;
	scoreBadge.hidden = NO;
	[self setNeedsDisplay];
	[self displayIfNeeded];
}

- (void)setOrientation:(BOOL)isHorizontal {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		if (isHorizontal == YES) {
			menuPosition = CGPointMake(360, 100);
			scoresPosition = CGPointMake(345, 100);
			recipePosition = CGPointMake(355, 100);
			subtitlePosition = CGPointMake(375, 130);
			timerScore = CGPointMake(360, 89);
			timerStage = CGPointMake(411, 145);
			timerTime = CGPointMake(419, 210);
			bowlBadge.frame = CGRectMake(347, 130, 38, 95);
			scoreBadge.frame = CGRectMake(305, 73, 38, 95);
		} else if (isHorizontal == NO) {
			menuPosition = CGPointMake(200, 100);
			scoresPosition = CGPointMake(200, 100);
			recipePosition = CGPointMake(200, 100);
			subtitlePosition = CGPointMake(205, 120);
			timerScore = CGPointMake(390, 72);
			timerStage = CGPointMake(350, 72);
			timerTime = CGPointMake(380, 120);
			bowlBadge.frame = CGRectMake(0, 0, 38, 95);
			scoreBadge.frame = CGRectMake(0, 25, 38, 98);
		}
		[self setNeedsDisplay];
		[self displayIfNeeded];
	}
}

- (void)drawInContext:(CGContextRef)theContext {
	CGContextRotateCTM(theContext, .14);
	
	if (titleText == @"MENU") {
		CGContextSelectFont (theContext, "MarkerFelt-Thin", titlefontsize, kCGEncodingMacRoman);
		CGContextSetTextDrawingMode (theContext, kCGTextFill);
		CGContextSetRGBFillColor (theContext, .56, .56, .45, 1.0);
		CGAffineTransform xform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
		CGContextSetTextMatrix(theContext, xform);
		CGContextShowTextAtPoint (theContext, menuPosition.x, menuPosition.y, [titleText UTF8String], [titleText length]);
	} else if (titleText == @"SCORES") {
		CGContextSelectFont (theContext, "MarkerFelt-Thin", titlefontsize, kCGEncodingMacRoman);
		CGContextSetTextDrawingMode (theContext, kCGTextFill);
		CGContextSetRGBFillColor (theContext, .56, .56, .45, 1.0);
		CGAffineTransform xform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
		CGContextSetTextMatrix(theContext, xform);
		CGContextShowTextAtPoint (theContext, scoresPosition.x, scoresPosition.y, [titleText UTF8String], [titleText length]);
	} else if (titleText == @"RECIPE") {
		subtitleText = @"How To Play";
		CGContextSelectFont (theContext, "MarkerFelt-Thin", titlefontsize, kCGEncodingMacRoman);
		CGContextSetTextDrawingMode (theContext, kCGTextFill);
		CGContextSetRGBFillColor (theContext, .56, .56, .45, 1.0);
		CGAffineTransform xform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
		CGContextSetTextMatrix(theContext, xform);
		CGContextShowTextAtPoint (theContext, recipePosition.x, recipePosition.y, [titleText UTF8String], [titleText length]);
		CGContextSelectFont (theContext, "MarkerFelt-Thin", subtitlefontsize, kCGEncodingMacRoman);
		CGContextShowTextAtPoint (theContext, subtitlePosition.x, subtitlePosition.y, [subtitleText UTF8String], [subtitleText length]);
	} else if (titleText == @"TIMER") {
		CGContextSelectFont (theContext, "MarkerFelt-Thin", scorefontsize, kCGEncodingMacRoman);
		CGContextSetTextDrawingMode (theContext, kCGTextFill);
		CGContextSetRGBFillColor (theContext, .56, .56, .45, 1.0);
		CGAffineTransform xform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
		CGContextSetTextMatrix(theContext, xform);
		CGContextShowTextAtPoint (theContext, timerStage.x, timerStage.y, [stage UTF8String], [stage length]);
		CGContextShowTextAtPoint (theContext, timerScore.x, timerScore.y, [score UTF8String], [score length]);
		CGContextShowTextAtPoint (theContext, timerTime.x, timerTime.y, [time UTF8String], [time length]);
	}
}

@end
