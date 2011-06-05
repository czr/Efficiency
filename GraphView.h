//
//  GraphView.h
//  Efficiency
//
//  Created by Colin Z. Robertson on 04.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WorkDay.h"
#import "WorkChunk.h"
#import "WorkLog.h"

@interface GraphView : NSView {
    WorkLog *log;
}

@property (assign) WorkLog *log;

-(NSArray*) plotDay:(WorkDay*)day;
-(NSArray*) plotDay:(WorkDay*)day from:(int)from until:(int)until;
-(NSArray*) plotDay:(WorkDay*)day from:(int)from until:(int)until stepsize:(int)stepsize;
-(NSArray*) previousPlots;
-(NSArray*) todayPlot;

@end
