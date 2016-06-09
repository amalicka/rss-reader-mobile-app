//
//  FeedTableViewCell.m
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import "FeedTableViewCell.h"
#import "UIColor+rss.h"
#import "StringConstans.h"

@implementation FeedTableViewCell

+ (FeedTableViewCell *)cellFromNib {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    FeedTableViewCell *customCell = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[FeedTableViewCell class]]) {
            customCell = (FeedTableViewCell *)nibItem;
            break; // we have a winner
        }
    }
    return customCell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if(self){
        [self defaultSetup];
    }
}

- (void)defaultSetup{
    self.countLabel.layer.masksToBounds = YES;
    self.countLabel.layer.cornerRadius =5;
    self.countLabel.backgroundColor = [UIColor appBaseColor];
    self.countLabel.layer.borderColor = [UIColor appBaseColor].CGColor;
    self.countLabel.layer.borderWidth = 1.0;
    self.countLabel.textColor = [UIColor whiteColor];
    self.constraintCountLabelWidth.constant = 29;
    self.constraintCountLabelHeight.constant = 29;
//    self.countLabel.font = [UIFont boldSystemFontOfSize:12];
//    self.nameLabel.font = [UIFont boldSystemFontOfSize:18];
    [self fontSizeSetup];
}

- (void)heightContrastSetup{
    self.countLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.countLabel.layer.borderWidth = 1.0;
    self.countLabel.backgroundColor = [UIColor whiteColor];
    self.countLabel.textColor = [UIColor blackColor];
    self.constraintCountLabelWidth.constant = 40;
    self.constraintCountLabelHeight.constant = 40;
    [self fontSizeSetup];
}

- (void)fontSizeSetup{
    if([UIFont preferredFontForTextStyle:UIFontTextStyleBody].lineHeight < 35){
        self.countLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    }else{
        self.countLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    self.nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.constraintNameLabelHeight.constant = [UIFont preferredFontForTextStyle:UIFontTextStyleBody].lineHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)prepareForReuse{
    [super prepareForReuse];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if([[NSUserDefaults standardUserDefaults] boolForKey:hIsHeighContrastMode] == YES){
        [self heightContrastSetup];
    }else{
        [self defaultSetup];
    }
}

@end
