//
//  SGLetterLayer.h
//  SG
//
//  Created by Matthew Stoton on 19/08/09 for Sacina.
//  Copyright 2009 Sacina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@interface SGLetterLayer : CALayer {
	NSString *letter;
	float directionX;
	float directionY;
}

@property (retain) NSString *letter;
@property float directionX;
@property float directionY;

- (void)setLetterTo:(NSString *)letter;

@end
