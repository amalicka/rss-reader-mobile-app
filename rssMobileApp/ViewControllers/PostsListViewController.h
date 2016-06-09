//
//  PostsListViewController.h
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import "BaseViewController.h"
#import "PostTableViewCell.h"

@interface PostsListViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, PostTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) Feed *feed;
@property (atomic) BOOL isAllUnreadView;

@end
