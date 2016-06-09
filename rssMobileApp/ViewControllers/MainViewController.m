
//
//  MainViewController.m
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import "MainViewController.h"
#import "PostsListViewController.h"
#import "FeedTableViewCell.h"
#import "FeedTableViewCell.h"
#import "UrlStringFormatter.h"
#import "LoginViewController.h"
#import "SettingsViewController.h"

static NSString *kFeedCellIdentifier = @"kFeedCellIdentifier";

@interface MainViewController ()
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSIndexPath *lasSelectedIndexPath;
@property (nonatomic, strong) NSIndexPath *topSectionIndexPath;
@property int feedsPostsParsed;
@property int notifCountExpiredToken;
@property (nonatomic, strong) NSString *lastEnteredUrl;
@property (atomic) BOOL isBatchPostUpdatePerfomed;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"mainScreen", nil);
    
    self.feedsPostsParsed = 0;
    self.notifCountExpiredToken = 0;
    self.isBatchPostUpdatePerfomed = NO;
    self.dataSource = [[NSMutableArray alloc] init];
    [self.dataSource addObjectsFromArray:[[CoreDataManager sharedManager] getAllActiveFeeds]];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor appLightBackgroundColor];
    
    //add pull torefresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor appBaseColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(pullToRefreshSynchronize)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FeedTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:kFeedCellIdentifier];
    [self.tableView addSubview:self.refreshControl];
    [self.tableView reloadData];
    
    //self.buttonAdd.backgroundColor = [UIColor lightGrayColor];
    self.buttonAdd.accessibilityLabel = NSLocalizedString(@"label_addFeed", nil);
    
    //BARBUTTON ITEMS
    
    //BAR BUTTON ITEM
    UIButton *settingsButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,40,40)];
    [settingsButton setImage:[UIImage imageNamed:@"ic_user_icon"] forState: UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(userSettingsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    settingsButton.accessibilityLabel = NSLocalizedString(@"label_userSettings", nil);
    UIBarButtonItem *settingsBarButton = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
    self.navigationItem.leftBarButtonItem = settingsBarButton;
    
    UIButton *markButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,40,40)];
    [markButton setImage:[UIImage imageNamed:@"ic_mark_read"] forState: UIControlStateNormal];
    [markButton addTarget:self action:@selector(markButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    markButton.accessibilityLabel = NSLocalizedString(@"label_markAsUnread", nil);
    UIBarButtonItem *markBarButton = [[UIBarButtonItem alloc] initWithCustomView:markButton];
    self.navigationItem.rightBarButtonItem = markBarButton;
    
    //NOTIFICATIONS
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endSyncingNotificationHandling:) name:notifSyncFinished object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postUpdatedNotifHandlng:) name:notifFeedUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name: notifContrastModeChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pullToRefreshSynchronize) name: notifSyncNeeded object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//shaking
- (BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
//    CGFloat width = self.buttonAdd.frame.size.width;
//    CAShapeLayer *circleLayer = [CAShapeLayer layer];
//    [circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, width, width)] CGPath]];
//    circleLayer.backgroundColor = [UIColor appBaseColor].CGColor;
//    [self.buttonAdd.layer addSublayer:circleLayer];
    //self.buttonAdd.layer.cornerRadius = (self.buttonAdd.frame.size.height+self.buttonAdd.frame.size.width)/4;
}

- (void)viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
    [self.view bringSubviewToFront:self.buttonAdd];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(appDelegate.lastLoggeduserMail == nil){
        [self reloadTableView];
    }
//    if([self connected] && [SyncSessionManager getCurrentSessionToken]){
//        [SVProgressHUD showWithStatus:@"Synchronizacja"];
////                [self.tableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height) animated:YES];
////                [self.refreshControl beginRefreshing];
//        [SyncSessionManager synchronizeFeeds];
//    }
    
    if(self.lasSelectedIndexPath){
        [self.tableView reloadRowsAtIndexPaths:@[self.lasSelectedIndexPath] withRowAnimation:NO];
        if(self.lasSelectedIndexPath.section==0){
            [self reloadTableView];
        }
        self.lasSelectedIndexPath = nil;
    }
    if(self.topSectionIndexPath){
        [self.tableView reloadRowsAtIndexPaths:@[self.topSectionIndexPath] withRowAnimation:NO];
    }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake){
        // User was shaking the device. Post a notification named "shake."
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shake" object:self];
        [SVProgressHUD show];
        [self pullToRefreshSynchronize];
    }
}

