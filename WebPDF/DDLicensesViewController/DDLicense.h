//
// DDLicense.h
//
// Copyright (c) 2014 Doug Diego
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


#import <Foundation/Foundation.h>

@interface DDLicense : NSObject

/**
 License name
 */
@property (nonatomic, copy) NSString *name;

/**
 License text
 */
@property (nonatomic, copy) NSString *licenseText;

/**
 License URL
 */
@property (nonatomic, copy) NSString *licenseUrl;

/**
 Whether to display the licenseText as HTML.  If isHTML = YES, then
 licenseText will be displayed in an UIWebView.  If isHTML = NO, then
 licenseText will be displayed in a UILable in a UIScrollView.
 */
@property (nonatomic) BOOL isHTML;


/**
 Init a DDLicense object from a dictionary
 */
- (DDLicense *)initWithDictionary:(NSDictionary *)dictionary;

/**
 Init an array DDLicense objects from an array of dictionary objects
 */
+ (NSArray *) licenseArrayFromDictionaryArray: (NSArray*) array;

@end

