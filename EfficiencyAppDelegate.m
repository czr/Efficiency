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
@synthesize timer;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	log = [[WorkLog alloc] init];
	[self load];
    NSLog(@"graph: %@",graph);
    [graph setLog:log];
    #ifdef DEBUG
        [window setTitle:@"Efficiency Dev"];
    #endif
    timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(redraw) userInfo:nil repeats:YES];
    [stopButton setEnabled:NO];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
	[self dump];
}

- (void)redraw {
    [graph setNeedsDisplay:YES];
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

/**
    Returns the support directory for the application, used to store the Core Data
    store file.  This code uses a directory named "Efficiency" for
    the content, either in the NSApplicationSupportDirectory location or (if the
    former cannot be found), the system's temporary directory.
 */

- (NSString *)applicationSupportDirectory {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
    return [basePath stringByAppendingPathComponent:@"Efficiency"];
}

- (NSString*) pathForDataFile {
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *folder = [self applicationSupportDirectory];
	
	if ([fileManager fileExistsAtPath: folder] == NO)
	{
		[fileManager createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:NULL];
	}
    
	NSString *fileName = WORKLOG_FILENAME;
	return [folder stringByAppendingPathComponent: fileName];    
}

@end
