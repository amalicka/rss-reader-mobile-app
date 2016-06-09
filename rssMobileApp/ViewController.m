//
//  ViewController.m
//  rssMobileApp
//
//  Created by Ola Skierbiszewska on 14.02.2016.
//  Copyright © 2016 Ola Skierbiszewska. All rights reserved.
//

#import "ViewController.h"
#import "ApiClient.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonTapped:(id)sender {
    [[ApiClient sharedSingleton] syncFeeds:@{} withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success app delgate");
    } failure:^(NSError *error) {
        NSLog(@"Failure app delgate");
    }];
}
@end