- (void)addFeed:(NSString *)feedUrl{
    if([feedUrl isEqualToString:@""]){
        [RMUniversalAlert showAlertInViewController:self
                                          withTitle:nil
                                            message:@"Podany kanał nie może być pusty. Wpisz adres kanału"
                                  cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                             destructiveButtonTitle:nil
                                  otherButtonTitles:nil
                                           tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       if (buttonIndex==0) {
                                                           [self buttonTapped:nil];
                                                       }
                                                   });
                                           }];
        NSLog(@"String validation : EMPTY");
        return;
    }
    
    [SVProgressHUD show];
    // 1 - prepare url
    NSString *preparedFeedUrl = [UrlStringFormatter makeUrlFormString: feedUrl];
    // 2 - validate url
    if(![self validateUrl:preparedFeedUrl]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        [RMUniversalAlert showAlertInViewController:self
                                          withTitle:nil
                                            message:@"Podany link jest niepoprawny"
                                  cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                             destructiveButtonTitle:nil
                                  otherButtonTitles:nil
                                           tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   if (buttonIndex==0) {
                                                       [self buttonTapped:nil];
                                                   }
                                               });
                                           }];
        NSLog(@"String validation : invalid");
        return;
    }
    // 3 try to make request wiith url and check if response is correct
    MainViewController __weak *weakSelf = self;
    [[ApiClient sharedSingleton] checkFeed:preparedFeedUrl withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        dispatch_async(dispatch_get_main_queue(), ^{
            //zapisz do bazy, odśwież co trzeba
            SaveFeedStatus status = [[CoreDataManager sharedManager] saveFeed: preparedFeedUrl];
            switch (status) {
                case kAlreadyPresent:{
                    [weakSelf showAlertWithTitle:nil  message:NSLocalizedString(@"youHaveFeedSaved", nil) andDelegate:nil];
                    weakSelf.lastEnteredUrl = @"";
                    [SVProgressHUD dismiss];
                    break;
                }
                case kFeedSaved:{
                    [weakSelf showAlertWithTitle:nil  message: NSLocalizedString(@"feedAdded", nil) andDelegate:nil];
                    weakSelf.lastEnteredUrl = @"";
                    //[weakSelf reloadTableView]; -> tableviw będzie przeładowwane gdzy przyjdzie notyfikacja o zakończeniu parsowania postów
                    [weakSelf reloadTableView];
                    [SVProgressHUD dismiss];
                    break;
                }
                case kSavingError:{
                    [weakSelf showAlertWithTitle:nil  message: NSLocalizedString(@"addingFeedFailed", nil) andDelegate:nil];
                    [SVProgressHUD dismiss];
                    break;
                }
                    
                default:
                    break;
            }
            
        });
        
    } failure:^(NSError *error) {
        [self showAlertWithTitle: NSLocalizedString(@"feedNotExist", nil)  message:nil andDelegate:nil];
        NSLog(@"Feed is invalid");
        [SVProgressHUD dismiss];
    }];
    
}

- (BOOL) validateUrl: (NSString *) candidate {
//    NSString *urlRegEx = @"@^(https|http)://[^\s/$.?#].[^\s]*$@iS";
//    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
//    return [urlTest evaluateWithObject:candidate];
    
    //candidate always contains http:// and /feed because of "prepareUrl" method
    if(![candidate containsString:@"."]){
        return NO;
    }
    return YES;
}

- (IBAction)buttonTapped:(id)sender {
    [self doAlertViewWithTextView];
}

- (void) doAlertViewWithTextView {
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:NSLocalizedString(@"addChanel", nil)
                               message:NSLocalizedString(@"typeFeedUrl", nil)
                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    UIAlertAction* dodaj = [UIAlertAction actionWithTitle:NSLocalizedString(@"add", nil) style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){
                                                   //Do Some action here
                                                   UITextField *textField = alert.textFields[0];
                                                   self.lastEnteredUrl = textField.text;
                                                   [self addFeed: textField.text];
                                               }];
    
    [alert addAction:cancel];
    [alert addAction:dodaj];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"samplefeedpl", nil);
        textField.text = (self.lastEnteredUrl) ? self.lastEnteredUrl : @"";
        textField.keyboardType = UIKeyboardTypeDefault;
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)pullToRefreshSynchronize{
    NSArray *feeds = [[CoreDataManager sharedManager]getAllActiveFeeds];
//    if(feeds.count == 0){
//        [self reloadTableView];
//        return;
//    }
    
    if([self connected]){
        if([SyncSessionManager getCurrentSessionToken]){
            [SyncSessionManager synchronizeFeeds];
        }else{
            [self updatePostsForAllFeeds];
            
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:hShowSyncRegisterInfo]){
                [RMUniversalAlert showAlertInViewController:self
                                                  withTitle:NSLocalizedString(@"Info", nil)
                                                    message:NSLocalizedString(@"setUpaAccountToSyncData", nil)
                                          cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:nil
                                                   tapBlock:^(RMUniversalAlert *alert, NSInteger buttonIndex){
                                                       if (buttonIndex == alert.cancelButtonIndex) {
                                                           NSLog(@"ok Tapped");
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               [[NSUserDefaults standardUserDefaults] setBool:NO forKey:hShowSyncRegisterInfo];
                                                               [[NSUserDefaults standardUserDefaults] synchronize];
                                                           });
                                                       }
                                                   }];
            }
        }
    }else{
        [self showAlertWithTitle:NSLocalizedString(@"Info", nil) message: NSLocalizedString(@"noInternetCantSync", nil) andDelegate:nil];
    }
}

