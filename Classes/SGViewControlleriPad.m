//
//  SGViewControlleriPad.m
//  SG
//
//  Created by Matthew Stoton on 19/08/09 for Sacina.
//  Copyright 2009 Sacina. All rights reserved.
//

#import "SGViewControlleriPad.h"

@implementation SGViewControlleriPad

@synthesize board;
@synthesize soup;
@synthesize titleView;
@synthesize titleViewH;
@synthesize date;
@synthesize word, previousWord;
@synthesize backgroundImage;
@synthesize soundFileURLRef;
@synthesize soundFileURLRef2;
@synthesize soundFileURLRef3;
@synthesize soundFileURLRef4;
@synthesize undoSound;
@synthesize clickSound;
@synthesize smallSlurpSound;
@synthesize bigSlurpSound;
//@synthesize orientation;

const NSInteger NumConsonantsiPad = 24;
const NSInteger NumVowelsiPad = 16; 
const NSInteger MinLettersForShakeiPad = 10;
const NSInteger MaxLoopsiPad = 1000; //Maximum attempts at finding an empty space to place a new letter


CGFloat DegreesToRadiansiPad(CGFloat degrees) {return degrees * M_PI / 180;};

- (void)viewDidLoad {
	
	titleView = [SGTitleLayer layer];
	titleViewH = [SGTitleLayer layer];
	board = [CALayer layer];
	soup = [CALayer layer];	
	
	soup.anchorPoint = CGPointMake(0.5, 0.5);
	soup.frame = CGRectMake(0, 0, 622, 622);
	soup.position = CGPointMake(385, 513);
	titleView.position = CGPointMake(385, 100);
	titleViewH.position = CGPointMake(760, 170);
	titleViewH.hidden = YES;
	//dictionaryString = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Dictionary" ofType:@""]];
	//wordDictionary = [[NSDictionary alloc] initWithDictionary:[self populateDictionary]];
	wordDictionary = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dict" ofType:@"plist"]];
	[self.view.layer addSublayer:board];
	[self.board addSublayer:titleView];
	[self.board addSublayer:titleViewH];
	[self.board addSublayer:self.soup];
	[titleViewH setOrientation:YES];
	wordView = [SGWordView layer];
	wordView.position = CGPointMake(180, 930);
	[self.board addSublayer:wordView];
	wordView.hidden = YES;
	
	self.word = [[NSString alloc] init];
	self.previousWord = [[NSString alloc] init];
	minutes = 2;
	seconds = 0;
	targetScore = 100;
	playing = NO;
	CGRect scrollViewRect = CGRectMake(185, 314, 396, 396);
    scrollerView = [[SGScrollView alloc] initWithFrame:scrollViewRect];
	scrollerView.contentSize = CGSizeMake(396, 396);
	scrollerView.showsHorizontalScrollIndicator=NO;
	[self.view addSubview:scrollerView];
	
	CFBundleRef mainBundle;
	mainBundle = CFBundleGetMainBundle ();
	soundFileURLRef  =	CFBundleCopyResourceURL (mainBundle, CFSTR ("undo"), CFSTR ("caf"), NULL);
	soundFileURLRef2  =	CFBundleCopyResourceURL (mainBundle, CFSTR ("click"), CFSTR ("caf"), NULL);
	soundFileURLRef3 =	CFBundleCopyResourceURL (mainBundle, CFSTR ("smallSlurp"), CFSTR ("caf"), NULL);
	soundFileURLRef4 =	CFBundleCopyResourceURL (mainBundle, CFSTR ("bigSlurp"), CFSTR ("caf"), NULL);
	AudioServicesCreateSystemSoundID (soundFileURLRef, &undoSound);
	AudioServicesCreateSystemSoundID (soundFileURLRef2, &clickSound);
	AudioServicesCreateSystemSoundID (soundFileURLRef3, &smallSlurpSound);
	AudioServicesCreateSystemSoundID (soundFileURLRef4, &bigSlurpSound);
	
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
	
	splashLayer = [CALayer layer];
	

	[self.board addSublayer:splashLayer];
	
	[super viewDidLoad];

}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
	if (flag == YES) {
		[splashLayer removeFromSuperlayer];
		splashLayer = nil;
	}
}

