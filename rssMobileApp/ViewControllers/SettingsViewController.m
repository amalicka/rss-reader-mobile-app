//
//  SettingsViewController.m
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import "SettingsViewController.h"
#import "LoginViewController.h"
#import "RegistrationViewController.h"

CGFloat const loginLogoutIndex = 0;
CGFloat const registerIndex = 1;
CGFloat const heightContrastModeIndex = 2;
CGFloat const tutorialIndex = 4;

@interface SettingsViewController ()

@property (nonatomic, strong) UISwitch *switchContrastMode;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"settings", nil);
    
    //[SVProgressHUD show];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"settingsCell"];
    
    self.switchContrastMode = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.switchContrastMode addTarget:self action:@selector(switchToggled:) forControlEvents: UIControlEventValueChanged];
    if([[NSUserDefaults standardUserDefaults] boolForKey:hIsHeighContrastMode] == YES){
        [self.switchContrastMode setOn:YES animated:YES];
    }else{
        [self.switchContrastMode setOn:NO animated:YES];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma  mark - TableView
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"settingsCell" forIndexPath:indexPath];
    
    if(indexPath.row == loginLogoutIndex){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if([SyncSessionManager getCurrentSessionToken]){
            cell.textLabel.text = NSLocalizedString(@"logout", nil);
        }else{
            cell.textLabel.text = NSLocalizedString(@"login", nil);
        }
    }
    else if(indexPath.row == registerIndex){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = NSLocalizedString(@"register", nil);
    }
    else if(indexPath.row == heightContrastModeIndex){
        cell.accessoryView = self.switchContrastMode;
        cell.textLabel.text = NSLocalizedString(@"blackWhuteStyle", nil);
    }else if(indexPath.row == tutorialIndex){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8,8,SCREEN_WIDTH-16, 70)];
        label.text = NSLocalizedString(@"syncTutorial", nil);
        label.font = [UIFont systemFontOfSize:13];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        [cell addSubview:label];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma  mark - TableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == loginLogoutIndex){
        if([SyncSessionManager getCurrentSessionToken]){
            //AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            //if(appDelegate.lastLoggeduserMail != nil){
                [self handleLogout];
            //}
        }else{
            LoginViewController *vc = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if(indexPath.row == registerIndex){
        RegistrationViewController *vc = [[RegistrationViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.row == heightContrastModeIndex){
        [self updateSwitchAtIndexPath:indexPath];
    }
}

- (void)handleLogout{
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:NSLocalizedString(@"logoutQuestion", nil)
                               message:nil
                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil)style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    SettingsViewController __weak *weakself = self;
    UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"logout", nil)style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       [SyncSessionManager handleLogout];
                                                       // post notification to Main Vc to reload
                                                       [weakself.navigationController popToRootViewControllerAnimated:YES];
                                                       
                                                   });
                                               }];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)updateSwitchAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (void) switchToggled:(id)sender {
    UISwitch *mySwitch = (UISwitch *)sender;
    if ([mySwitch isOn]) {
        NSLog(@"its on!");
        [self.switchContrastMode setOn:YES animated:YES];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:hIsHeighContrastMode];
    } else {
        NSLog(@"its off!");
        [self.switchContrastMode setOn:NO animated:YES];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:hIsHeighContrastMode];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:notifContrastModeChanged object:nil];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == tutorialIndex){
        return 80;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}



@end
