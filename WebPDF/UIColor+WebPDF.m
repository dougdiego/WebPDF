//
//  UIColor+WebPDF.m
//  WebPDF
//
//  Created by Doug Diego on 11/8/14.
//  Copyright (c) 2014 Doug Diego. All rights reserved.
//

#import "UIColor+WebPDF.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation UIColor (WebPDF)

+(UIColor*) mainColor {
    return UIColorFromRGB(0x7488B0);
}

@end
