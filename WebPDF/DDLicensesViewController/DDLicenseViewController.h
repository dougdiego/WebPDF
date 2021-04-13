//
// DDLicenseViewController.h
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

#import <UIKit/UIKit.h>
#import "DDLicense.h"

@interface DDLicenseViewController :  UIViewController

/**
 Optional: The DDLicense to display
 */
@property (nonatomic,strong) DDLicense * license;

/**
 The font to show the license in.  This only works for isHTML = NO.
 If you use isHTML = YES, then set the font in the HTML.
 */
@property (nonatomic, strong) UIFont* licenseFont;

/**
 Optional: The font color to use for the license
 */
@property (nonatomic, strong) UIColor* licenseFontColor;

/**
 Optional: Image for back button
 */
@property (nonatomic, strong) UIImage* backButtonImage;

/**
 Optional: Open Links in Safari, defaults to true
 */
@property (nonatomic) BOOL openLinksInSafari;

@end
