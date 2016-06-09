//
//  PostTableViewCell.h
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@class PostTableViewCell;

@protocol PostTableViewCellDelegate <NSObject>
- (void)detailsButtonTapped:(PostTableViewCell*)cell;
@end

@interface PostTableViewCell : UITableViewCell

+ (PostTableViewCell *)cellFromNib;
@property (weak, nonatomic) IBOutlet UIButton *readButton;
@property (weak, nonatomic) IBOutlet UILabel *postTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *otehrLabel;
@property (strong, nonatomic) id<PostTableViewCellDelegate> delegate;
@property (nonatomic, strong) Post *post;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateWidth;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTitleHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintDesriptionHeight;


@end