- (NSDictionary *)populateDictionary {
	NSDictionary *wordDict = [[NSDictionary alloc] init];
	NSMutableArray *wordarray = [[NSMutableArray alloc] init];
	NSString *dictString = dictionaryString;
	NSMutableArray *aArray, *bArray, *cArray, *dArray, *eArray, *fArray, *gArray, *hArray, *iArray, *jArray, *kArray, *lArray, *mArray, *nArray, *oArray, *pArray, *qArray, *rArray, *sArray, *tArray, *uArray, *vArray, *wArray, *xArray, *yArray, *zArray;
	
	aArray = [NSMutableArray array];
	bArray = [NSMutableArray array];
	cArray = [NSMutableArray array];
	dArray = [NSMutableArray array];
	eArray = [NSMutableArray array];
	fArray = [NSMutableArray array];
	gArray = [NSMutableArray array];
	hArray = [NSMutableArray array];
	iArray = [NSMutableArray array];
	jArray = [NSMutableArray array];
	kArray = [NSMutableArray array];
	lArray = [NSMutableArray array];
	mArray = [NSMutableArray array];
	nArray = [NSMutableArray array];
	oArray = [NSMutableArray array];
	pArray = [NSMutableArray array];
	qArray = [NSMutableArray array];
	rArray = [NSMutableArray array];
	sArray = [NSMutableArray array];
	tArray = [NSMutableArray array];
	uArray = [NSMutableArray array];
	vArray = [NSMutableArray array];
	wArray = [NSMutableArray array];
	xArray = [NSMutableArray array];
	yArray = [NSMutableArray array];
	zArray = [NSMutableArray array];
	
	
	wordarray = [dictString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	for (NSInteger i=0; i < [wordarray count]; i++) {
		if ([wordarray objectAtIndex:i] == @"") {
		 [wordarray removeObjectAtIndex:i];
		}
	}
	for (NSInteger i=0; i < [wordarray count]; i++) {
		if ([[wordarray objectAtIndex:i] hasPrefix:@"a"]) {
			[aArray addObject:[wordarray objectAtIndex:i]];
		} else if ([[wordarray objectAtIndex:i] hasPrefix:@"b"]) {
			[bArray addObject:[wordarray objectAtIndex:i]];
		} else if ([[wordarray objectAtIndex:i] hasPrefix:@"c"]) {
			[cArray addObject:[wordarray objectAtIndex:i]];
		} else if ([[wordarray objectAtIndex:i] hasPrefix:@"d"]) {
			[dArray addObject:[wordarray objectAtIndex:i]];
		} else if ([[wordarray objectAtIndex:i] hasPrefix:@"e"]) {
			[eArray addObject:[wordarray objectAtIndex:i]];
		} else if ([[wordarray objectAtIndex:i] hasPrefix:@"f"]) {
			[fArray addObject:[wordarray objectAtIndex:i]];
		} else if ([[wordarray objectAtIndex:i] hasPrefix:@"g"]) {
			[gArray addObject:[wordarray objectAtIndex:i]];
		} else if ([[wordarray objectAtIndex:i] hasPrefix:@"h"]) {
			[hArray addObject:[wordarray objectAtIndex:i]];
		} else if ([[wordarray objectAtIndex:i] hasPrefix:@"i"]) {
			[iArray addObject:[wordarray objectAtIndex:i]];
		} else if ([[wordarray objectAtIndex:i] hasPrefix:@"j"]) {
			[jArray addObject:[wordarray objectAtIndex:i]];
		} else if ([[wordarray objectAtIndex:i] hasPrefix:@"k"]) {
			[kArray addObject:[wordarray objectAtIndex:i]];
		} else if ([[wordarray objectAtIndex:i] hasPrefix:@"l"]) {
			[lArray addObject:[wordarray objectAtIndex:i]];
		} else if ([[wordarray objectAtIndex:i] hasPrefix:@"m"]) {
			[mArray addObject:[wordarray objectAtIndex:i]];
		} else if ([[wordarray objectAtIndex:i] hasPrefix:@"n"]) {
			[nArray addObject:[wordarray objectAtIndex:i]];
		} else if ([[wordarray objectAtIndex:i] hasPrefix:@"o"]) {
			[oArray addObject:[wordarray objectAtIndex:i]];
		} else if ([[wordarray objectAtIndex:i] hasPrefix:@"p"]) {
			[pArray addObject:[wordarray objectAtIndex:i]];
		} else if ([[wordarray objectAtIndex:i] hasPrefix:@"q"]) {
			[qArray addObject:[wordarray objectAtIndex:i]];
		} else if ([[wordarray objectAtIndex:i] hasPrefix:@"r"]) {
			[rArray addObject:[wordarray objectAtIndex:i]];
		} else if ([[wordarray objectAtIndex:i] hasPrefix:@"s"]) {
			[sArray addObject:[wordarray objectAtIndex:i]];
		} else if ([[wordarray objectAtIndex:i] hasPrefix:@"t"]) {
			[tArray addObject:[wordarray objectAtIndex:i]];
		} else if ([[wordarray objectAtIndex:i] hasPrefix:@"u"]) {
			[uArray addObject:[wordarray objectAtIndex:i]];
		} else if ([[wordarray objectAtIndex:i] hasPrefix:@"v"]) {
			[vArray addObject:[wordarray objectAtIndex:i]];
		} else if ([[wordarray objectAtIndex:i] hasPrefix:@"w"]) {
			[wArray addObject:[wordarray objectAtIndex:i]];
		} else if ([[wordarray objectAtIndex:i] hasPrefix:@"x"]) {
			[xArray addObject:[wordarray objectAtIndex:i]];
		} else if ([[wordarray objectAtIndex:i] hasPrefix:@"y"]) {
			[yArray addObject:[wordarray objectAtIndex:i]];
		} else if ([[wordarray objectAtIndex:i] hasPrefix:@"z"]) {
			[zArray addObject:[wordarray objectAtIndex:i]];
		}
	}
	wordDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:aArray, bArray, cArray, dArray, eArray, fArray, gArray, hArray, iArray, jArray, kArray, lArray, mArray, nArray, oArray, pArray, qArray, rArray, sArray, tArray, uArray, vArray, wArray, xArray, yArray, zArray, nil] forKeys:[NSArray arrayWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", nil]];
	return wordDict;
}

- (void)orientationChanged:(NSNotification *)notification {
	orientation = [UIDevice currentDevice].orientation;
	if (splashLayer != nil) {
		if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
			splashLayer.contents = [[UIImage imageNamed:@"Default-Landscape.png"] CGImage];
			splashLayer.frame = CGRectMake(0, 0, CGRectGetHeight([[UIScreen mainScreen] bounds]), CGRectGetWidth([[UIScreen mainScreen] bounds]));
		} else if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown) {
			splashLayer.contents = [[UIImage imageNamed:@"Default-Portrait.png"] CGImage];
			splashLayer.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight([[UIScreen mainScreen] bounds]));
		}
		
		
		[[UIScreen mainScreen] bounds];
		CABasicAnimation *fadeSplash=[[CABasicAnimation alloc] init];
		fadeSplash = [CABasicAnimation animationWithKeyPath:@"opacity"];
		fadeSplash.duration=0.5;
		fadeSplash.repeatCount=1;
		fadeSplash.autoreverses= NO;
		fadeSplash.delegate = self;
		fadeSplash.removedOnCompletion = NO;
		fadeSplash.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
		fadeSplash.fillMode = kCAFillModeForwards;
		fadeSplash.fromValue=[NSNumber numberWithFloat:1.0];
		fadeSplash.toValue=[NSNumber numberWithFloat:0.0];
		
		[splashLayer addAnimation:fadeSplash forKey:@"animateOpacity"];
	}
}

