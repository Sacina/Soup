//
//  SGViewControlleriPad.h
//  SG
//
//  Created by Matthew Stoton on 19/08/09 for Sacina.
//  Copyright 2009 Sacina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreFoundation/CFStringTokenizer.h>
#import <CoreFoundation/CFString.h>
#import "SGLetterLayer.h"
#import "SGTitleLayer.h"
#import "SGWordView.h"
#import "NSMutableArray-MultipleSort.h"
#import "SGScrollView.h"
#include <AudioToolbox/AudioToolbox.h>

@interface SGViewControlleriPad : UIViewController {
	IBOutlet UIButton *resumeButton;
	IBOutlet UIButton *newgameButton;
	IBOutlet UIButton *instructionsButton;
	IBOutlet UIButton *scoresButton;
	IBOutlet UIButton *menuButton;
	IBOutlet UILabel *instructions;
	IBOutlet UILabel *scores;
	//IBOutlet UILabel *word;
	IBOutlet UIButton *submitwordButton;
	IBOutlet UIScrollView *scrollview;
	IBOutlet UIImageView *backgroundImage;
	IBOutlet UIImageView *broth;
	
	SGScrollView *scrollerView;
	
	NSString *dictionaryString;
	NSArray *dictarray;
	NSMutableArray *vowelsArray;
	NSMutableArray *consonantsArray;
	NSMutableArray *letterArray;
	NSMutableArray *layerArray;
	
	NSInteger completedWords;
	NSInteger letters;
	NSInteger score;
	NSInteger stage;
	NSInteger seconds;
	NSInteger minutes;
	NSInteger secondsDepreciation;
	NSInteger minutesDepreciation;
	NSInteger multiplier;
	NSInteger targetScore;
	CALayer *splashLayer;
	CALayer *board;
	CALayer *soup;
	SGTitleLayer *titleView;
	SGTitleLayer *titleViewH;
	SGWordView *wordView;
	
	NSString *word;
	NSString *previousWord;
	NSTimer *spinner;
	NSTimer *timer;
	NSDate *date;
	BOOL shake;
	NSDate *starttime;
	NSDate *endtime;
	NSInteger gameduration;
	UIDeviceOrientation orientation;
	NSDictionary *wordDictionary;
	
	BOOL playing;
	CFURLRef		soundFileURLRef;
	CFURLRef		soundFileURLRef2;
	CFURLRef		soundFileURLRef3;
	CFURLRef		soundFileURLRef4;
	SystemSoundID	undoSound;
	SystemSoundID	clickSound;
	SystemSoundID	smallSlurpSound;
	SystemSoundID	bigSlurpSound;
	
}

@property (retain) CALayer *board;
@property (retain) CALayer *soup;
@property (retain) SGTitleLayer *titleView;
@property (retain) SGTitleLayer *titleViewH;
@property (retain) NSDate *date;
//@property UIDeviceOrientation orientation;

@property IBOutlet UIImageView *backgroundImage;
@property (readwrite)	CFURLRef		soundFileURLRef;
@property (readwrite)	CFURLRef		soundFileURLRef2;
@property (readwrite)	CFURLRef		soundFileURLRef3;
@property (readwrite)	CFURLRef		soundFileURLRef4;
@property (readonly)	SystemSoundID	undoSound;
@property (readonly)	SystemSoundID	clickSound;
@property (readonly)	SystemSoundID	smallSlurpSound;
@property (readonly)	SystemSoundID	bigSlurpSound;
@property (copy) NSString *previousWord;
@property (copy) NSString *word;

- (IBAction)newgame;
- (IBAction)showinstructions;
- (IBAction)showscores;
- (IBAction)showmenu;
- (IBAction)resume;
- (IBAction)submit;

- (void)playClick;
- (void)playSlurp;
- (void)playUndo;
- (void)playBigSlurp;

- (void)startTimer;
- (void)timerFire:(NSTimer *)theTimer;

- (void)generateLetters;
- (void)addLetterToWord:(NSString *)letter;
- (void)clearWord;
- (void)clearBowl;
//- (void)submitWord;
- (void)populateBowl;
- (void)gameOver;
- (void)saveScores;
- (void)loadScores;
- (void)rotateSoup:(NSTimer *)thetimer;
- (void)freezeTimer;
- (void)thawTimer;

//- (BOOL)withinCircle:(CGPoint)point;
//- (BOOL)touchingLetter:(CALayer *)letter;
- (void)matchWord;
- (void)matchWordResult:(NSNumber *)match;
- (NSDictionary *)populateDictionary;

@end

