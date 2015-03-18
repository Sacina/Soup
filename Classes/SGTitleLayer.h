//
//  SGTitleLayer.h
//  SG
//
//  Created by Matthew Stoton on 19/08/09 for Sacina.
//  Copyright 2009 Sacina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@interface SGTitleLayer : CALayer {
	NSString *titleText;
	NSString *subtitleText;
	NSString *time;
	NSString *score;
	NSString *stage;
	CGPoint menuPosition, scoresPosition, recipePosition, subtitlePosition;
	CGPoint timerScore, timerStage, timerTime;
	NSUInteger titlefontsize, subtitlefontsize, scorefontsize;
	BOOL horizontal;
	CALayer *scoreBadge;
	CALayer *bowlBadge;
}

@property BOOL horizontal;

- (void)setOrientation;
- (void)setTitle:(NSString *)title;
- (void)setTitleWithTime:(NSString *)thetime withScore:(NSString *)thescore;
- (void)setTitleWithTime:(NSString *)thetime withScore:(NSString *)thescore withStage:(NSString *)thestage;
//- (void)setTitle:(NSString *)title withSubtitle:(NSString *)subtitle;
//- (void)setTitleWithTime:(NSString *)thetime withScore:(NSString *)thescore withStage:(NSString *)thestage;
//- (void)drawLayerinContext:(CGContextRef)theContext;

@end
