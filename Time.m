//
//  Time.m
//  Efficiency
//
//  Created by Colin Z. Robertson on 29.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Time.h"


@implementation Time

+ (int) secondOfDay {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *today = [calendar dateFromComponents:components];
    return [now timeIntervalSinceReferenceDate] - [today timeIntervalSinceReferenceDate];
}


@end
