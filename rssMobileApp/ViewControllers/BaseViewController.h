//
//  BaseViewController.h
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+UtilsAdds.h"
#import "CoreDataManager.h"
#import "Utils.h"
#import "Feed+CoreDataProperties.h"
#import "Feed.h"
#import "ApiClient.h"
#import "Parser.h"
#import "SVProgressHUD.h"
#import "SyncSessionManager.h"
#import "UrlStringFormatter.h"
#import "UIImage+Color.h"
#import "RMUniversalAlert.h"
#import "StringConstans.h"
#import "UIColor+rss.h"
#import "UserData.h"
#import "AppDelegate.h"
#import "UIButton+rssApp.h"

@interface BaseViewController : UIViewController

@property (nonatomic,strong) UIBarButtonItem *customBackButton;

-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message andDelegate:(id)delegate;

- (BOOL)connected;

@end
