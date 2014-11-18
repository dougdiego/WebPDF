//
//  ActionViewController.m
//  ActionExtension
//
//  Created by Doug Diego on 11/16/14.
//  Copyright (c) 2014 Doug Diego. All rights reserved.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <WebPDFFramework/WebPDFFramework.h>

#define kPaperSizeA4 CGSizeMake(595.2,841.8)

@interface ActionViewController () <UIWebViewDelegate>

@property(strong,nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *downloadBarButtonItem;

@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView.delegate = self;
    
    NSExtensionItem *item = self.extensionContext.inputItems.firstObject;
    NSItemProvider *itemProvider = item.attachments.firstObject;
    
    if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeURL]) {
        
        __weak typeof(self) weakSelf = self;
        [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeURL options:nil completionHandler:^(id<NSSecureCoding> item, NSError *error) {
            if (error) {
                [weakSelf.extensionContext cancelRequestWithError:error];
                return;
            }
            
            if (![(NSObject *)item isKindOfClass:[NSURL class]]) {
                NSError *unexpectedError = [NSError errorWithDomain:NSItemProviderErrorDomain
                                                               code:NSItemProviderUnexpectedValueClassError
                                                           userInfo:nil];
                [weakSelf.extensionContext cancelRequestWithError:unexpectedError];
                return;
            }
            
            NSURL *url = (NSURL *)item;
            
            [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:url]];
        }];
    } else {
        NSError *unavailableError = [NSError errorWithDomain:NSItemProviderErrorDomain
                                                        code:NSItemProviderItemUnavailableError
                                                    userInfo:nil];
        [self.extensionContext cancelRequestWithError:unavailableError];
    }
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
    
    if (_webView.isLoading) {
        return;
    }
    
    self.downloadBarButtonItem.enabled = YES;
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    self.downloadBarButtonItem.enabled = NO;
}

- (IBAction)downloadButtonPressed:(id)sender {
    
    // Get Shared Directory
    NSURL *storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.WebPDF"];
    //NSLog(@"storeURL: %@", storeURL);
    
    NSString * title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    
    //[SVProgressHUD show];
    
    NSData *pdfData =[_webView pdfWithSize:kPaperSizeA4];
    
    if (pdfData) {
        // Save PDF to shared Directory
        NSString *UUID = [[NSUUID UUID] UUIDString];
        NSURL *pdfURL = [storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf", UUID]];
        //NSLog(@"Writing file to: %@", pdfURL );
        [pdfData writeToURL:pdfURL atomically:YES];
        
        // Save Image to shared Directory
        UIImage* image = [self.webView captureScreenImage];
        NSData *pngData = UIImagePNGRepresentation(image);
        NSString *imageUUID = [[NSUUID UUID] UUIDString];
        NSURL *imageURL = [storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imageUUID]];
        //NSLog(@"Writing file to: %@", imageURL );
        [pngData writeToURL:imageURL atomically:YES];
        
        
        //[SVProgressHUD showSuccessWithStatus:@"PDF Created"];
        
        // Get current list of items from shared defaults
        NSUserDefaults *extensionUserDefaults = [[NSUserDefaults alloc]initWithSuiteName:@"group.WebPDF"];
        NSArray * currentItems = [extensionUserDefaults objectForKey:@"items"];
        //NSLog(@"currentItems: %@", currentItems);
        
        // Append existing defaults to new defaults
        NSMutableArray * items = [NSMutableArray array];
        if( currentItems ) {
            items = [NSMutableArray arrayWithArray:currentItems];
        }
        
        // Add new default and save
        [items addObject:@{@"pdfFilename":UUID, @"imageFilename":imageUUID, @"title": title }];
        //NSLog(@"items: %@", items);
        [extensionUserDefaults setObject:items forKey:@"items"];
        [extensionUserDefaults synchronize];
        
        
    } else {
        NSLog(@"PDF couldnot be created");
        //[SVProgressHUD showErrorWithStatus:@"Error creating PDF"];
    }
    
    
    
    [self.extensionContext completeRequestReturningItems:self.extensionContext.inputItems
                                       completionHandler:nil];
}

- (IBAction)done {
    
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
    [self.extensionContext completeRequestReturningItems:self.extensionContext.inputItems
                                       completionHandler:nil];
}

@end
