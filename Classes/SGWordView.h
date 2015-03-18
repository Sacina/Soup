//
//  SGWordView.h
//  SG
//
//  Created by Matthew Stoton on 19/08/09 for Sacina.
//  Copyright 2009 Sacina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@interface SGWordView : CALayer {
	NSString *word;
	NSString *previousWord;
	BOOL valid;
	NSUInteger fontsize;
	NSUInteger originalfontsize;
	NSUInteger midoriginalfontsize;
	NSUInteger midfontsize;
	NSUInteger smallfontsize;
	CGPoint wordPosition, fillerPosition, previouswordPosition;
}

//@property (retain) NSString *word;
//@property (copy) NSString *previousWord;
@property BOOL valid;

- (void)setnewWord:(NSString *)newWord oldWord:(NSString *)oldWord;

@end
