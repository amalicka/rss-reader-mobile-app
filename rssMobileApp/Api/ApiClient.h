//
//  ApiClient.h
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface ApiClient : NSObject

+ (ApiClient *) sharedSingleton;

-(void)registerUserWithName:(NSString *)name andPawssword:(NSString *)password withSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(NSError *error))failure;

-(void)loginUserWithName:(NSString *)name Pawssword:(NSString *)password andTokern:(NSString *)token withSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(NSError *error))failure;

-(void)checkFeed:(NSString *)feed withSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(NSError *error))failure;

-(void)getDataForFeed:(NSString *)feed withSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(NSError *error))failure;

-(void)syncFeedsWithSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(NSError *error))failure;

@end
