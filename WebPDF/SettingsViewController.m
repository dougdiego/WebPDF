//
//  SettingsViewController.m
//  WebPDF
//
//  Created by Doug Diego on 11/8/14.
//  Copyright (c) 2014 Doug Diego. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsTableViewCell.h"
#import "HTMLViewController.h"
#import "DDLogging.h"
#import "DDLicensesViewController.h"

@interface SettingsViewController()
@property (nonatomic,strong) NSArray* items;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) DDLicensesViewController * ddLicensesViewController;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_close"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(closeButtonPressed:)];
    self.navigationItem.leftBarButtonItem = closeButton;
    
    self.title = @"Settings";
    
    _items = @[@"About", @"Licenses"];
    
    [self.tableView reloadData];
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Segues


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //DDLog("prepareForSegue: %@", [segue identifier] );
    if ([[segue identifier] isEqualToString:@"HTMLSegue"]) {
        HTMLViewController *controller = (HTMLViewController *)[segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //DDLog("indexPath: %@", @(indexPath.row));
        controller.title = [_items objectAtIndex:indexPath.row];
        if(indexPath.row==0){
            controller.filename = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
        } 
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Actions

-(void) closeButtonPressed:  (id) sender {
    // DDLog("closeButtonPressed");
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) backButtonPressed:  (id) sender {
    DDLog("backButtonPressed");
    [self.navigationController popoverPresentationController];
}

-(void) showLicenses {
    // Load Licenses1 from a plist
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Licenses" ofType:@"plist"];
    NSArray * licenses = [[NSArray alloc] initWithContentsOfFile:path];
    NSArray * ddLicenses = [DDLicense licenseArrayFromDictionaryArray: licenses];
    
    if(!_ddLicensesViewController){
        _ddLicensesViewController= [[DDLicensesViewController alloc] init];
    }
    _ddLicensesViewController.title = @"Licenses";
    _ddLicensesViewController.licenses = ddLicenses;
    
    
    // Optional: license list font
    _ddLicensesViewController.licenseListFont = [UIFont fontWithName:@"HelveticaNeue" size:17];
    _ddLicensesViewController.licenseListFontColor = [UIColor darkGrayColor];
    
    // Optional: license font
    _ddLicensesViewController.licenseFont = [UIFont fontWithName:@"Courier" size:17];
    
    
//    _ddLicensesViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_back"]
//                                                                             style:UIBarButtonItemStylePlain
//                                                                            target:self
//                                                                            action:@selector(backButtonPressed:)];
    
    
    [self.navigationController pushViewController:_ddLicensesViewController animated:YES];
    
//    // Add close button to navigation bar
//    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
//                                                                                        target:self
//                                                                                        action:@selector(closeButtonPressed:)];
//    
//    // Put DDLicensesViewController in a UINavigationController and show
//    UINavigationController * nvc = [[UINavigationController alloc] initWithRootViewController:vc];
//    [self presentViewController:nvc animated:YES completion:nil];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SettingsTableViewCell";
    SettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.settingsTitleLabel.text = [_items objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if( indexPath.row == 0) {
        [self performSegueWithIdentifier:@"HTMLSegue" sender:self];
    } else if(indexPath.row == 1){
        [self showLicenses];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

@end