- (void)playClick {
	AudioServicesPlaySystemSound (self.clickSound);
}

- (void)playSlurp {
	AudioServicesPlaySystemSound (self.smallSlurpSound);
}

- (void)playUndo {
	AudioServicesPlaySystemSound (self.undoSound);
}

- (void)playBigSlurp {
	AudioServicesPlaySystemSound (self.bigSlurpSound);
}

- (IBAction)newgame { 
	[self playClick];
	starttime = [[NSDate alloc]init];
	submitwordButton.hidden = false;
	instructions.hidden = true;
	scores.hidden = true;
	resumeButton.hidden = true;
	scoresButton.hidden = true;
	newgameButton.hidden =  true;
	instructionsButton.hidden = true;
	scrollerView.hidden = true;
	resumeButton.enabled = true;
	menuButton.hidden = false;
	soup.hidden = false;
	broth.hidden = false;
	wordView.hidden = false;
	score = 0;
	stage = 0;
	completedWords = 0;
	multiplier = 0.9;
	minutes = 2;
	seconds = 0;
	targetScore = 100;
	self.previousWord = @"";
	self.word = @"";
	
	[self populateBowl];
	[self startTimer];
	playing = YES;
	
}
- (IBAction)showinstructions {
	[self playClick];
	[scrollerView clearEntries];
	for (NSInteger i=[scrollerView.subviews count]-1; i > -1; i--) {
		[[scrollerView.subviews objectAtIndex:i] removeFromSuperview];
	}
	[titleView setTitle:@"RECIPE"];
	[titleViewH setTitle:@"RECIPE"];
	[scrollerView showInstructions];
	instructions.hidden = false;
	scores.hidden = true;
	resumeButton.hidden = true;
	scoresButton.hidden = true;
	newgameButton.hidden =  true;
	broth.hidden = true;
	menuButton.hidden = false;
	instructionsButton.hidden = true;
	scrollerView.hidden = false;
	wordView.hidden = YES;
}

