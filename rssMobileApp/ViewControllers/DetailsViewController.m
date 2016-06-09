//
//  DetailsViewController.m
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import "DetailsViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "DTHTMLAttributedStringBuilder.h"
#import "DTLinkButton.h"

@interface DetailsViewController ()
@property (nonatomic, strong) UIFont *fontDescription;
@property (nonatomic, strong) UIButton *changeDisplayButton;
@property (atomic) BOOL isFullWebView;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = self.post.title;
    self.dateLabel.text = [self.post getPublicationDate];
    self.postTextView.text = [NSString stringWithFormat:@"%@", self.post.post_description ];
    self.titleLabel.numberOfLines = 0;
    self.fontDescription = [UIFont systemFontOfSize:13.0];
    self.postTextView.contentInset = UIEdgeInsetsMake(0,-4,0,4);
    
    self.postTextView.font = self.fontDescription;
    self.postTextView.delegate = self;
    self.webView.delegate = self;
    [self.webView sizeToFit];
    self.webView.scalesPageToFit = YES;
    self.isFullWebView = YES;
    
    
    self.changeDisplayButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,40,40)];
    [self.changeDisplayButton setImage:[UIImage imageNamed:@"ic_post_readability"] forState: UIControlStateNormal];
    [self.changeDisplayButton addTarget:self action:@selector(webPageModeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.changeDisplayButton.accessibilityLabel = NSLocalizedString(@"label_showReadability", nil);
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:self.changeDisplayButton];
    self.navigationItem.rightBarButtonItem = barButton;
    
    self.postTextView.scrollEnabled = NO;
    [self showContent];
    self.webView.accessibilityLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    
//    NSData *htmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.post.link]];
//    
//    // Set our builder to use the default native font face and size
//    NSDictionary *builderOptions = @{
//                                     DTDefaultFontFamily: @"Helvetica"
//                                     };
//
//    DTHTMLAttributedStringBuilder *stringBuilder = [[DTHTMLAttributedStringBuilder alloc] initWithHTML:htmlData
//                                                                                               options:builderOptions
//                                                                                    documentAttributes:nil];
//    
//    self.scrollView.attributedString = [stringBuilder generatedAttributedString];
//    // Assign our delegate, this is required to handle link events
//    self.scrollView.textDelegate = self;
//    self.scrollView.contentInset = UIEdgeInsetsMake(8, 8, 8, 8);
//    self.postTextView.backgroundColor = [UIColor clearColor];
}

- (void)textViewDidChange:(UITextView *)textView{
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGFloat labelHeight = [Utils heightForLabelWithWidth:SCREEN_WIDTH -16 andFont:self.titleLabel.font andText:self.post.title];
    self.constraintTitleHeight.constant = (labelHeight>21.0)?42:21;
    
    //RESIZE TEXT AREA
    CGFloat fixedWidth = self.postTextView.frame.size.width;
    CGSize newSize = [self.postTextView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = self.postTextView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    self.constraintTextArea.constant = newFrame.size.height;
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DTAttributedTextContentViewDelegate
//
//- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView
//                          viewForLink:(NSURL *)url
//                           identifier:(NSString *)identifier
//                                frame:(CGRect)frame
//{
//    DTLinkButton *linkButton = [[DTLinkButton alloc] initWithFrame:frame];
//    linkButton.URL = url;
//    [linkButton addTarget:self action:@selector(linkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    
//    return linkButton;
//}
//
//- (void)linkButtonClicked:(id)sender{
//    
//}


#pragma mark - User actions

- (void)webPageModeButtonTapped{
    if(([[NSUserDefaults standardUserDefaults] boolForKey:hIsReadabilityModeSelected] == NO)){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:hIsReadabilityModeSelected];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:hIsReadabilityModeSelected];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self showContent];
}


- (void)showContent{
    NSURL *urlRequest;
    if(([[NSUserDefaults standardUserDefaults] boolForKey:hIsReadabilityModeSelected] == YES)){
        urlRequest = [[NSURL alloc] initWithString: self.post.link];
        [self.changeDisplayButton setImage:[UIImage imageNamed:@"ic_post_readability"] forState: UIControlStateNormal];
        self.changeDisplayButton.accessibilityLabel = NSLocalizedString(@"label_showReadability", nil);
    }else{
        urlRequest = [[NSURL alloc] initWithString: [NSString stringWithFormat:@"http://www.readability.com/m?url=%@", self.post.link]];
        [self.changeDisplayButton setImage:[UIImage imageNamed:@"ic_post_full_web"] forState: UIControlStateNormal];
        self.changeDisplayButton.accessibilityLabel = NSLocalizedString(@"label_showWebView", nil);
        
    }
    NSURLRequest *request = [NSURLRequest requestWithURL: urlRequest];
    [SVProgressHUD show];
    [self.webView loadRequest:request];
}

#pragma mark UIWebView delegate methods
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD dismiss];
    NSLog(@"could not load the website caused by error: %@", error);
    
    NSLog(@"Connection failed! Errooooooor - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    UIAlertController *connectionAlert = [UIAlertController
                                          alertControllerWithTitle:NSLocalizedString(@"sthWentWrong", nil)
                                          message:[error localizedDescription]
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okeyAction = [UIAlertAction
                                 actionWithTitle:NSLocalizedString(@"tryAgain", nil)
                                 style:UIAlertActionStyleDefault
                                 handler: ^(UIAlertAction *action){
                                     [self showContent];
                                 }];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"cancel", nil)
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action){
                                       [self.navigationController popViewControllerAnimated:YES];
                                   }];
    
    [connectionAlert addAction:cancelAction];
    [connectionAlert addAction:okeyAction];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"shouldStartLoadWithRequest: %@", [[request URL] absoluteString]);
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
    NSLog(@"webViewDidFinishLoad");
}

@end
