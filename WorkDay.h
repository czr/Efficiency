//
//  WorkDay.h
//  Efficiency
//
//  Created by Colin Z. Robertson on 05.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WorkChunk.h"


@interface WorkDay : NSObject {
    NSMutableArray *chunks;
    NSString *date;
}

@property(retain) NSString *date;

-(void) addChunk:(WorkChunk*)chunk;
-(WorkChunk*) getChunkAt:(int)index;
-(NSEnumerator*) chunkEnumerator;
-(float) efficiencyUntil:(int)until;

@end
