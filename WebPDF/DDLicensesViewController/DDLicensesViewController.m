//
// DDLicensesViewController.m
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

#import "DDLicensesViewController.h"
#import "DDLicenseViewController.h"

@interface DDLicensesViewController ()

@property (strong, nonatomic) DDLicenseViewController* licensePageViewController;

@end

@implementation DDLicensesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    // Remove empty cell separators
    self.tableView.tableFooterView = [UIView new];
    
    //NSLog(@"vc.navigationItem.leftBarButtonItem: %@ count: %d", self.navigationItem.leftBarButtonItem,self.navigationController.childViewControllers.count );
    
    
    if(_backButtonImage && !self.navigationItem.leftBarButtonItem && self.navigationController.childViewControllers.count > 1){
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_back"]
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(backButtonPressed:)];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _licenses.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    DDLicense * license = [_licenses objectAtIndex:indexPath.row];
    
    cell.textLabel.text = license.name;
    if(_licenseListFont){
        cell.textLabel.font = _licenseListFont;
    }
    if(_licenseListFontColor){
        cell.textLabel.textColor = _licenseListFontColor;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DDLicense * license = [_licenses objectAtIndex:indexPath.row];
    
    if(!_licensePageViewController){
        _licensePageViewController = [[DDLicenseViewController alloc] init];
    }
    if(_licenseFont){
        _licensePageViewController.licenseFont = _licenseFont;
    }
    _licensePageViewController.license = license;
    
    if(_backButtonImage){
        _licensePageViewController.backButtonImage = _backButtonImage;
    }
    
    [self.navigationController pushViewController:_licensePageViewController animated:YES];
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Actions

-(void) backButtonPressed:  (id) sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end