//
//  SyncSecionManager.m
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import "SyncSessionManager.h"
#import "ApiClient.h"
#import "CoreDataManager.h"
#import "Parser.h"
#import "StringConstans.h"
#import "UserData.h"

@implementation SyncSessionManager

//SESSION TOKEN
+ (NSString *) getCurrentSessionToken{
    if([[NSUserDefaults standardUserDefaults] stringForKey:hCurrentSessionToken]){
        return [[NSUserDefaults standardUserDefaults] stringForKey:hCurrentSessionToken];
    }
    return nil;
    
}

+ (void)setCurrentSesionToken:(NSString *)token{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:hCurrentSessionToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//SYNCTIME
+ (double)getLastSyncTime{
    if([[NSUserDefaults standardUserDefaults] doubleForKey:hLastSyncTimestamp]){
        return [[NSUserDefaults standardUserDefaults] doubleForKey:hLastSyncTimestamp];
    }
    return 0.0;
}

+ (void)setLastSyncTimestamp:(double)timestamp{
    [[NSUserDefaults standardUserDefaults] setDouble: timestamp forKey:hLastSyncTimestamp];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//SYNCING

+ (void)synchronizeFeeds{
    [[ApiClient sharedSingleton] syncFeedsWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dict = (NSDictionary*)responseObject;
            //save last sync timestamp
            NSNumber *timestamp = (NSNumber*)[dict valueForKey:@"timestamp"];
            [self setLastSyncTimestamp: [timestamp doubleValue]];
            [[CoreDataManager sharedManager] upadateAddedFeeds:(NSArray*)[dict valueForKey: @"createdUpdated"]];
            [[CoreDataManager sharedManager] upadateDeletedFeeds:(NSArray*)[dict valueForKey: @"deleted"]];
            [[NSNotificationCenter defaultCenter]postNotificationName:notifSyncFinished object:kSuccess];
            NSLog(@"kSucces notif send");
        });
    } failure:^(NSError *error) {
        //TODO handle message {"message":"sesionExpired"}
        if([error.localizedDescription containsString:@"401"]){
            [[NSNotificationCenter defaultCenter]postNotificationName:notifSyncFinished object:kFailTokenExpired];
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:notifSyncFinished object:kFail];
        }
    }];
}



+ (void)clearSyncDefaults{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: hCurrentSessionToken];
    [self setLastSyncTimestamp:0];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)handleLogout{
    [SyncSessionManager clearSyncDefaults];
    [UserData deleteCurrentlyLoggedUserFromKeychain];
    [[CoreDataManager sharedManager] clearDatabase];
}

@end
