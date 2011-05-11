//
//  WorkChunk.h
//  Efficiency
//
//  Created by Colin Z. Robertson on 02.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WorkChunk : NSObject {
	int start;
	int end;
}

@property int start;
@property int end;


-(void) close;

@end
