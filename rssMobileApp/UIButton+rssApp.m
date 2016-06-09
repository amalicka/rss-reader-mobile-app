//
//  UIButton+rssApp.m
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import "UIButton+rssApp.h"

@implementation UIButton (rssApp)

- (void)setTitle:(NSString *)title{
    NSString *t = [title lowercaseString];
    [self setTitle:t forState:UIControlStateNormal];
    [self setTitle:t forState:UIControlStateHighlighted];
    [self setTitle:t forState:UIControlStateSelected];
}

@end
