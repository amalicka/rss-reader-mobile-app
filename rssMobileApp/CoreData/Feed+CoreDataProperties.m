//
//  Feed+CoreDataProperties.m
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Feed+CoreDataProperties.h"

@implementation Feed (CoreDataProperties)

@dynamic is_deleted;
@dynamic sync_timestamp;
@dynamic url;
@dynamic favicon;
@dynamic posts;

@end
