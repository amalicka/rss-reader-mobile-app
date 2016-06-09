
#import <Foundation/Foundation.h>

#pragma mark - notifications
NSString *const notifSyncFinished = @"notifSyncFinished";
NSString *const notifFeedUpdated = @"notifFeedUpdated";
NSString *const notifContrastModeChanged = @"notifContrastModeChanged";
NSString *const notifSyncNeeded = @"notifSyncNeeded";


NSString *const kFail = @"failed";
NSString *const kFailTokenExpired = @"failTokenExpired";
NSString *const kSuccess = @"success";

#pragma mark - api client
NSString* const kApiStatus = @"status";
NSString* const kApiSessionToken= @"Auth-Token";
NSString* const kApiLasSyncTimestamp = @"timestamp";
NSString* const kApiCreatedUpdated = @"createdUpdated";
NSString* const kApiDeleted = @"deleted";
NSString* const kApiBaseUrl = @"https://localhost:4567/";
NSString* const kApiRegister= @"register";
NSString* const kApiLogin= @"login";
NSString* const kSyncFeed= @"feeds";

#pragma mark - sync manager
NSString *const hCurrentSessionToken = @"currentSessionToken";
NSString *const hLastSyncTimestamp = @"lastSyncTimestamp";
NSString *const hToken = @"token";

NSString *const kRssMobieAppDomain= @"RssMobieAppDomain";

#pragma mark - helpers
NSString *const hShowSyncRegisterInfo = @"showSyncRegisterInfo";
NSString *const hIsHeighContrastMode = @"isHeighContrastMode ";
NSString *const hIsReadabilityModeSelected = @"IsReadabilityModeSelected";
