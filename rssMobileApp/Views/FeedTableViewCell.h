//
//  FeedTableViewCell.h
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintNameLabelHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCountLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCountLabelWidth;


+ (FeedTableViewCell *)cellFromNib;

@end