- (IBAction)showscores {
	[self playClick];

	[titleView setTitle:@"SCORES"];
	[titleViewH setTitle:@"SCORES"];
	[self loadScores];
	submitwordButton.hidden = true;
	instructions.hidden = true;
	scores.hidden = false;
	resumeButton.hidden = true;
	broth.hidden = true;
	scoresButton.hidden = true;
	newgameButton.hidden =  true;
	menuButton.hidden = false;
	instructionsButton.hidden = true;
	scrollerView.hidden = false;
	wordView.hidden = YES;
}

- (IBAction)showmenu {
	[self playClick];

	[titleView setTitle:@"MENU"];
	[titleViewH setTitle:@"MENU"];
	instructions.hidden = true;
	scores.hidden = true;
	scrollerView.hidden = true;
	scoresButton.hidden = false;
	newgameButton.hidden =  false;
	instructionsButton.hidden = false;
	broth.hidden = true;
	menuButton.hidden = true;
	wordView.hidden = YES;
	[timer retain];
	[timer invalidate];
	[spinner retain];
	[spinner invalidate];
	if (playing == YES) {
		soup.hidden = true;
		resumeButton.hidden = false;
		submitwordButton.hidden = true;
	}
}

- (IBAction)resume {
	[self playClick];

	submitwordButton.hidden = false;
	instructions.hidden = false;
	scores.hidden = true;
	resumeButton.hidden = true;
	scoresButton.hidden = true;
	broth.hidden = false;
	newgameButton.hidden =  true;
	instructionsButton.hidden = true;
	scrollerView.hidden = true;
	soup.hidden = false;
	wordView.hidden = NO;
	menuButton.hidden = false;
	[self startTimer];
}

