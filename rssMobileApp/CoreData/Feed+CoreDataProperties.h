//
//  Feed+CoreDataProperties.h
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Feed.h"
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface Feed (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *is_deleted;
@property (nullable, nonatomic, retain) NSNumber *sync_timestamp;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSData *favicon;
@property (nullable, nonatomic, retain) NSSet<Post *> *posts;

@end

@interface Feed (CoreDataGeneratedAccessors)

- (void)addPostsObject:(Post *)value;
- (void)removePostsObject:(Post *)value;
- (void)addPosts:(NSSet<Post *> *)values;
- (void)removePosts:(NSSet<Post *> *)values;

@end

NS_ASSUME_NONNULL_END
