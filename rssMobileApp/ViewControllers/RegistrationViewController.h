//
//  RegistrationViewController.h
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import "BaseViewController.h"

@interface RegistrationViewController : BaseViewController <UITextFieldDelegate>


//labels
@property (weak, nonatomic) IBOutlet UILabel *registrationLabel;


//text fields
@property (weak, nonatomic) IBOutlet UITextField *textFieldNick;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldRepeatPassword;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;

//constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintNameTextFieldWidth;

@end
