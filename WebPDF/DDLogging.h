//
//  DDLogging.h
//  WebPDF
//
//  Created by Doug Diego on 11/8/14.
//  Copyright (c) 2014 Doug Diego. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TargetConditionals.h>



#define DDError(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#ifdef DEBUG
#define DDLog(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DDLog(xx, ...)  ((void)0)
#endif // #ifdef DEBUG