- (void)generateLetters {
	vowelsArray = [[NSMutableArray alloc] init];
	consonantsArray = [[NSMutableArray alloc] init];
	NSInteger randomNumber;
	for (NSInteger i=0; i < NumConsonantsiPad; i++) {
		srandomdev();
		randomNumber = random()%20+1;
		
		switch (randomNumber) {
			case 1:
				[consonantsArray addObject:@"B"];
				break;
			case 2:
				[consonantsArray addObject:@"Z"];
				break;
			case 3:
				[consonantsArray addObject:@"C"];
				break;
			case 4:
				[consonantsArray addObject:@"D"];
				break;
			case 5:
				[consonantsArray addObject:@"F"];
				break;
			case 6:
				[consonantsArray addObject:@"G"];
				break;
			case 7:
				[consonantsArray addObject:@"H"];
				break;
			case 8:
				[consonantsArray addObject:@"J"];
				break;
			case 9:
				[consonantsArray addObject:@"K"];
				break;
			case 10:
				[consonantsArray addObject:@"L"];
				break;
			case 11:
				[consonantsArray addObject:@"M"];
				break;
			case 12:
				[consonantsArray addObject:@"N"];
				break;
			case 13:
				[consonantsArray addObject:@"P"];
				break;
			case 14:
				[consonantsArray addObject:@"Q"];
				break;
			case 15:
				[consonantsArray addObject:@"R"];
				break;
			case 16:
				[consonantsArray addObject:@"S"];
				break;
			case 17:
				[consonantsArray addObject:@"T"];
				break;
			case 18:
				[consonantsArray addObject:@"V"];
				break;
			case 19:
				[consonantsArray addObject:@"W"];
				break;
			case 20:
				[consonantsArray addObject:@"X"];
				break;
		}
		
	}
	
	for (NSInteger n=0; n < NumVowelsiPad; n++) {
		srandomdev();
		randomNumber = random()%6+1;
		switch (randomNumber) {
			case 1:
				[vowelsArray addObject:@"I"];
				break;
			case 2:
				[vowelsArray addObject:@"E"];
				break;
			case 3:
				[vowelsArray addObject:@"A"];
				break;
			case 4:
				[vowelsArray addObject:@"O"];
				break;
			case 5:
				[vowelsArray addObject:@"U"];
				break;
			case 6:
				[vowelsArray addObject:@"Y"];
				break;
		}
	}
	letterArray = [[NSMutableArray alloc] init];
	[letterArray addObjectsFromArray:vowelsArray];
	[letterArray addObjectsFromArray:consonantsArray];
	[consonantsArray release];
	[vowelsArray release];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event { 
	SGLetterLayer *touched = [SGLetterLayer layer];
	UITouch *touch = [touches anyObject];
	touched = (SGLetterLayer *)[self.soup hitTest:[touch locationInView:self.view]];
	if (touched.name == @"letter") {
		[self playSlurp];
		[self addLetterToWord:touched.letter];
		touched.hidden = YES;
		
	}
}

- (void)addLetterToWord:(NSString *)letter {
	self.word = [self.word stringByAppendingString:letter];
	[wordView setnewWord:self.word oldWord:self.previousWord];
}

- (void)clearWord {
	self.word = @"";
	[wordView setnewWord:self.word oldWord:self.previousWord];
}

- (void)clearBowl {
	while ([soup.sublayers count] > 0) {
		[[soup.sublayers objectAtIndex:0] removeFromSuperlayer];
	}
}


- (IBAction)submit {
	[self playBigSlurp];
	NSOperationQueue *queue = [[NSOperationQueue alloc] init];
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(matchWord) object:nil];
	[queue addOperation:operation];
	[operation release];
}

- (void)matchWord {
	NSString *userword = self.word;
	userword = [userword lowercaseString];
	NSNumber *returnVal = [NSNumber numberWithBool:FALSE];
	if ([userword length] > 0) {
	NSArray *letterarray = [NSArray arrayWithArray:[wordDictionary objectForKey:[userword substringWithRange:NSMakeRange(0, 1)]]];
	
	for (NSInteger i=0; i < [letterarray count]; i++) {
		if ([userword isEqualToString:[letterarray objectAtIndex:i]]) {
			returnVal = [NSNumber numberWithBool:TRUE];
			break;
		}
	}
	}
	[self performSelectorOnMainThread:@selector(matchWordResult:) withObject:(returnVal) waitUntilDone:NO];
	
}

- (void)matchWordResult:(NSNumber *)match {
	self.previousWord = [NSString stringWithFormat:@"%@",self.word];
	if ([match boolValue] == TRUE) {
		if ([self.word length] > 3) {
			score += 10;
			score += (([self.word length] - 3)*10);
		} else {
			score += 10;
		}
		completedWords += 1;

		if([soup.sublayers count] < MinLettersForShakeiPad){
			shake = TRUE;
		}else{
			shake = FALSE;
		}
		wordView.valid = YES;
		for (NSInteger i=0; i < [soup.sublayers count]; i++) {
			if ([[soup.sublayers objectAtIndex:i] isHidden]) {
				[[soup.sublayers objectAtIndex:i] removeFromSuperlayer];
			}
		}
	} else {
		score -= [self.word length];
		wordView.valid = NO;
		
		for (NSInteger i=0; i < [soup.sublayers count]; i++) {
			[[soup.sublayers objectAtIndex:i] setHidden:NO];
		}
		
	}
	[self clearWord];
	letters -= [self.word length];
	if (score >=  targetScore){
		targetScore += 100;
		stage++;
		if ((seconds + 30) > 59) {
			minutes++;
			seconds = (30 + seconds) - 60;
		} else {
			seconds = (30 + seconds);
		}
		[self clearBowl];
		[self populateBowl];
	}
	
	NSNumber *scoreWrapper = [NSNumber numberWithInteger:score];
	NSNumber *stageWrapper = [NSNumber numberWithInteger:stage];
	NSString *timeString = [NSString stringWithFormat:@"%.2d:%.2d", minutes, seconds];
	[titleView setTitleWithTime:timeString withScore:[scoreWrapper stringValue] withStage:[stageWrapper stringValue]];
	[titleViewH setTitleWithTime:timeString withScore:[scoreWrapper stringValue] withStage:[stageWrapper stringValue]];
}

