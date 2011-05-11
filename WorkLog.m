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
}

-(void) endWorkChunk {
	NSAssert(currentChunk != nil, @"No open work chunk");
	[currentChunk close];
	
    WorkDay *today = [self today];
	[today addChunk:currentChunk];
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
    NSLog(@"days contains %d elements",[days count]);

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
    NSLog(@"sortedObjects contains %d elements",[sortedObjects count]);
    return [sortedObjects objectEnumerator];
}

@end
