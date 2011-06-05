//
//  GraphView.m
//  Efficiency
//
//  Created by Colin Z. Robertson on 04.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"
#import "Time.h"

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

- (void)drawPercentile {
    double graphMargin = 10.5; // FIXME: Unduplicate
    int now = [Time secondOfDay];
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    [attributes setObject:[NSFont fontWithName:@"Helvetica" size:32] forKey:NSFontAttributeName];
    NSString *percentileText = [NSString stringWithFormat:@"%d", [[self log] percentileTodayAtTime:now]];
    NSSize size = [percentileText sizeWithAttributes:attributes];
    NSPoint percentileOrigin;
    percentileOrigin.x = [self bounds].size.width - (size.width + graphMargin);
    percentileOrigin.y = [self bounds].size.height - (size.height + graphMargin);
    [percentileText drawAtPoint:percentileOrigin withAttributes:attributes];
    
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
    
    int now = [Time secondOfDay];
    WorkDay *today = [[self log] today];
    NSBezierPath *todayCompletedPath = [self plotToPath:[self plotDay:today from:0 until:now]];
    [[NSColor redColor] set];
    [todayCompletedPath setLineWidth:2.0];
    [todayCompletedPath stroke];
    
    NSBezierPath *todayProjectedPath = [self plotToPath:[self plotDay:today from:now until:(60 * 60 * 24)]];
    [[NSColor colorWithDeviceRed:1.0 green:0.0 blue:0.0 alpha:0.5] set];
    [todayProjectedPath setLineWidth:2.0];
    [todayProjectedPath stroke];
    
    [self drawPercentile];
    
    [self drawAxes];
}

-(NSArray*) plotDay:(WorkDay*)day from:(int)from until:(int)until stepsize:(int)stepsize {
    NSMutableArray *points = [[NSMutableArray alloc] init];
    
    [points addObject:[NSValue valueWithPoint:NSMakePoint((float)from / (60 * 60), [day efficiencyUntil:from])]];
    
    for(int i = from + stepsize; i < until; i += stepsize) {
        [points addObject:[NSValue valueWithPoint:NSMakePoint((float)i / (60 * 60), [day efficiencyUntil:i])]];
    }
    
    [points addObject:[NSValue valueWithPoint:NSMakePoint((float)until / (60 * 60), [day efficiencyUntil:until])]];
    
    return points;
}

-(NSArray*) plotDay:(WorkDay*)day from:(int)from until:(int)until {
    return [self plotDay:day from:from until:until stepsize:60];
}

-(NSArray*) plotDay:(WorkDay*)day {
    return [self plotDay:day from:0 until:(24 * 60 * 60)];
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
