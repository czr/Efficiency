//
//  WorkLog.m
//  Efficiency
//
//  Created by Colin Z. Robertson on 02.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WorkLog.h"

@implementation WorkLog

-(id) init {
	self = [super init];
	
	if (self != nil) {
		days = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

-(NSString*) todayYMD {
    return [[NSDate date]
        descriptionWithCalendarFormat:@"%Y-%m-%d" timeZone:nil
        locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
}

-(WorkDay*) today {
    NSString *todayYMD = [self todayYMD];
    
    WorkDay *today = [days objectForKey:todayYMD];
    
    if (today == nil) {
        today = [[WorkDay alloc] init];
        [today setDate:todayYMD];
        [days setObject:today forKey:todayYMD];
    }
    
    return today;
}

-(void) startWorkChunk {
	NSAssert(currentChunk == nil, @"Already got an open work chunk");
	currentChunk = [[WorkChunk alloc] init];

    WorkDay *today = [self today];
	[today addChunk:currentChunk];
}

-(void) endWorkChunk {
	NSAssert(currentChunk != nil, @"No open work chunk");
	[currentChunk close];
	currentChunk = nil;
}

-(NSString*) toString {
	NSEnumerator *dayEnum = [self dayEnumerator];
	WorkChunk *chunk;
    WorkDay *day;
	NSMutableString *string = [[NSMutableString alloc] init];
    while (day = [dayEnum nextObject]) {
        NSEnumerator *chunkEnum = [day chunkEnumerator];
        [string appendFormat:@"%@:\n", [day date]];
    	while (chunk = [chunkEnum nextObject]) {
    		[string appendFormat:@"start:%d end:%d\n", [chunk start], [chunk end] ];
    	}
        [string appendString:@"\n"];
    }
	return string;
}

-(void) fromString:(NSString*)string {
    
    days = [[NSMutableDictionary alloc] init];
    
	NSScanner *scanner = [NSScanner scannerWithString:string];
	
	NSInteger start;
	NSInteger end;
    NSString *date;
    
    WorkDay *day;
	WorkChunk *chunk;
	
	while ([scanner isAtEnd] == NO) {
	    
        if ([scanner scanUpToString:@":" intoString:&date] && [scanner scanString:@":" intoString:NULL]) {
            day = [[WorkDay alloc] init];
            [day setDate:date];
            [days setObject:day forKey:date];
        }

        while ([scanner scanString:@"start:" intoString:NULL] && [scanner scanInteger:&start] && [scanner scanString:@"end:" intoString:NULL] && [scanner scanInteger:&end]) {
			chunk = [[WorkChunk alloc] init];
			[chunk setStart:start];
			[chunk setEnd:end];
			[day addChunk:chunk];
		}
	}
}

-(NSEnumerator*) dayEnumerator {
    return [self dayEnumeratorWithToday:YES];
}

-(NSEnumerator*) dayEnumeratorWithToday:(bool)includeToday {

    NSString *todayYMD = [self todayYMD];

    NSArray *sortedKeys = [[days allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSMutableArray *sortedObjects = [[NSMutableArray alloc] init];
    NSEnumerator *e = [sortedKeys objectEnumerator];
    id k;
    while ((k = [e nextObject])) {
        if (includeToday || ![k isEqual:todayYMD]) {
            [sortedObjects addObject:[days objectForKey:k]];
        }
    }
    return [sortedObjects objectEnumerator];
}

- (int) percentileTodayAtTime:(int)time {
    int smaller = 0;
    int greater = 0;
    
    float todayEfficiency = [[self today] efficiencyUntil:time];
    
    NSEnumerator *e = [self dayEnumeratorWithToday:NO];
    WorkDay *d;
    while ((d = [e nextObject])) {
        if ([d efficiencyUntil:time] < todayEfficiency) {
            smaller++;
        }
        else {
            greater++;
        }
    }
    
    int todayPos = smaller + 1;
    int total = smaller + 1 + greater;
    
    int percentile = (100.0 / total) * (todayPos - 0.5);
    
    return percentile;
};


@end
