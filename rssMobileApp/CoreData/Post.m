//
//  Post.m
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import "Post.h"

@implementation Post

// Insert code here to add functionality to your managed object subclass

- (BOOL)isEqualTo:(id)object{
    if(![object isKindOfClass:[Post class]]){
        return NO;
    }
    
    Post *post = (Post *)object;
    //First try to compare by guid
    if(self.guid && post.guid){
        if([self.guid isEqualToString:post.guid]){
            return YES;
        }else{
            return NO;
        }
    }
    //Secondly try to compare by id
    else if(self.id && post.id){
        if([self.id isEqualToString:post.id]){
            return YES;
        }else{
            return NO;
        }
    }
    //At leas try to compare by other fields
    else if([self.title isEqualToString:post.title]){
        if([self.link isEqualToString:post.link]){
            return YES;
        }
    }
    return NO;
}

- (NSString*)getPublicationDate{
    if(self.pub_date){
        NSLog(@"DATEL %@", self.pub_date); //2016-03-03 19:44:04 +0000
//        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.pub_date];
//        int day =[dateComponents day];
//        int month = [dateComponents month];
//        NSString *strDate = [NSString stringWithFormat:@"%d.%d.%d",day, month,(int)[dateComponents year]];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"d EEE"];
        NSString *dateString = [formatter stringFromDate:self.pub_date];
        //TODO obsługa dla języka polskiego
                                       
        return dateString;
    }
    if(self.updated){
        //TODO handle for ATOM
    }
    return @" ";
}

- (NSString*)getShortDescription{
    if(self.summary){
        return self.summary;
    }
    if(self.post_description){
        return self.post_description;
    }
    return @" ";
}

@end
