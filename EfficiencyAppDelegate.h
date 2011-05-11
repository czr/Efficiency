//
//  EfficiencyAppDelegate.h
//  Efficiency
//
//  Created by Colin Z. Robertson on 02.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WorkLog.h"
#import "GraphView.h"

@interface EfficiencyAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    NSButton *startButton;
    NSButton *stopButton;
    GraphView *graph;
	WorkLog *log;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSButton *startButton;
@property (assign) IBOutlet NSButton *stopButton;
@property (assign) IBOutlet GraphView *graph;

@property (assign) WorkLog *log;

- (IBAction) start: (id) sender;
- (IBAction) stop: (id) sender;

- (void) dump;
- (void) load;

- (NSString*) pathForDataFile;

@end
