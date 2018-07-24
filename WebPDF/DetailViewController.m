//
//  DetailViewController.m
//  WebPDF
//
//  Created by Doug Diego on 11/4/14.
//  Copyright (c) 2014 Doug Diego. All rights reserved.
//

#import "DetailViewController.h"
#import "WebPDFUtils.h"
#import "DDLogging.h"

@interface DetailViewController () <UIDocumentInteractionControllerDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,strong) UIBarButtonItem *shareButton;
@property (nonatomic, retain) UIDocumentInteractionController *documentInteractionController;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        self.title = [self.detailItem valueForKey:@"title"];
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        [self showPDFFile];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    //self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                 target:self
                                                                 action:@selector(shareButtonPressed:)];
    self.navigationItem.rightBarButtonItem = _shareButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Actions

-(void) shareButtonPressed:  (UIBarButtonItem*) sender {
    //DDLog("shareButtonPressed: %@", sender);
    
    
    NSString* fileName = [NSString stringWithFormat:@"%@.pdf", [self.detailItem valueForKey:@"pdfFilename"]];
    NSString* filePath = [WebPDFUtils pathWithFilename:fileName];
    
    /*
    NSArray *activityItems = @[[NSURL fileURLWithPath:filePath]];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.popoverPresentationController.barButtonItem = _shareButton;
    
    [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed) {
        //DDLog("completed dialog - activity: %@ - finished flag: %d", activityType, completed);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self presentViewController:activityViewController
                       animated:YES
                     completion:nil];
    */

    
    self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    
    self.documentInteractionController.delegate = self;
    
    //self.documentInteractionController.name = @"Title";
    self.documentInteractionController.UTI = @"com.adobe.pdf";
    [self.documentInteractionController presentOptionsMenuFromBarButtonItem:sender animated:YES];
    
}

-(void) backButtonPressed:  (id) sender {
    //DDLog("backButtonPressed");
    [self.navigationController popViewControllerAnimated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private

-(void)showPDFFile {
    NSString* fileName = [NSString stringWithFormat:@"%@.pdf", [self.detailItem valueForKey:@"pdfFilename"]];
    NSString* filePath = [WebPDFUtils pathWithFilename:fileName];
    
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView setScalesPageToFit:YES];
    [_webView loadRequest:request];
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIDocumentInteractionControllerDelegate

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
    return self.view.frame;
}

@end