- (CGPoint)pointWithinCircle {
	double mx, my, distance;
	BOOL isValid;
	NSInteger randomX, randomY;
	NSInteger maxx = soup.bounds.size.width;
	NSInteger maxy = soup.bounds.size.height;
	NSInteger maxDistanceFromCenter = 270;
	CGPoint point;
	do {
		srandomdev();
		randomX = random()%maxx+0;
		randomY = random()%maxy+0;
		point = CGPointMake(randomX, randomY);
		mx = soup.bounds.size.width / 2;
		my = soup.bounds.size.height / 2;
		distance = sqrt((point.x - mx) * (point.x - mx) + (point.y - my) * (point.y - my));
		if (distance < maxDistanceFromCenter) { //140, this is the max distance from the center a letter can be
			isValid = YES;
		} else {
			isValid = NO;
		}
	} while (isValid == NO);
	return point;
}


- (SGLetterLayer *)validPosition {
	BOOL isValid=NO;
	NSInteger loops = 0;
	SGLetterLayer *testLayer = [SGLetterLayer layer];
	SGLetterLayer *newLayer = [SGLetterLayer layer];
	do {
		NSInteger validCount = 0;
		CGPoint point = [self pointWithinCircle];
		newLayer.position = point;
			for (NSInteger i=0; i < [soup.sublayers count]; i++) {
				testLayer = [soup.sublayers objectAtIndex:i];
				
				if (CGRectIntersectsRect(testLayer.frame, newLayer.frame) == FALSE) {
					validCount += 1;
				} else if (CGRectIntersectsRect(testLayer.frame, newLayer.frame) == TRUE) {
					validCount -= 1;
				}
			}
		if (validCount == [soup.sublayers count]) {
			isValid = YES;
		} else {
			isValid = NO;
		}
		
		loops = loops + 1;
		if (loops > MaxLoopsiPad) {
			return nil;
		}
	} while (isValid == NO);
	
	return newLayer;
}

- (void)populateBowl {
	//Total number of letters in the bowl
	letters = NumConsonantsiPad + NumVowelsiPad;
	[self generateLetters];
	
	[self clearWord];
	[self clearBowl];
	
	for (NSInteger i=0; i < letters; i++) {
		SGLetterLayer *letter = [SGLetterLayer layer];
		letter = [self validPosition];
		
		[soup addSublayer:letter];
		[letter setLetterTo:[letterArray objectAtIndex:i]];
	}
	
	
	for (NSInteger t = 0; t < [soup.sublayers count]; t++) {
		NSInteger randomNumber;
		srandomdev();
		randomNumber = random()%360+0;
		//spins letters
		[[soup.sublayers objectAtIndex:t] setValue:[NSNumber numberWithFloat:DegreesToRadiansiPad(randomNumber)] forKeyPath:@"transform.rotation.z"];
	}
}

- (void)startTimer {
	NSNumber *scoreWrapper = [NSNumber numberWithInteger:score];
	NSNumber *stageWrapper = [NSNumber numberWithInteger:stage];
	NSString *timeString = [NSString stringWithFormat:@"%.2d:%.2d", minutes, seconds];
	
	[titleView setTitleWithTime:timeString withScore:[scoreWrapper stringValue] withStage:[stageWrapper stringValue]];
	[titleViewH setTitleWithTime:timeString withScore:[scoreWrapper stringValue] withStage:[stageWrapper stringValue]];
	timer = [NSTimer scheduledTimerWithTimeInterval:1.0
												 target:self
											   selector:@selector(timerFire:)
											   userInfo:nil
												repeats:YES];
	spinner = [NSTimer scheduledTimerWithTimeInterval:0.15
											 target:self
										   selector:@selector(rotateSoup:)
										   userInfo:nil
											repeats:YES];
	

}


