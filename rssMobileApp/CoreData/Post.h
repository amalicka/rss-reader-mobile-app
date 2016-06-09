//
//  Post.h
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Post : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

- (BOOL)isEqualTo:(id)object;

- (NSString*)getPublicationDate;

- (NSString*)getShortDescription;

@end

NS_ASSUME_NONNULL_END

#import "Post+CoreDataProperties.h"
