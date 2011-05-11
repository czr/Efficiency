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

@end
