//
//  AppDelegate.m
//  WebPDF
//
//  Created by Doug Diego on 11/4/14.
//  Copyright (c) 2014 Doug Diego. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"
#import "MasterViewController.h"
#import "UIColor+WebPDF.h"
#import "DDLogging.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    splitViewController.delegate = self;
    
    UINavigationController *masterNavigationController = splitViewController.viewControllers[0];
    MasterViewController *controller = (MasterViewController *)masterNavigationController.topViewController;
    controller.managedObjectContext = self.managedObjectContext;
    
    [self setupAppearance];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [self loadActionExtensionItems];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]] && ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] detailItem] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "org.diego.ios.WebPDF" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    NSLog(@"managedObjectModel");
    
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WebPDF" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"WebPDF.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        DDLog("Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            DDLog("Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

-(void) setupAppearance {
    [[UINavigationBar appearance] setBarTintColor:[UIColor mainColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
}



///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Helper

-(void) loadActionExtensionItems {
    
    // Get Shared Directory
    NSURL *storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.WebPDF"];
    //DDLog("storeURL: %@", storeURL);
    
    // Get current list of items from shared defaults
    NSUserDefaults *extensionUserDefaults = [[NSUserDefaults alloc]initWithSuiteName:@"group.WebPDF"];
    NSMutableArray * items = [[extensionUserDefaults objectForKey:@"items"] mutableCopy];
    //DDLog("items: %@", items);
    
    // Get Documents Directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // If there are any items, then process them
    for(NSDictionary* item in items ){
        //DDLog("Processing item: %@", item );
        
        // Load meta data
        NSString* pdfFilename = [item objectForKey:@"pdfFilename"];
        NSString* imageFilename = [item objectForKey:@"imageFilename"];
        NSString* title = [item objectForKey:@"title"];
        
        // Destination files
        NSString *destPDFPath = [NSString stringWithFormat:@"%@/%@.pdf",documentsDirectory, pdfFilename];
        NSString *destImagePath =  [NSString stringWithFormat:@"%@/%@.png",documentsDirectory, imageFilename];
        
        // Source files
        NSString *srcPDFPath =[NSString stringWithFormat:@"%@/%@.pdf",[storeURL path], pdfFilename];
        NSString *srcImagePath =[NSString stringWithFormat:@"%@/%@.png",[storeURL path], imageFilename];
        
        // Move files from shared directory to documents directory
        [self moveFileSrcPath:srcPDFPath destPath:destPDFPath];
        [self moveFileSrcPath:srcImagePath destPath:destImagePath];
        
        // Page Count
        NSURL *pdfURL = [NSURL fileURLWithPath:destPDFPath];
        CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
        NSInteger pageCount = CGPDFDocumentGetNumberOfPages(pdf);
        //DDLog("pageCount: %@", @(pageCount));
        
        // Filesize
        unsigned long long size = [[NSFileManager defaultManager] attributesOfItemAtPath:destPDFPath error:nil].fileSize;
        //DDLog("size: %@", @(size));
        NSString * fileSize = [NSByteCountFormatter stringFromByteCount:size countStyle:NSByteCountFormatterCountStyleFile];
        //DDLog("fileSize: %@", fileSize);
        
        // Add new page to database
        [self insertNewObject: title
                  pdfFilename:pdfFilename
                imageFilename:imageFilename
                    pageCount:pageCount
                     fileSize:fileSize];
    }
    
    // Clear all defaults after processed
    [extensionUserDefaults removeObjectForKey:@"items"];
}

-(void) moveFileSrcPath: (NSString*) srcPath destPath: (NSString*) destPath {
    //DDLog("moveFileSrcPath: %@ destPath: %@", srcPath, destPath);
    
    NSError *error = nil;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:srcPath]) {
        
        if([[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:destPath error:&error] == NO) {
            DDError("Error coping file %@", error);
        } else {
            //DDLog(@"Copied file");
            if( [[NSFileManager defaultManager] removeItemAtPath:srcPath error:&error] == NO){
                DDError("Error deleting file %@", error);
            } else {
                //DDLog("Deleted file");
            }
        }
    }
}

- (void)insertNewObject:(NSString*) title
            pdfFilename: (NSString*) pdfFilename
          imageFilename: (NSString*) imageFilename
              pageCount: (NSInteger) pageCount
               fileSize: (NSString*) fileSize {
    //DDLog("insertNewObject: %@ filename: %@ imageFilename: %@", title, pdfFilename, imageFilename);
    
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Page" inManagedObjectContext:_managedObjectContext];
    
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
    if (![_managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        DDError("Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

@end
