//
//  UIWebView+PDF.h
//  WebPDF
//
//  Created by Doug Diego on 11/17/14.
//  Copyright (c) 2014 Doug Diego. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (PDF)

-(NSData*) pdfWithSize: (CGSize) size;

@end
