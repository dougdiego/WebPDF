//
//  HTMLViewController.m
//  WebPDF
//
//  Created by Doug Diego on 11/8/14.
//  Copyright (c) 2014 Doug Diego. All rights reserved.
//

#import "HTMLViewController.h"
#import "DDLogging.h"

@interface HTMLViewController()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation HTMLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Back Button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_back"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(backButtonPressed:)];
    
    NSURL* nsUrl = [NSURL URLWithString:_filename];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    
    self.webView.delegate = self;
    
    [self.webView loadRequest:request];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Actions

-(void) backButtonPressed:  (id) sender {
    //DDLog("backButtonPressed");
    [self.navigationController popViewControllerAnimated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //DDLog("webViewDidFinishLoad");
}

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    // Open links in Safari
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    //DDLog("webViewDidStartLoad");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    DDError("didFailLoadWithError error: %@", error);
}


@end
