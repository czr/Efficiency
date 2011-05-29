//
//  Test.m
//  Efficiency
//
//  Created by Colin Z. Robertson on 04.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Test.h"
#import "GraphView.h"
#import "WorkChunk.h"
#import "WorkDay.h"
#import "WorkLog.h"

@implementation Test

- (void)testWorkChunkInactive {
	WorkChunk *chunk = [[WorkChunk alloc] init];
	[chunk setStart:5];
	[chunk setEnd:10];
	STAssertEquals(5,[chunk start],@"WorkChunk start");
	STAssertEquals(10,[chunk end],@"WorkChunk end");
}

- (void)testWorkChunkActive {
	WorkChunk *chunk = [[WorkChunk alloc] init];
	[chunk setStart:5];
	STAssertEquals(5,[chunk start],@"WorkChunk start");
	STAssertTrue([chunk end] > 0,@"WorkChunk end");
}

- (void)testWorkChunkEqual {
	WorkChunk *chunkA = [[WorkChunk alloc] init];
	[chunkA setStart:5];
	[chunkA setEnd:10];
	
	WorkChunk *chunkB = [[WorkChunk alloc] init];
	[chunkB setStart:5];
	[chunkB setEnd:10];
	
	STAssertEqualObjects(chunkA,chunkB,@"WorkChunks equal");
}

- (void)testWorkChunkNotEqual {
	WorkChunk *chunkA = [[WorkChunk alloc] init];
	[chunkA setStart:6];
	[chunkA setEnd:10];
	
	WorkChunk *chunkB = [[WorkChunk alloc] init];
	[chunkB setStart:5];
	[chunkB setEnd:10];
	
	STAssertFalse([chunkA isEqual:chunkB],@"WorkChunks not equal");
}

- (void)testWorkDay {
	WorkDay *day = [[WorkDay alloc] init];

    [day setDate:@"2011-05-06"];
    STAssertEquals(@"2011-05-06",[day date],nil);

	WorkChunk *chunkA = [[WorkChunk alloc] init];
	[chunkA setStart:5];
	[chunkA setEnd:(24 * 60 * 60)];
	[day addChunk:chunkA];

	WorkChunk *chunkB = [[WorkChunk alloc] init];
	[chunkB setStart:5];
	[chunkB setEnd:(24 * 60 * 60)];
	[day addChunk:chunkB];

	WorkChunk *gotA = [day getChunkAt:0];
	STAssertEquals(chunkA,gotA,nil);

	WorkChunk *gotB = [day getChunkAt:1];
	STAssertEquals(chunkB,gotB,nil);
	
    NSEnumerator *e = [day chunkEnumerator];
    STAssertEquals(chunkA,[e nextObject],nil);
    STAssertEquals(chunkB,[e nextObject],nil);
    STAssertNil([e nextObject],nil);
}

- (void)testWorkLog {
    WorkLog *log = [[WorkLog alloc] init];
    [log startWorkChunk];
    
    NSEnumerator *e = [log dayEnumerator];
    WorkDay *day = [e nextObject];
    STAssertTrue([day isKindOfClass:[WorkDay class]],nil);
    STAssertEquals((NSUInteger)10,[[day date] length],nil);
    STAssertNil([e nextObject],nil);
}

- (void)testWorkLogStringification {
    WorkLog *log = [[WorkLog alloc] init];
    NSString *spec = @"2011-05-04:\n"
                      "start:10 end:100\n"
                      "start:150 end:200\n"
                      "\n"
                      "2011-05-05:\n"
                      "start:300 end:500\n"
                      "\n"
                      "2011-05-06:\n"
                      "start:20 end:30\n"
                      "start:40 end:45\n"
                      "start:50 end:60\n"
                      "\n";
    NSLog(@"Parsing:\n%@",spec);
    [log fromString:spec];
    NSLog(@"Stringifying:\n%@",[log toString]);
    STAssertEqualObjects(spec,[log toString],nil);
}

