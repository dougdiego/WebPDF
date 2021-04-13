//
// DDLicenseViewController.m
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

#import "DDLicenseViewController.h"

@interface DDLicenseViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView * webView;
@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) UILabel * scrollTextLabel;

@end

@implementation DDLicenseViewController

- (id) init {
    _openLinksInSafari = true;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView = [[UIWebView alloc] initWithFrame:(CGRect){0,0,self.view.frame.size.width, self.view.frame.size.height}];
    [self.view addSubview:_webView];
    self.webView.delegate = self;
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:(CGRect){0,0,self.view.frame.size.width, self.view.frame.size.height}];
    [self.view addSubview:_scrollView];
    
    _scrollTextLabel = [[UILabel alloc] initWithFrame:(CGRect){0,0,self.view.frame.size.width, self.view.frame.size.height}];
    [_scrollView addSubview:_scrollTextLabel];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if(_backButtonImage){
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:_backButtonImage
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(backButtonPressed:)];
    }

}

-(void) didPressShareButton: (id) sender {

    
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[_license.name, _license.licenseUrl]
                                      applicationActivities:nil];
    [self.navigationController presentViewController:activityViewController
                                       animated:YES
                                     completion:^{
                                         // ...
                                     }];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _webView.frame =  (CGRect){0,0,self.view.frame.size.width, self.view.frame.size.height};
    _scrollView.frame =  (CGRect){0,0,self.view.frame.size.width, self.view.frame.size.height};
    _scrollTextLabel.frame =  (CGRect){0,0,self.view.frame.size.width, self.view.frame.size.height};
   
    //NSLog(@"_license.licenseUrl: %@", _license.licenseUrl );
    if( [_license.licenseUrl isKindOfClass:[NSString class]] && [(NSString*)_license.licenseUrl length] > 0 ){
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(didPressShareButton:)];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    if( _license.isHTML){
        [self.webView loadHTMLString:_license.licenseText baseURL:nil];
        _webView.hidden = NO;
        _scrollView.hidden = YES;
    } else {
        
        if(_licenseFont){
            _scrollTextLabel.font = _licenseFont;
        }
        
        if(_licenseFontColor){
            _scrollTextLabel.textColor = _licenseFontColor;
        }
        
        // add long text to label
        _scrollTextLabel.text = _license.licenseText;
        
        // set line break mode to word wrap
        _scrollTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        // set number of lines to zero
        _scrollTextLabel.numberOfLines = 0;
        
        // resize label
        [_scrollTextLabel sizeToFit];
        
        _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, _scrollTextLabel.frame.size.height);
        
        _webView.hidden = YES;
        _scrollView.hidden = NO;
        
    }
    
    self.title = _license.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)awebView {
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"didFailLoadWithError error: %@", error);
    
}

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    
    if (_openLinksInSafari){
        // Open links in Safari
        if ( inType == UIWebViewNavigationTypeLinkClicked ) {
            [[UIApplication sharedApplication] openURL:[inRequest URL]];
            return NO;
        }
    }
    
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Actions

-(void) backButtonPressed:  (id) sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