- (void)timerFire:(NSTimer *)theTimer {
	NSNumber *scoreWrapper = [NSNumber numberWithInteger:score];
	NSNumber *stageWrapper = [NSNumber numberWithInteger:stage];
	NSString *timeString = [NSString stringWithFormat:@"%.2d:%.2d", minutes, seconds];
	if (minutes == 0 && seconds == 0) {
		[timer retain];
		[timer invalidate];
		//[self clearBowl];
		[self gameOver];
		
	} else {
		if (seconds == 0 && minutes > 0) {
			minutes -= 1;
			seconds = 59;
		} else if (seconds > 0) {
			seconds -= 1;
		} 
	}
	[titleView setTitleWithTime:timeString withScore:[scoreWrapper stringValue] withStage:[stageWrapper stringValue]];
	[titleViewH setTitleWithTime:timeString withScore:[scoreWrapper stringValue] withStage:[stageWrapper stringValue]];

}

- (void)saveScores {
	NSPropertyListFormat format;
	NSString *errorDesc;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSNumber *stageNum = [NSNumber numberWithInteger:stage];
	NSNumber *currentScoreNum = [NSNumber numberWithInteger:score];
	
	NSString *plistPath = [paths objectAtIndex:0];
	plistPath = [plistPath stringByAppendingPathComponent: @"score.plist"];
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
	NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
	if (!temp) {
		NSLog(errorDesc);
		[errorDesc release];
	}
	NSMutableArray *stageArray = [NSMutableArray arrayWithArray:[temp objectForKey:@"Stage"]];
	NSMutableArray *scoresArray = [NSMutableArray arrayWithArray:[temp objectForKey:@"Scores"]];
	[stageArray addObject:stageNum];
	[scoresArray addObject:currentScoreNum];
	
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:scoresArray, stageArray,nil] forKeys:[NSArray arrayWithObjects:@"Scores", @"Stage",nil]];
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorDesc];
    if (plistData) {
        [plistData writeToFile:plistPath atomically:YES];
    } else {
        NSLog(errorDesc);
        [errorDesc release];
    }

}

- (void)loadScores {
	NSString *textForScoreView = @"";
	NSString *errorDesc = nil;
	
	NSPropertyListFormat format;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *plistPath = [paths objectAtIndex:0];
	plistPath = [plistPath stringByAppendingPathComponent: @"score.plist"];
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
	NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
										  propertyListFromData:plistXML
										  mutabilityOption:NSPropertyListMutableContainersAndLeaves
										  format:&format errorDescription:&errorDesc];
	if (!temp) {
		NSLog(errorDesc);
		[errorDesc release];
	}
	NSMutableArray *scoresArray = [NSMutableArray arrayWithArray:[temp objectForKey:@"Scores"]];
	NSMutableArray *stageArray = [NSMutableArray arrayWithArray:[temp objectForKey:@"Stage"]];
	[scoresArray sortArrayUsingSelector:@selector(compare:) withPairedMutableArrays:stageArray,nil];
	[scrollerView clearEntries];
	for (int i=[scrollerView.subviews count]-1; i > -1; i--) {
		[[scrollerView.subviews objectAtIndex:i] removeFromSuperview];
	}
	for (NSInteger i=[scoresArray count]-1; i > -1; i--) {
		[scrollerView addScoreEntry:[scoresArray objectAtIndex:i] withStage:[stageArray objectAtIndex:i]];
	}
}

- (void)rotateSoup:(NSTimer *)thetimer {
	float randomNumber;
	float nonrandomNumber;
	CATransform3D lettertransform;
	CATransform3D trans = soup.transform;
	SGLetterLayer *letter = [SGLetterLayer layer];
	
	trans = CATransform3DRotate(trans, DegreesToRadiansiPad(0.4), 0, 0, 1);
	soup.transform = trans;
	
	srandomdev();
	
	
		for (NSInteger t = 0; t < [soup.sublayers count]; t++) {
			
			
			randomNumber = random()%9+0;
			if (randomNumber > 1) {
				randomNumber = randomNumber / 3;
			}
			
			letter = [soup.sublayers objectAtIndex:t];
			lettertransform = letter.transform;
			lettertransform = CATransform3DRotate(lettertransform, DegreesToRadiansiPad(randomNumber), 0, 0, 1);
			letter.transform = lettertransform;
		}
	
}

