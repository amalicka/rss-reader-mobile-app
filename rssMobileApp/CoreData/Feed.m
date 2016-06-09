//
//  Feed.m
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import "Feed.h"
#import "Feed+CoreDataProperties.h"

static NSNumberFormatter *nForm;

@implementation Feed

// Insert code here to add functionality to your managed object subclass

-(void)updateWithDictionary:(NSDictionary*)feedDictionary{
    if(feedDictionary){
        if([feedDictionary[@"sync_timestamp"] isKindOfClass:[NSNumber class]]){
            self.sync_timestamp = feedDictionary[@"sync_timestamp"];
        }else{
            self.sync_timestamp = [[Feed formatter] numberFromString:feedDictionary[@"sync_timestamp"]];
        }
                                   
        if([feedDictionary[@"is_deleted"] isKindOfClass:[NSNumber class]]){
           self.is_deleted = feedDictionary[@"is_deleted"];
        }else{
          self.is_deleted = [[Feed formatter] numberFromString:feedDictionary[@"is_deleted"]];
        }
        
        //self.is_deleted = feedDictionary[@"name"];
        self.url = feedDictionary[@"url"];
        
        
        
        //TODO favicon
    }
}

+(NSNumberFormatter*)formatter{
    static NSNumberFormatter *numFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        numFormatter = [[NSNumberFormatter alloc] init];
    });
    return numFormatter;
}

- (NSInteger)getNumberOfUnreadPosts{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"is_read == %@", [NSNumber numberWithBool:NO]];
    NSSet *filteredSet = [self.posts filteredSetUsingPredicate:predicate];
    if(filteredSet){
        return [filteredSet count];
    }else{
        return 0;
    }
}

@end
