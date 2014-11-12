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

@interface SettingsViewController()
@property (nonatomic,strong) NSArray* items;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
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
        } else if( indexPath.row == 1){
            controller.filename = [[NSBundle mainBundle] pathForResource:@"license" ofType:@"html"];
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
    
    [self performSegueWithIdentifier:@"HTMLSegue" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

@end
