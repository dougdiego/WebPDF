//
//  PageListTableViewCell.h
//  WebPDF
//
//  Created by Doug Diego on 11/4/14.
//  Copyright (c) 2014 Doug Diego. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *pageTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pageSubTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pageSubSubTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pageImageView;

@end
