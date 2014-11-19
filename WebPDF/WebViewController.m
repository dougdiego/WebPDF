//
//  WebViewController.m
//  HTMLExport
//
//  Created by Doug Diego on 11/4/14.
//  Copyright (c) 2014 Doug Diego. All rights reserved.
//

#import "WebViewController.h"
#import "NSString+Timestamp.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "UIColor+WebPDF.h"
#import "DDLogging.h"
//#import "WebPDFFramework.h"
#import <WebPDFFramework/WebPDFFramework.h>

#define kPaperSizeA4 CGSizeMake(595.2,841.8)

@interface WebViewController () <UIWebViewDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardBarButtonItem;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *downloadBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *stopBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *reloadBarButtonItem;

//@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, copy) NSString *searchValue;
@property (nonatomic) NSInteger requestCount;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Close Button
    UIBarButtonItem * closeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_close"]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(closeButtonPressed:)];
    self.navigationItem.leftBarButtonItem = closeButton;
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.keyboardType = UIKeyboardTypeWebSearch;
    searchBar.returnKeyType = UIReturnKeyGo;
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    
    NSURL* nsUrl = [NSURL URLWithString: [[NSBundle mainBundle] pathForResource:@"new" ofType:@"html"]];
    NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    self.webView.delegate = self;
    _requestCount = 1;
    [self.webView loadRequest:request];
    
    self.navigationController.hidesBarsOnTap = YES;
    self.navigationController.hidesBarsOnSwipe = YES;
    
    self.downloadBarButtonItem.enabled = NO;
    [self updateToolbar];
    
    self.backBarButtonItem.tintColor = [UIColor mainColor];
    self.forwardBarButtonItem.tintColor = [UIColor mainColor];
    self.downloadBarButtonItem.tintColor = [UIColor mainColor];
    self.stopBarButtonItem.tintColor = [UIColor mainColor];
    self.reloadBarButtonItem.tintColor = [UIColor mainColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Actions

-(void) closeButtonPressed: (id) sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backBarButtonItemPressed:(id)sender {
    [_webView goBack];
}

- (IBAction)fowardBarButtonItemPressed:(id)sender {
    [_webView goForward];
}

- (IBAction)downloadBarButtonItemPressed:(id)sender {
    
    // Use Javascript to get the title of the web page
    NSString * title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    __block UITextField* tf;
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Save page to PDF"
                                          message:@"Enter a name"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.text = title;
         tf = textField;
     }];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //DDLog("OK - %@", tf.text);
                             [self savePageWithTitle:tf.text];
                             [alertController dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 //DDLog("Cancel");
                                 [alertController dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alertController addAction:ok];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (IBAction)stopBarButtonItemPressed:(id)sender {
    [_webView stopLoading];
}

- (IBAction)reloadBarButtonItemPressed:(id)sender {
    [_webView reload];
}

-(void) updateToolbar {
    if([self.webView canGoBack]){
        self.backBarButtonItem.enabled = YES;
    } else {
        self.backBarButtonItem.enabled = NO;
    }
    
    if([self.webView canGoForward]){
        self.forwardBarButtonItem.enabled = YES;
    } else {
        self.forwardBarButtonItem.enabled = NO;
    }
    
    if (_webView.isLoading) {
        self.stopBarButtonItem.enabled = YES;
        self.reloadBarButtonItem.enabled = NO;
    } else {
        self.stopBarButtonItem.enabled = NO;
        self.reloadBarButtonItem.enabled = YES;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)awebView {
    
    if (_webView.isLoading) {
        return;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    //DDLog("webViewDidFinishLoad");
    
    self.downloadBarButtonItem.enabled = YES;
    
    [self updateToolbar];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    //DDLog("webViewDidStartLoad");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    self.downloadBarButtonItem.enabled = NO;
    
    [self updateToolbar];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    DDError("didFailLoadWithError error: %@", error);
    
    if( error.code == kCFURLErrorNotConnectedToInternet){
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self showErrorWithMessage:@"Sorry, there doesn’t seem to be an internet connection."];
    //} else if(error.code == kCFURLErrorCancelled){
    } else if(_requestCount > 5) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self showErrorWithMessage:@"Please enter a valid url"];
    } else if( [_searchValue isKindOfClass:[NSString class]] && [(NSString*)_searchValue length] > 0 ){
        NSURL * googleURL =  [NSURL URLWithString: [NSString stringWithFormat:@"https://www.google.com/search?q=%@",[_searchValue stringByReplacingOccurrencesOfString:@" " withString:@"+"]]];
        NSURLRequest* request = [NSURLRequest requestWithURL:googleURL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
        _requestCount++;
        [self.webView loadRequest:request];
    } else {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self showErrorWithMessage:@"Please enter a valid url"];
        
    }
}

