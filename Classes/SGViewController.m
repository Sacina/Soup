//
//  SGViewController.m
//  SG
//
//  Created by Matthew Stoton on 19/08/09 for Sacina.
//  Copyright 2009 Sacina. All rights reserved.
//

#import "SGViewController.h"

@implementation SGViewController

@synthesize board;
@synthesize soup;
@synthesize titleView;
@synthesize date;
@synthesize word, previousWord;
@synthesize soundFileURLRef;
@synthesize soundFileURLRef2;
@synthesize soundFileURLRef3;
@synthesize soundFileURLRef4;
@synthesize undoSound;
@synthesize clickSound;
@synthesize smallSlurpSound;
@synthesize bigSlurpSound;
@synthesize achievementsDictionary;


const NSInteger NumConsonants = 24;
const NSInteger NumVowels = 16;
const NSInteger MinLettersForShake = 10;
const NSInteger MaxLoops = 1000; //Maximum attempts at finding an empty space to place a new letter


CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};

- (void)viewDidLoad {
	
	titleView = [SGTitleLayer layer];
	board = [CALayer layer];
	soup = [CALayer layer];	
	
	soup.anchorPoint = CGPointMake(0.5, 0.5);
	soup.frame = CGRectMake(160, 240, 316, 316);
	soup.position = CGPointMake(160, 240);
	
	wordDictionary = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dict" ofType:@"plist"]];
	//wordDictionary = [[NSDictionary alloc] initWithDictionary:[self populateDictionary]];
	[self.view.layer addSublayer:board];
	[self.board addSublayer:titleView];
	[self.board addSublayer:self.soup];
	
	wordView = [SGWordView layer];
	[self.board addSublayer:wordView];
	wordView.hidden = YES;
	
	self.word = [[NSString alloc] init];
	self.previousWord = [[NSString alloc] init];
	targetScore = 100;
	minutes = 2;
	seconds = 0;
	playing = NO;
	CGRect scrollViewRect = CGRectMake(53, 131, 218, 218);
    scrollerView = [[SGScrollView alloc] initWithFrame:scrollViewRect];
	scrollerView.contentSize = CGSizeMake(218, 218);
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
	
	
	splashLayer = [CALayer layer];
	splashLayer.contents = [[UIImage imageNamed:@"Default.png"] CGImage];
	splashLayer.frame = [[UIScreen mainScreen] bounds];
	[self.view.layer addSublayer:splashLayer];
	CABasicAnimation *fadeSplash=[[CABasicAnimation alloc] init];
	fadeSplash = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeSplash.duration=0.5;
	fadeSplash.repeatCount=1;
	fadeSplash.autoreverses=NO;
	fadeSplash.removedOnCompletion = NO;
	fadeSplash.delegate = self;
	fadeSplash.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
	fadeSplash.fillMode = kCAFillModeForwards;
	fadeSplash.fromValue=[NSNumber numberWithFloat:1.0];
	fadeSplash.toValue=[NSNumber numberWithFloat:0.0];
	[splashLayer addAnimation:fadeSplash forKey:@"animateOpacity"];
	//splashLayer.hidden = YES;
	
	
	achievementsDictionary = [[NSMutableDictionary alloc] init];

	[super viewDidLoad];
}

#pragma mark Game Kit
- (void) authenticateLocalPlayer
{
    [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
		if (error == nil)
		{
			[self loadAchievements];
			// Insert code here to handle a successful authentication.
		}
		else
		{
			// Your application can process the error parameter to report the error to the player.
		}
	}];
}

- (void) registerForAuthenticationNotification
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver: self
           selector:@selector(authenticationChanged)
               name:GKPlayerAuthenticationDidChangeNotificationName
             object:nil];
}

- (void) authenticationChanged
{
    if ([GKLocalPlayer localPlayer].isAuthenticated) {
        // Insert code here to handle a successful authentication.
	} else {
			// Insert code here to clean up any outstanding Game Center-related classes.
	}
}

- (void) reportScore: (int64_t) score forCategory: (NSString*) category
{
    GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];
    scoreReporter.value = score;
	
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
		if (error != nil)
		{
            // handle the reporting error
        }
    }];
}

- (void) showLeaderboard
{
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != nil)
    {
        leaderboardController.leaderboardDelegate = self;
        [self presentModalViewController: leaderboardController animated: YES];
    }
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [self dismissModalViewControllerAnimated:YES];
}


