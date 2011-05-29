//
//  WorkDay.m
//  Efficiency
//
//  Created by Colin Z. Robertson on 05.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WorkDay.h"


@implementation WorkDay

@synthesize date;

-(id) init {
	self = [super init];
	
	if (self != nil) {
        chunks = [[NSMutableArray alloc] init];
	}
	
	return self;
}

-(void) addChunk:(WorkChunk*)chunk {
    [chunks addObject:chunk];
}

-(WorkChunk*) getChunkAt:(int)index {
    return [chunks objectAtIndex:index];
}

-(NSEnumerator*) chunkEnumerator {
    return [chunks objectEnumerator];
}

-(float) efficiencyUntil:(int)until {
    
    if (until == 0) {
        if ([chunks count] > 0 && [[self getChunkAt:0] start] == 0) {
            return 1.0;
        }
        else {
            return 0.0;
        }
    }
    
    NSEnumerator *e = [self chunkEnumerator];
    int secondsWorked = 0;
    WorkChunk *chunk;
    while ((chunk = [e nextObject])) {
        int start = [chunk start];
        int end = [chunk end];
        if (start < until && end <= until) {
            secondsWorked += end - start;
        }
        if (start < until && end > until) {
            secondsWorked += until - start;
        }
    }
    return (float)secondsWorked / until;
}

@end
