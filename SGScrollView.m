//
//  SGScoreView.m
//  Letter Soup
//
//  Created by Matthew Stoton on 10-09-23.
//  Copyright 2010 Sacina. All rights reserved.
//

#import "SGScrollView.h"


@implementation SGScrollView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		self.opaque = NO;
		self.hidden = YES;
		numberOfEntries = 0;
		
    }
    return self;
}

- (void)addScoreEntry:(NSNumber *)score withStage:(NSNumber *)stage {
	ShadowedUILabel *scoreLabel;
	ShadowedUILabel *stageLabel;
	UIImageView *scoreBadge;
	UIImageView *stageBadge;
	
	
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		leftPadding = 50;
		columnSpace = 80;
		rowSpace = 50;
		
		scoreBadge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scores-abciPad.png"]];
		stageBadge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scores-bowliPad.png"]];
		scoreBadge.frame = CGRectMake(leftPadding, (numberOfEntries * rowSpace) + 4, scoreBadge.frame.size.width, scoreBadge.frame.size.height);
		scoreLabel = [[ShadowedUILabel alloc] initWithFrame:CGRectMake((scoreBadge.frame.origin.x + scoreBadge.frame.size.width + 5), ( numberOfEntries * rowSpace), 87, 36)];
		stageBadge.frame = CGRectMake(scoreLabel.frame.origin.x + scoreLabel.frame.size.width + columnSpace, (numberOfEntries * rowSpace) + 4, stageBadge.frame.size.width, stageBadge.frame.size.height);
		stageLabel = [[ShadowedUILabel alloc] initWithFrame:CGRectMake(stageBadge.frame.origin.x + stageBadge.frame.size.width + 5, rowSpace * numberOfEntries, 46, 36)];
		
	} else {
		leftPadding = 20;
		columnSpace = 0;
		rowSpace = 26;
		
		scoreBadge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scores-abc.png"]];
		stageBadge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scores-bowl.png"]];
		scoreBadge.frame = CGRectMake(leftPadding, (numberOfEntries * rowSpace) + 4, scoreBadge.frame.size.width, scoreBadge.frame.size.height);
		scoreLabel = [[ShadowedUILabel alloc] initWithFrame:CGRectMake((scoreBadge.frame.origin.x + scoreBadge.frame.size.width + 3), rowSpace * numberOfEntries, 94, 22)];
		stageBadge.frame = CGRectMake(scoreLabel.frame.origin.x + scoreLabel.frame.size.width + columnSpace, (numberOfEntries * rowSpace) + 4, stageBadge.frame.size.width, stageBadge.frame.size.height);
		stageLabel = [[ShadowedUILabel alloc] initWithFrame:CGRectMake(stageBadge.frame.origin.x + stageBadge.frame.size.width + 3, rowSpace * numberOfEntries, 46, 22)];
	}
	
	scoreLabel.text = [score stringValue];
	stageLabel.text = [stage stringValue];
	self.contentSize = CGSizeMake(self.frame.size.width, rowSpace + (numberOfEntries * rowSpace));
	[self addSubview:scoreBadge];
	[self addSubview:scoreLabel];
	[self addSubview:stageBadge];
	[self addSubview:stageLabel];
	[scoreBadge release];
	[scoreLabel release];
	[stageBadge release];
	[stageLabel release];
	numberOfEntries++;
	NSLog(@"Scrollview subarray count: %i", [self.subviews count]);
	NSLog(@"Number of entries: %i", numberOfEntries);
}

- (void)clearEntries {
	numberOfEntries = 0;
}

- (void)showInstructions {
	CGRect instructionsRect;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		instructionsRect = CGRectMake(0, 0, 396, 396);
	} else {
		instructionsRect = CGRectMake(0, 0, 218, 218);
	}
	ShadowedUITextView *instructionsView = [[ShadowedUITextView alloc] initWithFrame:instructionsRect];
	self.showsHorizontalScrollIndicator = NO;
	self.showsVerticalScrollIndicator = NO;
	[self addSubview:instructionsView];
	[instructionsView release];
	instructionsView.textAlignment = UITextAlignmentCenter;
	instructionsView.text = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Instructions" ofType:@"txt"]];	
	[instructionsView sizeToFit];
	self.contentSize = CGSizeMake(CGRectGetWidth(instructionsView.frame), CGRectGetHeight(instructionsView.frame));
}


- (void)dealloc {
    [super dealloc];
}


@end
