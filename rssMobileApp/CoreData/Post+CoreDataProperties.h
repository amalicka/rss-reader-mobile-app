//
//  Post+CoreDataProperties.h
//  
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface Post (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *guid;
@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSNumber *is_atom;
@property (nullable, nonatomic, retain) NSString *link;
@property (nullable, nonatomic, retain) NSString *post_description;
@property (nullable, nonatomic, retain) NSDate *pub_date;
@property (nullable, nonatomic, retain) NSString *summary;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSDate *updated;
@property (nullable, nonatomic, retain) NSNumber *is_read;
@property (nullable, nonatomic, retain) NSNumber *is_fav;

@end

NS_ASSUME_NONNULL_END
