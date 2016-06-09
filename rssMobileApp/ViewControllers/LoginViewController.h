//
//  LoginViewController.h
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController <UITextFieldDelegate>

//LABELS
@property (weak, nonatomic) IBOutlet UILabel *labTitle;

//text fields
@property (weak, nonatomic) IBOutlet UITextField *tFieldLogin;
@property (weak, nonatomic) IBOutlet UITextField *tFieldPassword;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;

//button

@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;


//constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintElementsWidth;

@end