-(void) showErrorWithMessage: (NSString*) message {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Error"
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alertController dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //DDLog("searchBarSearchButtonClicked text: %@", searchBar.text);
    [searchBar resignFirstResponder];
    
    _searchValue = searchBar.text;
    
    NSURL* nsUrl = [NSURL URLWithString:searchBar.text];
    if( ![searchBar.text hasPrefix:@"http"] ){
        nsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", searchBar.text]];
    }
    
    NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    _requestCount = 1;
    [self.webView loadRequest:request];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private
/*
-(UIImage*)captureScreen:(UIView*) viewToCapture {
    UIGraphicsBeginImageContext(viewToCapture.bounds.size);
    [viewToCapture.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}
*/

-(void) savePageWithTitle: (NSString*) title {
    [SVProgressHUD show];
    
    NSData *pdfData =[_webView pdfWithSize:kPaperSizeA4];
    
    if (pdfData) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *UUID = [[NSUUID UUID] UUIDString];
        NSString *path = [NSString stringWithFormat:@"%@/%@.pdf",documentsDirectory, UUID];
        //DDLog("Writing file to: %@", path );
        [pdfData writeToFile:path atomically: YES];
        
        UIImage* image = [self.webView captureScreenImage];
        NSData *pngData = UIImagePNGRepresentation(image);
        NSString *imageUUID = [[NSUUID UUID] UUIDString];
        NSString *filePath =  [NSString stringWithFormat:@"%@/%@.png",documentsDirectory, imageUUID];
        //DDLog("Writing file to: %@", filePath );
        [pngData writeToFile:filePath atomically:YES];
        
        // Page Count
        NSURL *pdfURL = [NSURL fileURLWithPath:path];
        CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
        NSInteger pageCount = CGPDFDocumentGetNumberOfPages(pdf);
        //DDLog("pageCount: %@", @(pageCount));
        
        // Filesize
        unsigned long long size = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
        //DDLog("size: %@", @(size));
        NSString * fileSize = [NSByteCountFormatter stringFromByteCount:size countStyle:NSByteCountFormatterCountStyleFile];
        //DDLog("fileSize: %@", fileSize);
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [appDelegate insertNewObject: title pdfFilename:UUID imageFilename:imageUUID pageCount:pageCount fileSize:fileSize];
        [SVProgressHUD showSuccessWithStatus:@"PDF Created"];
    } else {
        DDError("PDF couldnot be created");
        [SVProgressHUD showErrorWithStatus:@"Error creating PDF"];
    }
}
/*
- (void)insertNewObject:(NSString*) title
            pdfFilename: (NSString*) pdfFilename
          imageFilename: (NSString*) imageFilename
              pageCount: (NSInteger) pageCount
               fileSize: (NSString*) fileSize {
    //DDLog("insertNewObject: %@ filename: %@ imageFilename: %@", title, pdfFilename, imageFilename);
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date]  forKey:@"created"];
    [newManagedObject setValue:title  forKey:@"title"];
    [newManagedObject setValue:pdfFilename  forKey:@"pdfFilename"];
    [newManagedObject setValue:imageFilename  forKey:@"imageFilename"];
    [newManagedObject setValue:fileSize  forKey:@"fileSize"];
    [newManagedObject setValue:[NSNumber numberWithInteger:pageCount]  forKey:@"pageCount"];
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        DDError("Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Page" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:appDelegate.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        DDError("Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}
*/
@end
