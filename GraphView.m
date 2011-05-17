//
//  GraphView.m
//  Efficiency
//
//  Created by Colin Z. Robertson on 04.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"

@implementation GraphView

@synthesize log;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(NSPoint) translatePointToGraph:(NSPoint)point {
    double graphMargin = 10.5;
    double graphOriginX = graphMargin;
    double graphOriginY = graphMargin;
    double graphSizeX = [self bounds].size.width - (2 * graphMargin);
    double graphSizeY = [self bounds].size.height - (2 * graphMargin);
    
    return NSMakePoint(((point.x/24) * graphSizeX) + graphOriginX,(point.y * graphSizeY) + graphOriginY);
}

- (void)drawAxes {
    [[NSColor blackColor] set];
    NSBezierPath *path = [[NSBezierPath alloc] init];
    [path moveToPoint:[self translatePointToGraph:NSMakePoint(0.0,1.0)]];
    [path lineToPoint:[self translatePointToGraph:NSMakePoint(0.0,0.0)]];
    [path lineToPoint:[self translatePointToGraph:NSMakePoint(24.0,0.0)]];
    [path setLineWidth:1.0];
    [path stroke];
}

- (NSBezierPath*)plotToPath:(NSArray*)plot {
    NSBezierPath *path = [[NSBezierPath alloc] init];
    NSEnumerator *pointEnum = [plot objectEnumerator];
    [path moveToPoint:[self translatePointToGraph:[[pointEnum nextObject] pointValue]]];
    NSValue *value;
    while ((value = [pointEnum nextObject])) {
        [path lineToPoint:[self translatePointToGraph:[value pointValue]]];
    }
    return path;
}

- (void)drawRect:(NSRect)dirtyRect {
    [[NSColor whiteColor] set];
    [NSBezierPath fillRect:[self bounds]];
    
    NSMutableArray *paths = [[NSMutableArray alloc] init];
    NSArray *plots = [self previousPlots];
    NSArray *plot;
    NSEnumerator *plotEnum = [plots objectEnumerator];
    while ((plot = [plotEnum nextObject])) {
        [paths addObject:[self plotToPath:plot]];
    }
    
    [[NSColor lightGrayColor] set];
    NSEnumerator *pathEnum = [paths objectEnumerator];
    NSBezierPath *path;
    while ((path = [pathEnum nextObject])) {
        [path setLineWidth:1.0];
        [path stroke];
    }
    
    NSBezierPath *todayPath = [self plotToPath:[self todayPlot]]; //FIXME: Does this create a today object in the log before load is called? Wouldn't be a problem if I just blanked the log before loading.
    [[NSColor redColor] set];
    [todayPath setLineWidth:2.0];
    [todayPath stroke];
    
    [self drawAxes];
}

-(NSArray*) plotDay:(WorkDay*)day {
    NSMutableArray *points = [[NSMutableArray alloc] init];
    
    [points addObject:[NSValue valueWithPoint:NSMakePoint(0.0, 0.0)]];
    
    int workAccumulated = 0;
    
    id o;
    NSEnumerator *e = [day chunkEnumerator];
    while ((o = [e nextObject])) {
        WorkChunk *chunk = (WorkChunk *)o;
        
        int start = [chunk start];
        int end = [chunk end];
        double startEfficiency, endEfficiency;
        
        if (start == 0) {
            startEfficiency = 1.0;
        }
        else {
            startEfficiency = (float)workAccumulated / start;
        }
        [points addObject:[NSValue valueWithPoint:NSMakePoint(((float)start / (60 * 60)), startEfficiency)]];

        workAccumulated += end - start;

        if (end == 0) {
            endEfficiency = 0.0;
        }
        else {
            endEfficiency = (float)workAccumulated / end;
        }
        [points addObject:[NSValue valueWithPoint:NSMakePoint(((float)end / (60 * 60)), endEfficiency)]];
        
    }
    
    double totalEfficiency = (float)workAccumulated / (24 * 60 * 60);

    [points addObject:[NSValue valueWithPoint:NSMakePoint(24.0, totalEfficiency)]];
    
    return points;
}

-(NSArray*) previousPlots {
    NSLog(@"plots from log: %@",[self log]);
    NSMutableArray *plots = [[NSMutableArray alloc] init];
    NSEnumerator *e = [[self log] dayEnumeratorWithToday:NO];
    WorkDay *day;
    while ((day = [e nextObject])) {
        [plots addObject:[self plotDay:day]];
    }
    return plots;
}

-(NSArray*) todayPlot {
    WorkDay *today = [[self log] today];
    return [self plotDay:today];
}

@end
