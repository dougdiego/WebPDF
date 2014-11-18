//
//  UIWebView+Image.m
//  WebPDF
//
//  Created by Doug Diego on 11/17/14.
//  Copyright (c) 2014 Doug Diego. All rights reserved.
//

#import "UIWebView+Image.h"

@implementation UIWebView (Image)

-(UIImage*)captureScreenImage {
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

@end
