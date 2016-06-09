//
//  CoreDataManager.h
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Feed.h"

typedef enum SaveFeedStatus : NSUInteger {
    kAlreadyPresent,
    kFeedSaved,
    kSavingError
} SaveFeedStatus;

@interface CoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


#pragma mark setters

+(instancetype)sharedManager;

-(SaveFeedStatus)saveFeed:(NSString *)feedUrl;

- (NSArray *)getAllFeeds;

- (NSArray*)getAllFeedsFromTimestamp:(double)timestamp;
    
- (NSArray*)getAllDeletedFeedsFromLastSync;

- (NSArray*)getAllAddedFeedsFromLastSync;

- (void)deleteAllFeeds;

- (void)deleteAllPosts;

- (NSArray *)getAllActiveFeeds;

- (void)upadateAddedFeeds:(NSArray*)createdUpdated;

- (void)upadateDeletedFeeds:(NSArray*)deleted;

- (BOOL)deleteFeed:(Feed*)feed;

- (void)clearDatabase;

- (Post*)getPostInstance;

- (BOOL)updateFeed: (Feed*)feed withPosts:(NSArray*)posts;

- (void)markAsReadNumberOfDays:(int)days;

- (NSArray*)getAllActivePosts;

- (NSInteger)getNumberOfUnreadPosts;

#pragma mark rest

- (void)saveContext;

- (NSURL *)applicationDocumentsDirectory;

//- (void)updateSalonsAndCars:(NSDictionary*)salonsAndCarsDict;

@end
