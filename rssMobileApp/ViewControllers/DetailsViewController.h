//  DetailsViewController.h
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import "BaseViewController.h"
#import "Post+CoreDataProperties.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "DTAttributedTextView.h"

@interface DetailsViewController : BaseViewController <UIWebViewDelegate, UITextViewDelegate, DTAttributedTextContentViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet DTAttributedTextView *scrollView;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UITextView *postTextView;



@property (strong, nonatomic) NSString *link;
@property (nonatomic, strong) Post *post;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintTitleHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintTextArea;


@end