//NOTIF HANDLING

- (void)endSyncingNotificationHandling:(NSNotification*)notif{
    NSString *status = notif.object;
    dispatch_async(dispatch_get_main_queue(),^{
        if([status isEqualToString:kSuccess]){
            self.notifCountExpiredToken = 0;
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:[[CoreDataManager sharedManager] getAllActiveFeeds]];
            if(self.dataSource.count==0){
                [self endRefreshing];
            }else{
                [self updatePostsForAllFeeds];
            }
        }
        else if([status isEqualToString:kFail]){
            self.notifCountExpiredToken = 0;
            [self.refreshControl endRefreshing];
            [SVProgressHUD dismiss];
            [self showAlertWithTitle:nil message: NSLocalizedString(@"suncFailed", nil) andDelegate:nil];
        }
        else if([status isEqualToString:kFailTokenExpired]){
            //try to login internally but only once
            
            if(self.notifCountExpiredToken >1){
                [self.refreshControl endRefreshing];
                [SVProgressHUD dismiss];
                [self showAlertWithTitle:nil message: NSLocalizedString(@"suncFailedHaveToLogin", nil) andDelegate:nil];
            }else{
                self.notifCountExpiredToken += 1;
                [self loginInternally];
            }
        }
    });
}

- (void)postUpdatedNotifHandlng:(NSNotification*)notif{
    if(self.isBatchPostUpdatePerfomed){
        self.feedsPostsParsed +=1;
        if(self.feedsPostsParsed == (int)self.dataSource.count){
            dispatch_async(dispatch_get_main_queue(),^{
                [self endRefreshing];
                self.isBatchPostUpdatePerfomed = NO;
                self.feedsPostsParsed = 0;
                NSLog(@"Podjęto próbę sparsowania wszystkich postow dla wszystkich feedow");
                [self reloadTableView];
            });
        }
    }else{
        NSLog (@"Pojedynczy kanał sparsowany");
        [self reloadTableView];
        //TODO syn1 update only recently added post
    }
}

- (void)updatePostsForAllFeeds{
    if(self.isBatchPostUpdatePerfomed){
        return;
    }else{
        self.feedsPostsParsed = 0;
        self.isBatchPostUpdatePerfomed = YES;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isBatchPostUpdatePerfomed = YES;
        //TODO syn1 w inny sposób niż z core data podać źródło danych, może z vc?
        NSArray *feeds = [[CoreDataManager sharedManager]getAllActiveFeeds];
        for(Feed *f in feeds){
            [[ApiClient sharedSingleton] getDataForFeed: f.url withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                [Parser parseData:responseObject forFeed:f];
            } failure:^(NSError *error) {
                NSLog(@"Getting data for feed postsfailed - MAIN VC");
            }];
        }
    });
}

- (void)endRefreshing{
    [self.refreshControl endRefreshing];
    [SVProgressHUD dismiss];
}

- (void)loginInternally{
    MainViewController __weak *weakself = self;
    NSString *username = [UserData getCurrentLoggedUserMail];
    NSString *password = ([UserData getUserDataForEmail:[UserData getCurrentLoggedUserMail]]).password;
    [[ApiClient sharedSingleton] loginUserWithName:username Pawssword:password andTokern:[SyncSessionManager getCurrentSessionToken] withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(),^{
            [SyncSessionManager synchronizeFeeds];
        });
    } failure:^(NSError *error) {
        if([error.localizedDescription containsString:@"401"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [weakself showAlertWithTitle:NSLocalizedString(@"Info", nil) message:NSLocalizedString(@"invalidCreditionals", nil) andDelegate:nil];
            });
        }
        if([error.localizedDescription containsString:@"500"]){
            [SVProgressHUD dismiss];
            [weakself showAlertWithTitle:NSLocalizedString(@"Info", nil) message:NSLocalizedString(@"loginAndSyncFailed", nil) andDelegate:nil];
        }else{
            [SVProgressHUD dismiss];
            [weakself showAlertWithTitle:NSLocalizedString(@"Info", nil) message:NSLocalizedString(@"loginAndSyncFailedUnnownError", nil) andDelegate:nil];
        }
    }];
}

- (void)reloadTableView{
    NSLog(@"\n\n****************\n updateDataSource\n***************");
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:[[CoreDataManager sharedManager] getAllActiveFeeds]];
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
    
}

