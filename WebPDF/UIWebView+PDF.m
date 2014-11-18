//
//  UIWebView+PDF.m
//  WebPDF
//
//  Created by Doug Diego on 11/17/14.
//  Copyright (c) 2014 Doug Diego. All rights reserved.
//

#import "UIWebView+PDF.h"
#import "UIPrintPageRenderer+PDF.h"

@implementation UIWebView (PDF)

-(NSData*) pdfWithSize: (CGSize) size {
    UIPrintPageRenderer *render = [[UIPrintPageRenderer alloc] init];
    [render addPrintFormatter:self.viewPrintFormatter startingAtPageAtIndex:0];
    //increase these values according to your requirement
    float topPadding = 10.0f;
    float bottomPadding = 10.0f;
    float leftPadding = 10.0f;
    float rightPadding = 10.0f;
    CGRect printableRect = CGRectMake(leftPadding,
                                      topPadding,
                                      size.width-leftPadding-rightPadding,
                                      size.height-topPadding-bottomPadding);
    CGRect paperRect = CGRectMake(0, 0, size.width, size.height);
    [render setValue:[NSValue valueWithCGRect:paperRect] forKey:@"paperRect"];
    [render setValue:[NSValue valueWithCGRect:printableRect] forKey:@"printableRect"];
    return [render printToPDF];
}

@end
