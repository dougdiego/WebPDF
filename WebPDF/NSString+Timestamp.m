//
//  NSString+Timestamp.m
//  WebPDF
//
//  Created by Doug Diego on 11/4/14.
//  Copyright (c) 2014 Doug Diego. All rights reserved.
//

#import "NSString+Timestamp.h"

@implementation NSString (Timestamp)

+ (NSString *)dateToTimestampString:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    return [dateFormatter stringFromDate:date];
}

@end
