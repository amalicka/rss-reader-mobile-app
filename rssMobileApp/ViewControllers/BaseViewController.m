//
//  BaseViewController.m
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import "BaseViewController.h"
#import "MainViewController.h"
#import "LoginViewController.h"
#import "RegistrationViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor]; // background color NAVBAR (WITHOUT STATUS BAR)
    self.navigationController.navigationBar.tintColor =  [UIColor appBaseColor];//[UIColor yellowColor]; //system buttons color
    self.navigationController.navigationBar.barTintColor = [UIColor appNavbarColor]; // background color NAVBAR + STATUS BAR
  
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    self.navigationController.navigationBar.translucent = NO;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 1)];
    [line setBackgroundColor:[UIColor appNavbarBottomLine]];
    [self.navigationController.navigationBar addSubview:line];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

//    if([[self class] isEqual:[LoginViewController class]]){
//        self.navigationController.navigationBarHidden = YES;
//    }else{
        self.navigationController.navigationBarHidden = NO;
    //}
    
    if(![[self class] isEqual:[MainViewController class]]){
        UIButton *backView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
        UIImage *mageBack = [UIImage imageNamed:@"ic_back_blue"];
        [backView setTitleColor:[UIColor appBaseColor] forState:UIControlStateNormal];
        [backView setImage:mageBack forState:UIControlStateNormal];
        UIFont *font =[UIFont systemFontOfSize:16];
        [[backView titleLabel] setFont: font];
        [backView setTitle:@"" forState:UIControlStateNormal];
        [backView setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [backView addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
        backView.accessibilityLabel = NSLocalizedString(@"label_back", nil);
        self.customBackButton = [[UIBarButtonItem alloc] initWithCustomView:backView];
        
        [[self navigationItem] setLeftBarButtonItem:self.customBackButton];
    }else{
        self.navigationItem.hidesBackButton = YES;
    }
}

- (void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message andDelegate:(id)delegate{
    [RMUniversalAlert showAlertInViewController:self
                                      withTitle:title
                                        message:message
                              cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                         destructiveButtonTitle:nil
                              otherButtonTitles:nil
                                       tapBlock:^(RMUniversalAlert *alert, NSInteger buttonIndex){
                                       }];
}

- (BOOL)connected{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

@end
