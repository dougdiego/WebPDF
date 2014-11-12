//
//  DetailViewController.h
//  WebPDF
//
//  Created by Doug Diego on 11/4/14.
//  Copyright (c) 2014 Doug Diego. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

