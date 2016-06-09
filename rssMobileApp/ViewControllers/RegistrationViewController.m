//
//  RegistrationViewController.m
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import "RegistrationViewController.h"
#import "MainViewController.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"registerScreen", nil);
    self.registrationLabel.textColor = [UIColor appBaseColor];
    self.registerButton.layer.cornerRadius = 8;
    self.registerButton.layer.borderWidth = 2;
    self.registerButton.layer.borderColor = [UIColor appBaseColor].CGColor;
    self.registerButton.backgroundColor = [UIColor appBaseColor];
    [self.registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.registerButton setTitle: NSLocalizedString(@"register", nil)];
    
    [self.textFieldNick setPlaceholder: [NSLocalizedString(@"loginNoun", nil) lowercaseString]];
    [self.textFieldPassword setPlaceholder: [NSLocalizedString(@"password", nil) lowercaseString]];
    [self.textFieldRepeatPassword setPlaceholder: [NSLocalizedString(@"passwordRepeat", nil) lowercaseString]];
    
    NSArray *fields = @[self.textFieldNick, self.textFieldPassword, self.textFieldRepeatPassword];
    for(UITextField *field in fields){
        field.delegate = self;
        //field.text = @"user77";
    }
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
        self.constraintNameTextFieldWidth.constant = 260;
    }
}

- (IBAction)registerButtonTapped:(id)sender {
    if(![self validateFieldsAndShowAlert]){
        return;
    }
    [SVProgressHUD showWithStatus:NSLocalizedString(@"registration", nil)];
    RegistrationViewController __weak *weakself = self;
    [[ApiClient sharedSingleton] registerUserWithName:self.textFieldNick.text andPawssword:self.textFieldPassword.text withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //[weakself showAlertWithTitle:@"Informacja" message:@"Rejestracja powiodła się" andDelegate:nil];
        dispatch_async(dispatch_get_main_queue(),^{
            [SVProgressHUD dismiss];
            [weakself.navigationController popToRootViewControllerAnimated:YES];
        });
        
    } failure:^(NSError *error) {
        if([error.localizedDescription containsString:@"401"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [weakself showAlertWithTitle:NSLocalizedString(@"Info", nil)
                                     message:NSLocalizedString(@"userNameNotAvailable", nil) andDelegate:nil];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [weakself showAlertWithTitle:NSLocalizedString(@"Info", nil) message:NSLocalizedString(@"registrationFailed", nil) andDelegate:nil];
            });
        }

    }];
}

#pragma mark - text field delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if([textField isEqual:self.textFieldRepeatPassword]){
        [self checkIfPassworsVaryAndShowAlert];
    }
}

- (BOOL)validateFieldsAndShowAlert{
    if([self.textFieldNick.text isEqualToString:@""] || [self.textFieldPassword.text isEqualToString:@""] || [self.textFieldRepeatPassword.text isEqualToString:@""]){
        [self showAlertWithTitle:NSLocalizedString(@"Warning", nil) message:NSLocalizedString(@"fillAllFields", nil) andDelegate:nil];
        return NO;
    }
    if([self checkIfPassworsVaryAndShowAlert]){
        return NO;
    }
    return YES;
}

- (BOOL)checkIfPassworsVaryAndShowAlert{
    if(![self.textFieldPassword.text isEqualToString:self.textFieldRepeatPassword.text]){
        [self showAlertWithTitle:NSLocalizedString(@"Warning", nil) message:NSLocalizedString(@"passwordsNotTheSame", nil) andDelegate:nil];
        return YES;
    }else{
        return NO;
    }
}

@end
