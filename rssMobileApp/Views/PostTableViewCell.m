//
//  PostTableViewCell.m
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import "PostTableViewCell.h"
#import "Utils.h"

@implementation PostTableViewCell

+ (PostTableViewCell *)cellFromNib {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    PostTableViewCell *customCell = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[PostTableViewCell class]]) {
            customCell = (PostTableViewCell *)nibItem;
            break; // we have a winner
        }
    }
    return customCell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if(self){
        [self.readButton setImage:[UIImage imageNamed:@"ic_checkbox_fill"] forState:UIControlStateNormal];
        self.readButton.titleLabel.text = @"";
        [self.readButton setTitle:@"" forState:UIControlStateNormal];
        self.dateLabel.text = @"";
        UIImage *image = [UIImage imageNamed:@"ic_arrow_right_grey"];
        UIImageView *arrow = [[UIImageView alloc]initWithImage:image];
        arrow.frame = CGRectMake(self.dateWidth.constant+4, 4, image.size.width, image.size.height);
        [self.dateLabel addSubview:arrow];
        self.postTitleLabel.numberOfLines = 0;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.readButton.titleLabel.text = @"";
    [self.readButton setTitle:@"" forState:UIControlStateNormal];
    [self.readButton setImage:[UIImage imageNamed:@"ic_checkbox_fill"] forState:UIControlStateNormal];
    self.postTitleLabel.text = @"";
    self.otehrLabel.text = @"";
    self.dateLabel.text = @"";
    self.constraintDesriptionHeight.constant = 60;
    self.constraintTitleHeight.constant = 21;
}

- (void)layoutSubviews{
//    self.readButton.titleLabel.text = @"";
//    [self.readButton setTitle:@"" forState:UIControlStateNormal];
    if([self.post.is_read isEqual:[NSNumber numberWithBool:YES]]){
        //[self.readButton setImage:[UIImage imageNamed:@"ic_checkbox_fill"] forState:UIControlStateNormal];
        [self.readButton setImage:nil forState:UIControlStateNormal];
        self.readButton.titleLabel.text = @"";
        self.postTitleLabel.textColor = [UIColor lightGrayColor];
        self.otehrLabel.textColor = [UIColor lightGrayColor];
        self.readButton.accessibilityLabel = NSLocalizedString(@"label_postRead", nil);
    }else{
        [self.readButton setImage:[UIImage imageNamed:@"ic_post_unread"] forState:UIControlStateNormal];
        self.postTitleLabel.textColor = [UIColor blackColor];
        self.otehrLabel.textColor = [UIColor blackColor];
        self.readButton.accessibilityLabel = NSLocalizedString(@"label_postRead", nil);
    }
    //height
    
    CGFloat titleHeight = [Utils heightForLabelWithWidth:self.postTitleLabel.frame.size.width +30
                                                  andFont:self.postTitleLabel.font
                                                  andText:self.post.title];
    NSLog(@"%f", titleHeight);
//    if(titleHeight>21){
//        self.constraintTitleHeight.constant = 50;
//    }
    
    //description
    if([self.post.post_description isEqualToString: @""]){
        self.constraintDesriptionHeight.constant = 0;
    }else{
        self.constraintDesriptionHeight.constant = 60;
    }
    
    self.dateLabel.text = [self.post getPublicationDate];
    
}
- (IBAction)readButtonTapped:(id)sender {
    if(self.delegate) {
        if ([self.delegate respondsToSelector:@selector(detailsButtonTapped:)]) {
            [self.delegate detailsButtonTapped:self];
        }
    }
}

@end