- (GKAchievement*) getAchievementForIdentifier: (NSString*) identifier
{
    GKAchievement *achievement = [achievementsDictionary objectForKey:identifier];
    if (achievement == nil)
    {
		
        achievement = [[[GKAchievement alloc] initWithIdentifier:identifier] autorelease];
        [achievementsDictionary setObject:achievement forKey:achievement.identifier];
    }
    return [[achievement retain] autorelease];
}

/*
 9:39 PM
 GKAchievement *achievement = [self getachievementforidentifier:@"whatever"]
 [dopeyAhievement reportAchievementWithCompletionHandler:^(NSError *error)
 {
 if (error != nil)
 // Retain the achievement object and try again later (not shown).
 }];
 */

- (void) loadAchievements
{
    [GKAchievement (void)loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error)
	 {
		 if (error == nil)
		 {
			 for (GKAchievement* achievement in achievements) = [NSMutableArray arrayWithArray: achievements];
			 [achievementsDictionary setObject: achievement forKey: achievement.identifier];
		 }
	 }];
}


- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
	if (flag == YES) {
		[splashLayer removeFromSuperlayer];
		[self authenticateLocalPlayer];
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
	
	//componentsSeparatedByCharactersInSet, also really slow
	wordarray = [dictString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	for (NSInteger i=0; i < [wordarray count]; i++) {
		if ([wordarray objectAtIndex:i] == @"") {
		 [wordarray removeObjectAtIndex:i];
		}
	}
	for (NSInteger i=0; i < [wordarray count]; i++) {
		if ([[wordarray objectAtIndex:i] hasPrefix:@"a"]) { //has prefix, really slow
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
	wordView.hidden = false;
	targetScore = 100;
	score = 0;
	stage = 0;
	completedWords = 0;
	multiplier = 0.9;
	minutes = 2;
	seconds = 0;
	
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
	instructions.hidden = false;
	[scrollerView showInstructions];

	scores.hidden = true;
	resumeButton.hidden = true;
	scoresButton.hidden = true;
	newgameButton.hidden =  true;
	menuButton.hidden = false;
	instructionsButton.hidden = true;
	scrollerView.hidden = false;
	wordView.hidden = YES;
}

- (IBAction)showscores {
	[self playClick];
	[titleView setTitle:@"SCORES"];
	[self loadScores];
	submitwordButton.hidden = true;
	instructions.hidden = true;
	scores.hidden = false;
	resumeButton.hidden = true;
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
	instructions.hidden = true;
	scores.hidden = true;
	scrollerView.hidden = true;
	scoresButton.hidden = false;
	newgameButton.hidden =  false;
	instructionsButton.hidden = false;
	menuButton.hidden = true;
	wordView.hidden = YES;
	[timer retain];
	[timer invalidate];
	[spinner retain];
	[spinner invalidate];
	//if (timer != nil && [timer isValid] == TRUE) {
		//[timer invalidate];
		//[timer release];
	//}
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
	for (NSInteger i=0; i < NumConsonants; i++) {
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
	
	for (NSInteger n=0; n < NumVowels; n++) {
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
	touched = (SGLetterLayer *)[self.view.layer hitTest:[touch locationInView:self.view]];
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
	
	
	NSOperationQueue *queue = [[NSOperationQueue alloc] init];
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(matchWord) object:nil];
	[queue addOperation:operation];
	[operation release];
	[self playBigSlurp];
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
		/*if ((seconds + (round([self.word length]))) > 59) {
			minutes++;
			seconds = (round([self.word length]) + seconds) - 59;
		} else {
			seconds = (round([self.word length]) + seconds);
		}*/
		
		if([soup.sublayers count] < MinLettersForShake){
			shake = TRUE;
		} else {
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
	
	if (score >=  targetScore) {
		targetScore = targetScore + 100;
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
	NSLog(@"Stage: %i, Score: %i, Target Score: %i", stage, score, targetScore);
	NSNumber *scoreWrapper = [NSNumber numberWithInteger:score];
	NSNumber *stageWrapper = [NSNumber numberWithInteger:stage];
	NSString *timeString = [NSString stringWithFormat:@"%.2d:%.2d", minutes, seconds];
	[titleView setTitleWithTime:timeString withScore:[scoreWrapper stringValue] withStage:[stageWrapper stringValue]];
}

- (CGPoint)pointWithinCircle {
	double mx, my, distance;
	BOOL isValid;
	NSInteger randomX, randomY;
	NSInteger maxx = soup.bounds.size.width;
	NSInteger maxy = soup.bounds.size.height;
	NSInteger maxDistanceFromCenter = 135;
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
		if (loops > MaxLoops) {
			return nil;
		}
	} while (isValid == NO);
	NSLog(@"Loops: %i", loops);
	return newLayer;
}
- (void)populateBowl {
	letters = NumConsonants + NumVowels;
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
		[[soup.sublayers objectAtIndex:t] setValue:[NSNumber numberWithFloat:DegreesToRadians(randomNumber)] forKeyPath:@"transform.rotation.z"];
	}
}

- (void)startTimer {
	NSNumber *scoreWrapper = [NSNumber numberWithInteger:score];
	NSNumber *stageWrapper = [NSNumber numberWithInteger:stage];
	NSString *timeString = [NSString stringWithFormat:@"%.2d:%.2d", minutes, seconds];
	
	[titleView setTitleWithTime:timeString withScore:[scoreWrapper stringValue] withStage:[stageWrapper stringValue]];
	
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
}

- (void)saveScores {
	NSPropertyListFormat format;
	NSString *errorDesc;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSNumber *stageNum = [NSNumber numberWithInteger:stage];
	NSNumber *currentScoreNum = [NSNumber numberWithInteger:score];
	//NSNumber *completedwordsNum = [NSNumber numberWithInteger:completedWords];
	//NSNumber *durationNum = [NSNumber numberWithInteger:gameduration];
	//NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc]init]autorelease];
	//[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	//NSString *currentDate = [dateFormatter stringFromDate:endtime];
	
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
	//NSMutableArray *dateArray = [NSMutableArray arrayWithArray:[temp objectForKey:@"Date"]];
	//NSMutableArray *durationArray = [NSMutableArray arrayWithArray:[temp objectForKey:@"Duration"]];
	//NSMutableArray *numberofwordsArray = [NSMutableArray arrayWithArray:[temp objectForKey:@"NumberofWords"]];
	[stageArray addObject:stageNum];
	[scoresArray addObject:currentScoreNum];
	//[dateArray addObject:currentDate];
	//[durationArray addObject:durationNum];
	//[numberofwordsArray addObject:completedwordsNum];
	
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
	//NSMutableArray *dateArray = [NSMutableArray arrayWithArray:[temp objectForKey:@"Date"]];
	//NSMutableArray *durationArray = [NSMutableArray arrayWithArray:[temp objectForKey:@"Duration"]];
	//NSMutableArray *numberofwordsArray = [NSMutableArray arrayWithArray:[temp objectForKey:@"NumberofWords"]];
	NSMutableArray *stageArray = [NSMutableArray arrayWithArray:[temp objectForKey:@"Stage"]];
	[scoresArray sortArrayUsingSelector:@selector(compare:) withPairedMutableArrays:stageArray,nil];
		[scrollerView clearEntries];
	for (NSInteger i=[scrollerView.subviews count]-1; i > -1; i--) {
				[[scrollerView.subviews objectAtIndex:i] removeFromSuperview];
	}
	NSLog(@"Scrollview2 subarray count: %i", [scrollerView.subviews count]);
		for (NSInteger i=[scoresArray count]-1; i > -1; i--) {
			[scrollerView addScoreEntry:[scoresArray objectAtIndex:i] withStage:[stageArray objectAtIndex:i]];
		}
}

- (void)rotateSoup:(NSTimer *)thetimer {
	float randomNumber;
	CATransform3D lettertransform;
	CATransform3D trans = soup.transform;
	SGLetterLayer *letter = [SGLetterLayer layer];
	
	trans = CATransform3DRotate(trans, DegreesToRadians(0.4), 0, 0, 1);
	soup.transform = trans;
	
	srandomdev();
	#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
	if ([[UIDevice currentDevice] isMultitaskingSupported]) {
		for (NSInteger t = 0; t < [soup.sublayers count]; t++) {
			
			
			randomNumber = random()%9+0;
			if (randomNumber > 1) {
				randomNumber = randomNumber / 3;
			}
			
			letter = [soup.sublayers objectAtIndex:t];
			lettertransform = letter.transform;
			lettertransform = CATransform3DRotate(lettertransform, DegreesToRadians(randomNumber), 0, 0, 1);
			letter.transform = lettertransform;
		}
	}
	#endif
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
	// e.g. self.myOutlet = nil;
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
	//[self resume];
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
