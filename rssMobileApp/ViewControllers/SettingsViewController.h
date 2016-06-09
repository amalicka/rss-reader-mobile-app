//
//  SettingsViewController.h
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import "BaseViewController.h"
#import "TPKeyboardAvoidingTableView.h"

@interface SettingsViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;

@end
