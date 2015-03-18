//
//  SGScoreView.h
//  Letter Soup
//
//  Created by Matthew Stoton on 10-09-23.
//  Copyright 2010 Sacina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShadowedUILabel.h"
#import "ShadowedUITextView.h"

@interface SGScrollView : UIScrollView <UIScrollViewDelegate> {
	NSInteger numberOfEntries;
	NSInteger rowSpace;
	NSInteger columnSpace;
	NSInteger leftPadding;
	
	UIImage *column1Image;
	UIImage *column2Image;
	
	CGSize *label1Size;
	CGSize *label2Size;
}

- (void)addScoreEntry:(NSNumber *)score withStage:(NSNumber *)stage;
- (void)clearEntries;
- (void)showInstructions;

@end
