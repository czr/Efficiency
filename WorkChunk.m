//
//  WorkChunk.m
//  Efficiency
//
//  Created by Colin Z. Robertson on 02.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WorkChunk.h"
#import "Time.h"

@implementation WorkChunk

@synthesize start;
@synthesize end;

-(int) end {
    if (end != -1) {
        return end;
    }
    else {
        return [Time secondOfDay];
    }
}

-(id) init {
	self = [super init];
	
	if (self != nil) {
		[self setStart:[Time secondOfDay]];
		[self setEnd:-1];
	}
	
	return self;
}

-(void) close {
	[self setEnd:[Time secondOfDay]];
}

- (BOOL)isEqual:(id)otherObject;
{
	if ([otherObject isKindOfClass:[WorkChunk class]]) {
		WorkChunk *otherWorkChunk = (WorkChunk *)otherObject;
		if (start != [otherWorkChunk start]) return NO;
		if (end != [otherWorkChunk end]) return NO;
		return YES;
	}
	return NO;
}



@end
