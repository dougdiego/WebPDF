//
//  NSString+Timestamp.h
//  WebPDF
//
//  Created by Doug Diego on 11/4/14.
//  Copyright (c) 2014 Doug Diego. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Timestamp)
+ (NSString *)dateToTimestampString:(NSDate *)date;
@end