#pragma  mark - TableViewDataSource Methods

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
    if(section==0){
        return 1;
    }
    else{
        return self.dataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FeedTableViewCell *cell = (FeedTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:kFeedCellIdentifier forIndexPath:indexPath];
    if (cell == nil)  {
        cell = [FeedTableViewCell cellFromNib];
    }
    if(indexPath.section == 0){
        self.topSectionIndexPath = indexPath;
        cell.nameLabel.text = NSLocalizedString(@"allPosts", nil);
        NSInteger unread = [[CoreDataManager sharedManager] getNumberOfUnreadPosts];
        if(unread>0){
            cell.countLabel.text = [NSString stringWithFormat:@"%ld", unread];
        }else{
            cell.countLabel.text= @"";
        }
        return cell;
    }
    
    Feed *feed = ((Feed*)[self.dataSource objectAtIndex:indexPath.row]);
    cell.nameLabel.text = [UrlStringFormatter makePreetyUrlName:feed.url];
    NSInteger unread = [feed getNumberOfUnreadPosts];
    if(unread>99){
        cell.countLabel.text = @"99+";
//        cell.countLabel.font = [UIFont boldSystemFontOfSize:11];
    }else{
        cell.countLabel.text = (unread == 0) ? @" " : [NSString stringWithFormat:@"%ld", unread];
        cell.countLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    
    [cell layoutSubviews];
    [cell layoutIfNeeded];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==1){
        return YES;
    }else{
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Mark object as deleted in database
        BOOL isMarked = [[CoreDataManager sharedManager] deleteFeed:(Feed*)self.dataSource[indexPath.row]];
        if (!isMarked) {
            [self showAlertWithTitle:nil message:NSLocalizedString(@"deletingChanelFailed", nil) andDelegate:nil];
            NSLog(@"Can't Delete feed from Core Data");
        }else{
            [self showAlertWithTitle:nil message:NSLocalizedString(@"chanelDeleted", nil)  andDelegate:nil];
        }
        // Remove feed from table view
        //TODO deleting
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma  mark - TableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PostsListViewController *vc = [[PostsListViewController alloc] init];
    if(indexPath.section==0){
        self.lasSelectedIndexPath = indexPath;
        vc.isAllUnreadView = YES;
    }else{
        vc.isAllUnreadView = NO;
        self.lasSelectedIndexPath = indexPath;
        vc.feed = (Feed *)self.dataSource[indexPath.row];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    return ((font.lineHeight +10)<50) ? 50 : (font.lineHeight +10);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 20)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

#pragma  mark - User Actions

- (void)settingsButtonTapped:(id)sender{
    SettingsViewController *vc = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)userSettingsButtonTapped:(id)sender{
    SettingsViewController *vc = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    return;
}

- (void)markButtonTapped:(id)sender{
    NSArray *markOptions =@[NSLocalizedString(@"oneDay", nil),
                            NSLocalizedString(@"3days", nil),
                            NSLocalizedString(@"week", nil)
                            ];
    
    [RMUniversalAlert showActionSheetInViewController:self
                                            withTitle:nil
                                              message:NSLocalizedString(@"markAsReadedOlderThan", nil)
                                    cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                               destructiveButtonTitle:NSLocalizedString(@"all", nil)
                                    otherButtonTitles:markOptions
                   popoverPresentationControllerBlock:^(RMPopoverPresentationController *popover){
                       popover.sourceView = self.view;
                       popover.sourceRect = ((UIButton*)sender).frame;
                   }
                                             tapBlock:^(RMUniversalAlert *alert, NSInteger buttonIndex){
                                                 if (buttonIndex == alert.cancelButtonIndex) {
                                                     NSLog(@"Cancel Tapped");
                                                 } else if (buttonIndex == alert.destructiveButtonIndex) {
                                                     NSLog(@"Delete Tapped");
                                                 } else if (buttonIndex >= alert.firstOtherButtonIndex) {
                                                     NSLog(@"Other Button Index %ld", (long)buttonIndex - alert.firstOtherButtonIndex);
                                                     long index = (long)buttonIndex - alert.firstOtherButtonIndex;
                                                     switch (index) {
                                                         case 0:
                                                             [[CoreDataManager sharedManager] markAsReadNumberOfDays:1];
                                                             [self reloadTableView];
                                                             break;
                                                         case 1:
                                                             [[CoreDataManager sharedManager] markAsReadNumberOfDays:3];
                                                             [self reloadTableView];
                                                             break;
                                                         case 2:
                                                             [[CoreDataManager sharedManager] markAsReadNumberOfDays:7];
                                                             [self reloadTableView];
                                                             break;
                                                             
                                                         default:
                                                             break;
                                                     }
                                                 }
                                             }];
}



@end
