//
//  LoginViewController.m
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "RegistrationViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title  = NSLocalizedString(@"loginScreen", nil);
    self.labTitle.textColor = [UIColor appBaseColor];
    
    
    self.buttonLogin.layer.cornerRadius =8;
    self.buttonLogin.layer.borderWidth = 2;
    self.buttonLogin.layer.borderColor = [UIColor appBaseColor].CGColor;
    self.buttonLogin.backgroundColor = [UIColor appBaseColor];
    [self.buttonLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.buttonLogin setTitle: NSLocalizedString(@"login", nil)];
    
    self.registerButton.layer.cornerRadius = 8;
    self.registerButton.layer.borderWidth = 2;
    self.registerButton.layer.borderColor = [UIColor appBaseColor].CGColor;
    [self.registerButton setTitleColor:[UIColor appBaseColor] forState:UIControlStateNormal];
    [self.registerButton setTitleColor:[UIColor appBaseColor] forState:UIControlStateHighlighted];
    [self.registerButton setTitle: NSLocalizedString(@"register", nil)];
    
    [self.tFieldLogin setPlaceholder: [NSLocalizedString(@"login", nil) lowercaseString]];
    [self.tFieldPassword setPlaceholder: [NSLocalizedString(@"password", nil) lowercaseString]];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if(IS_IPHONE_4_OR_LESS || IS_IPHONE_5){
        self.constraintElementsWidth.constant = 260;
    }
}

- (IBAction)buttonLoginTapped:(id)sender {
    if(![self validateFieldsAndShowAlert]){
        return;
    }
    [SVProgressHUD showWithStatus:NSLocalizedString(@"loginScreen", nil)];
    LoginViewController __weak *weakself = self;
    [[ApiClient sharedSingleton] loginUserWithName:self.tFieldLogin.text Pawssword:self.tFieldPassword.text andTokern:[SyncSessionManager getCurrentSessionToken] withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(),^{
            [SVProgressHUD dismiss];
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            appDelegate.lastLoggeduserMail = weakself.tFieldLogin.text;
            
            UserData *user = [[UserData alloc] init];
            user.name = weakself.tFieldLogin.text;
            user.password = weakself.tFieldPassword.text;
            [UserData setSharedUserDataWithUserData:user];
            [user saveUserToKeychain];
            
//            MainViewController *vc = [[MainViewController alloc] init];
//            [weakself.navigationController pushViewController:vc animated:YES];
            [weakself.navigationController popToRootViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        if([error.localizedDescription containsString:@"401"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [weakself showAlertWithTitle:NSLocalizedString(@"Info", nil) message:NSLocalizedString(@"invalidCreditionals", nil)andDelegate:nil];
            });
        }
        else if([error.localizedDescription containsString:@"500"]){
            [SVProgressHUD dismiss];
            [weakself showAlertWithTitle:NSLocalizedString(@"Info", nil) message: NSLocalizedString(@"loginFailedServerError", nil) andDelegate:nil];
        }else{
            [SVProgressHUD dismiss];
            [weakself showAlertWithTitle:NSLocalizedString(@"Info", nil) message: NSLocalizedString(@"loginFailedUnnownServerAddress", nil) andDelegate:nil];
        }
    }];
}

- (IBAction)registerButtonTapped:(id)sender {
    
    RegistrationViewController *vc = [[RegistrationViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - text field delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
}

- (BOOL)validateFieldsAndShowAlert{
    if([self.tFieldLogin.text isEqualToString:@""] || [self.tFieldPassword.text isEqualToString:@""]){
        [self showAlertWithTitle:NSLocalizedString(@"Warning", nil) message:NSLocalizedString(@"fillAllFields", nil) andDelegate:nil];
        return NO;
    }
    return YES;
}

@end
