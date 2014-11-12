//
//  WebPDFUtils.m
//  WebPDF
//
//  Created by Doug Diego on 11/8/14.
//  Copyright (c) 2014 Doug Diego. All rights reserved.
//

#import "WebPDFUtils.h"
#import "DDLogging.h"

@implementation WebPDFUtils

+(NSString*) pathWithFilename: (NSString*) fileName {
    //DDLog("filename: %@", fileName);
    
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
    //DDLog("pdfFileName: %@", pdfFileName);
    
    return pdfFileName;
}

@end
