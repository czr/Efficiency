//
//  WorkLog.h
//  Efficiency
//
//  Created by Colin Z. Robertson on 02.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WorkChunk.h"
#import "WorkDay.h"

@interface WorkLog : NSObject {
	NSMutableDictionary *days;
	WorkChunk *currentChunk;
}

- (void) startWorkChunk;
- (void) endWorkChunk;

- (NSString*) toString;
- (void) fromString:(NSString*)string;

- (NSEnumerator*) dayEnumerator;
- (NSEnumerator*) dayEnumeratorWithToday:(bool)includeToday;
- (WorkDay*) today;

- (int) percentileTodayAtTime:(int)time;

@end
