//
//  PostsListViewController.m
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import "PostsListViewController.h"
#import "DetailsViewController.h"

NSString *const kPostCellIdentifier = @"PostCellIdentifier";

@interface PostsListViewController ()

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *dataSourceAll;
@property (nonatomic, strong) NSIndexPath *lasSelectedIndexPath;
@property (nonatomic, strong) UIButton *allOrUnreadButton;
@property (nonatomic, strong) UIView *header;
@property (atomic) BOOL flgShowUnread;

@end

@implementation PostsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //DATA
    if(self.isAllUnreadView){
        self.dataSourceAll = [[CoreDataManager sharedManager] getAllActivePosts];
    }else{
        self.dataSourceAll = [self.feed.posts allObjects];
    }
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                        sortDescriptorWithKey:@"pub_date"
                                        ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
    self.dataSourceAll = [self.dataSourceAll sortedArrayUsingDescriptors:sortDescriptors];
    
    self.dataSource = self.dataSourceAll;
    
    
    //BAR BUTTON ITEM
    self.allOrUnreadButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,40,40)];
//    [sortButton setImage:[UIImage imageNamed:@"ic_sort"] forState:UIControlStateSelected | UIControlStateHighlighted | UIControlStateNormal | UIControlStateFocused];
    [self.allOrUnreadButton setImage:[UIImage imageNamed:@"ic_show_unread_all"] forState: UIControlStateNormal];
    self.allOrUnreadButton.accessibilityLabel = NSLocalizedString(@"label_allPost", nil);
    [self.allOrUnreadButton addTarget:self action:@selector(changePostsListTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:self.allOrUnreadButton];
    self.navigationItem.rightBarButtonItem = barButton;
    
    //TABLE VIEW
    self.flgShowUnread = NO;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.tableView = tableView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PostTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:kPostCellIdentifier];
    [self reloadTableView];
}
                                                                   

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.isAllUnreadView){
        self.title = NSLocalizedString(@"unread", nil);
    }else{
        self.title = [UrlStringFormatter makePreetyUrlName:self.feed.url];
    }
    if(self.lasSelectedIndexPath){
        [self.tableView reloadRowsAtIndexPaths:@[self.lasSelectedIndexPath] withRowAnimation:NO];
        self.lasSelectedIndexPath = nil;
    }
}

//- (void)prepareData{
//    //workaround for fault relationship
//    for (Feed *f in [[CoreDataManager sharedManager] getAllFeeds]) {
//        NSLog(@"-----------");
//        for(Post *p in [f.posts allObjects]){
//            NSLog(@"%@", p.title);
//        }
//    }
//    
//    PostsListViewController __weak *weakSelf = self;
//    [[ApiClient sharedSingleton] getDataForFeed: self.feed.url withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        Parser *parser = [[Parser alloc] initWithData:(NSData*)responseObject andFeed:self.feed];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismiss];
//            [weakSelf reloadTableView];
//        });
//        
//    } failure:^(NSError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismiss];
//        });
//    }];
//}

- (void)reloadTableView{
    if(self.flgShowUnread){
        NSPredicate *getUnreadPredicate = [NSPredicate predicateWithFormat:@"is_read == %@", [NSNumber numberWithBool:NO]];
        NSArray *filteredArray =[self.dataSourceAll filteredArrayUsingPredicate:getUnreadPredicate];
        NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                            sortDescriptorWithKey:@"pub_date"
                                            ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
        NSArray *sortedEventArray = [filteredArray sortedArrayUsingDescriptors:sortDescriptors];
        self.dataSource = sortedEventArray;
    }else{
        self.dataSource = self.dataSourceAll;
    }[self.tableView reloadData];
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PostTableViewCell *cell = (PostTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:kPostCellIdentifier forIndexPath:indexPath];
    if (cell == nil)  {
        cell = [PostTableViewCell cellFromNib];
    }
    Post *p = (Post*)self.dataSource[indexPath.row];
    cell.post = p;
    cell.postTitleLabel.text = p.title;
    cell.dateLabel.text = [p getPublicationDate];
    cell.otehrLabel.text = [p getShortDescription];
    cell.delegate = self;
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    return YES;
//}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//
//}

#pragma  mark - TableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.lasSelectedIndexPath = indexPath;
    DetailsViewController *vc =[[DetailsViewController alloc] init];
    Post *post = (Post *)self.dataSource[indexPath.row];
    post.is_read = [NSNumber numberWithBool:YES];
    [[CoreDataManager sharedManager] saveContext];
    vc.post = post;
    if(!self.isAllUnreadView){
        vc.title = self.title;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Post *p = (Post*)self.dataSource[indexPath.row];
    if([p.post_description isEqualToString:@""]){
        return 30;
    }else{
        return 93;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (void)changePostsListTapped{
    self.flgShowUnread = (self.flgShowUnread) ? (self.flgShowUnread=NO):(self.flgShowUnread=YES);
    if(self.flgShowUnread){
        [self.allOrUnreadButton setImage:[UIImage imageNamed:@"ic_show_unread_only"] forState: UIControlStateNormal];
        self.allOrUnreadButton.accessibilityLabel = NSLocalizedString(@"label_allPost", nil);
    }else{
        [self.allOrUnreadButton setImage:[UIImage imageNamed:@"ic_show_unread_all"] forState: UIControlStateNormal];
        self.allOrUnreadButton.accessibilityLabel = NSLocalizedString(@"label_postsUnreadReaded", nil);
    }
    [self reloadTableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

#pragma  mark - cell delegate methods
- (void)detailsButtonTapped:(PostTableViewCell*)cell{
    if([cell.post.is_read isEqual: [NSNumber numberWithBool:YES]]){
        cell.post.is_read = [NSNumber numberWithBool:NO];
    }else{
        cell.post.is_read = [NSNumber numberWithBool:YES];
    }
    [[CoreDataManager sharedManager] saveContext];
    NSIndexPath *indexPath = [self.tableView indexPathForCell: cell];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
}

@end
