//
//  SyncSecionManager.h
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyncSessionManager : NSObject

+ (NSString *) getCurrentSessionToken;

+ (void)setCurrentSesionToken:(NSString *)token;

+ (double) getLastSyncTime;

+ (NSString*)getUsername;

+ (void)setPassword:(NSString*)paswword;

+ (void)setLastSyncTimestamp:(double)timestamp;

+ (void)synchronizeFeeds;

+ (void)clearSyncDefaults;

+ (void)handleLogout;


@end

