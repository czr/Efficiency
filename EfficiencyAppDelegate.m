//
//  EfficiencyAppDelegate.m
//  Efficiency
//
//  Created by Colin Z. Robertson on 02.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifdef DEBUG
#	define WORKLOG_FILENAME @"worklog.dev.txt"
#else
#	define WORKLOG_FILENAME @"worklog.txt"
#endif

#import "EfficiencyAppDelegate.h"

@implementation EfficiencyAppDelegate

@synthesize window;
@synthesize startButton;
@synthesize stopButton;
@synthesize graph;
@synthesize log;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	log = [[WorkLog alloc] init];
	[self load];
    NSLog(@"graph: %@",graph);
    [graph setLog:log];
    NSLog(@"setNeedsDisplay start");
    [graph setNeedsDisplay:YES];
    NSLog(@"setNeedsDisplay end");
    #ifdef DEBUG
        [window setTitle:@"Efficiency Dev"];
    #endif
    [stopButton setEnabled:NO];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
	[self dump];
}

- (IBAction)start: (id)sender {
    [startButton setEnabled:NO];
    [stopButton setEnabled:YES];
	[log startWorkChunk];
}

- (IBAction)stop: (id)sender {
    [startButton setEnabled:YES];
    [stopButton setEnabled:NO];
	[log endWorkChunk];
}

- (void)dump {
	NSString *filepath = [self pathForDataFile];
	NSString *data = [log toString];
	if ([data writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:NULL] == NO) {
		NSLog(@"Failed to write to file");
	}
}

- (void)load {
	NSString *filepath = [self pathForDataFile];
	NSString *string = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:NULL];
	if (string != nil) {
		[log fromString:string];
	}
}

- (NSString*) pathForDataFile {
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	NSString *folder = @"~/Library/Application Support/Efficiency/";
	folder = [folder stringByExpandingTildeInPath];
	
	if ([fileManager fileExistsAtPath: folder] == NO)
	{
		[fileManager createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:NULL];
	}
    
	NSString *fileName = WORKLOG_FILENAME;
	return [folder stringByAppendingPathComponent: fileName];    
}

@end
