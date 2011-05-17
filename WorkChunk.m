//
//  WorkChunk.m
//  Efficiency
//
//  Created by Colin Z. Robertson on 02.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WorkChunk.h"


@implementation WorkChunk

@synthesize start;
@synthesize end;

-(int) secondOfDay {
	NSDate *now = [NSDate date];
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	NSDate *today = [calendar dateFromComponents:components];
	return [now timeIntervalSinceReferenceDate] - [today timeIntervalSinceReferenceDate];
}

-(int) end {
    if (end != -1) {
        return end;
    }
    else {
        return [self secondOfDay];
    }
}

-(id) init {
	self = [super init];
	
	if (self != nil) {
		[self setStart:[self secondOfDay]];
		[self setEnd:-1];
	}
	
	return self;
}

-(void) close {
	[self setEnd:[self secondOfDay]];
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
