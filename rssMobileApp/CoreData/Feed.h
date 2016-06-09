//
//  Feed.h
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Feed : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

-(void)updateWithDictionary:(NSDictionary*)feedDictionary;

- (NSInteger)getNumberOfUnreadPosts;

@end

NS_ASSUME_NONNULL_END

#import "Feed+CoreDataProperties.h"