- (void)gameOver {
	endtime = [[NSDate alloc]init];
	gameduration = [endtime timeIntervalSinceDate:starttime];
	[starttime release];
	[self clearBowl];
	[self clearWord];
	[timer invalidate];
	[self saveScores];
	[self loadScores];
	[self showscores];
	playing = NO;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		backgroundImage.image = [UIImage imageNamed:@"backgroundVipad.png"];
		broth.image = [UIImage imageNamed:@"spoonBrothVipad.png"];
		[menuButton setImage:[UIImage imageNamed:@"menuBTNverticalipad.png"] forState:nil];
		[submitwordButton setImage:[UIImage imageNamed:@"submitBTNverticalipad.png"] forState:nil];
		
		resumeButton.frame = CGRectMake(282,211,resumeButton.frame.size.height,resumeButton.frame.size.width);
		newgameButton.frame = CGRectMake(121,337,newgameButton.frame.size.height,newgameButton.frame.size.width);
		instructionsButton.frame = CGRectMake(415,590,instructionsButton.frame.size.height,instructionsButton.frame.size.width);
		scoresButton.frame = CGRectMake(292,712,scoresButton.frame.size.height,scoresButton.frame.size.width);
		scrollerView.frame = CGRectMake(185,314,scrollerView.frame.size.height,scrollerView.frame.size.width);
		menuButton.frame = CGRectMake(636,121,menuButton.frame.size.height,menuButton.frame.size.width);
		submitwordButton.frame = CGRectMake(600,862,submitwordButton.frame.size.height,submitwordButton.frame.size.width);
		broth.frame = CGRectMake(11,826,broth.frame.size.height,broth.frame.size.width);
		titleView.hidden = NO;
		titleViewH.hidden = YES;
		wordView.position = CGPointMake(180, 930);
		soup.position = CGPointMake(385, 513);
	} else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation ==UIInterfaceOrientationLandscapeRight) {
		backgroundImage.image = [UIImage imageNamed:@"backgroundHipad.png"];
		broth.image = [UIImage imageNamed:@"spoonBrothHipad.png"];
		[menuButton setImage:[UIImage imageNamed:@"menuBTNhorizontalipad.png"] forState:nil];
		[submitwordButton setImage:[UIImage imageNamed:@"submitBTNhorizontalipad.png"] forState:nil];
		
		resumeButton.frame = CGRectMake(430,68,resumeButton.frame.size.height,resumeButton.frame.size.width);
		newgameButton.frame = CGRectMake(275,183,newgameButton.frame.size.height,newgameButton.frame.size.width);
		instructionsButton.frame = CGRectMake(600,429,instructionsButton.frame.size.height,instructionsButton.frame.size.width); 
		scoresButton.frame = CGRectMake(450,529,scoresButton.frame.size.height,scoresButton.frame.size.width);
		scrollerView.frame = CGRectMake(315,186,scrollerView.frame.size.height,scrollerView.frame.size.width);
		menuButton.frame = CGRectMake(775,640,menuButton.frame.size.height,menuButton.frame.size.width);
		submitwordButton.frame = CGRectMake(863,515,submitwordButton.frame.size.height,submitwordButton.frame.size.width);
		broth.frame = CGRectMake(55,590,broth.frame.size.height,broth.frame.size.width);
		titleView.hidden = YES;
		titleViewH.hidden = NO;
		wordView.position = CGPointMake(220, 680);
		soup.position = CGPointMake(510, 385);
	}
}


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	if (event.subtype == UIEventSubtypeMotionShake)
	{	
		if (playing) {
			[self clearWord];
			for (NSInteger i=0; i < [soup.sublayers count]; i++) {
				[[soup.sublayers objectAtIndex:i] setHidden:NO];
			}
			[self playUndo];
		}
	}
	
	if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] )
		  [super motionEnded:motion withEvent:event];
}

- (void)freezeTimer {
	[self showmenu];
}

- (void)thawTimer {
	
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (void)viewDidAppear:(BOOL)animated {
	[self becomeFirstResponder];
	
	[super viewWillAppear:animated];
}
- (void)dealloc {
	AudioServicesDisposeSystemSoundID (self.bigSlurpSound);
	AudioServicesDisposeSystemSoundID (self.smallSlurpSound);
	
	AudioServicesDisposeSystemSoundID (self.clickSound);
	AudioServicesDisposeSystemSoundID (self.undoSound);
	CFRelease (soundFileURLRef);
	CFRelease (soundFileURLRef2);
	CFRelease (soundFileURLRef3);
	CFRelease (soundFileURLRef4);
    [super dealloc];
}

@end