- (void)testGraphView {
    GraphView *graph = [[GraphView alloc] init];
    WorkLog *log = [[WorkLog alloc] init];
    [graph setLog:log];
    
    STAssertEquals(log,[graph log],nil);
}

- (void)testGraphViewPreviousPlots {
    WorkLog *log = [[WorkLog alloc] init];
    NSString *spec = @"2011-05-04:\n"
                      "start:10 end:100\n"
                      "start:150 end:200\n"
                      "\n"
                      "2011-05-05:\n"
                      "start:300 end:500\n"
                      "\n"
                      "2011-05-06:\n"
                      "start:20 end:30\n"
                      "start:40 end:45\n"
                      "start:50 end:60\n"
                      "\n";
    [log fromString:spec];
    [log startWorkChunk];
    [log endWorkChunk];
    
    GraphView *graph = [[GraphView alloc] init];
    [graph setLog:log];
    
    NSArray *plots = [graph previousPlots];
    STAssertEquals([plots count],(NSUInteger)3,nil);
    STAssertTrue([[graph todayPlot] isKindOfClass:[NSArray class]],nil);
}

- (void)testPlotDay100 {
	WorkChunk *chunkA = [[WorkChunk alloc] init];
	[chunkA setStart:0];
	[chunkA setEnd:(24 * 60 * 60)];

	WorkDay *day = [[WorkDay alloc] init];
	[day addChunk:chunkA];
	
	GraphView *graph = [[GraphView alloc] init];
	NSArray *dayGraph = [graph plotDay:day];
	NSArray *expected = [NSArray arrayWithObjects:
						 [NSValue valueWithPoint:NSMakePoint(0.0, 1.0)],
						 [NSValue valueWithPoint:NSMakePoint(0.0, 1.0)],
						 [NSValue valueWithPoint:NSMakePoint(24.0, 1.0)],
						 [NSValue valueWithPoint:NSMakePoint(24.0, 1.0)],
						 nil];
	
    STAssertEqualObjects(expected, dayGraph, @"Day graph at 100%");
}

- (void)testPlotDay0 {
	WorkDay *day = [[WorkDay alloc] init];
	
	GraphView *graph = [[GraphView alloc] init];
	NSArray *dayGraph = [graph plotDay:day];
	NSArray *expected = [NSArray arrayWithObjects:
						 [NSValue valueWithPoint:NSMakePoint(0.0, 0.0)],
						 [NSValue valueWithPoint:NSMakePoint(24.0, 0.0)],
						 nil];
	
    STAssertEqualObjects(expected, dayGraph, @"Day graph at 0%");
}

- (void)testPlotDayFirstHalf {
	WorkDay *day = [[WorkDay alloc] init];
	
	GraphView *graph = [[GraphView alloc] init];
	NSArray *dayGraph = [graph plotDay:day from:0 until:(12 * 60 * 60)];
	NSArray *expected = [NSArray arrayWithObjects:
						 [NSValue valueWithPoint:NSMakePoint(0.0, 0.0)],
						 [NSValue valueWithPoint:NSMakePoint(12.0, 0.0)],
						 nil];
	
    STAssertEqualObjects(expected, dayGraph, @"Day graph at 0%");
}

- (void)testPlotDayLastHalf {
	WorkDay *day = [[WorkDay alloc] init];
	
	GraphView *graph = [[GraphView alloc] init];
	NSArray *dayGraph = [graph plotDay:day from:(12 * 60 * 60) until:(24 * 60 * 60)];
	NSArray *expected = [NSArray arrayWithObjects:
						 [NSValue valueWithPoint:NSMakePoint(12.0, 0.0)],
						 [NSValue valueWithPoint:NSMakePoint(24.0, 0.0)],
						 nil];
	
    STAssertEqualObjects(expected, dayGraph, @"Day graph at 0%");
}

@end
