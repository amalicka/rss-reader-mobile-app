//
//  ApiClient.m
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import "ApiClient.h"
#import "SyncSessionManager.h"
#import "CoreDataManager.h"
#import "StringConstans.h"
#import "UserData.h"
#import "AppDelegate.h"

NSString *const kPostMethod = @"POST";
NSString *const kContentType = @"Content-Type";
NSString *const kTypeJson = @"application/json";

@interface ApiClient ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end

@implementation ApiClient

+(id)sharedSingleton{
    static ApiClient *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ApiClient alloc] init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.manager = [[AFHTTPRequestOperationManager alloc]init];
}

- (NSString*)getUrlForMethod:(NSString *)methodName{
    return [NSString stringWithFormat:@"%@%@",kApiBaseUrl, methodName];
}

-(void)registerUserWithName:(NSString *)name andPawssword:(NSString *)password withSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(NSError *error))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    manager.securityPolicy = securityPolicy;
    
    NSDictionary *dataDict = @{@"name": name, @"password":password};
    [manager POST:[self getUrlForMethod: kApiRegister] parameters:dataDict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if([responseObject valueForKey:@"message"]){
            if([[responseObject valueForKey:@"message"] isEqualToString:@"registered"]){
                //delete previously logged user data
                [SyncSessionManager handleLogout];
                //
                
                [SyncSessionManager setCurrentSesionToken:[responseObject valueForKey:hToken]];
                
                AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                appDelegate.lastLoggeduserMail = name;
                
                UserData *user = [[UserData alloc] init];
                user.name = name;
                user.password = password;
                [user saveUserToKeychain];
                
                NSLog(@"REGISTRATION - SUCCESS");
                success(operation,responseObject);
            }else{
                NSLog(@"REGISTRATION - FAILED unnown reason");
                NSError *error = [[NSError alloc] initWithDomain:kRssMobieAppDomain code:777 userInfo:@{@"description":@"REGISTRATION sth went wrond despite getting 200"}];
                failure(error);
            }
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error);
        NSLog(@"REGISTRATION - FAILED %@", error);
    }];
}



-(void)loginUserWithName:(NSString *)name Pawssword:(NSString *)password andTokern:(NSString *)token withSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(NSError *error))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    manager.securityPolicy = securityPolicy;
    
    NSDictionary *dataDict = @{@"name": name, @"password":password};
    [manager POST:[self getUrlForMethod: kApiLogin] parameters:dataDict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if([responseObject valueForKey:@"message"]){
            if([[responseObject valueForKey:@"message"] isEqualToString:@"logged"]){
                [SyncSessionManager setCurrentSesionToken:[responseObject valueForKey:@"token"]];
                
                AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                appDelegate.lastLoggeduserMail = name;
                
                UserData *user = [[UserData alloc] init];
                user.name = name;
                user.password = password;
                [user saveUserToKeychain];
                
                NSLog(@"LOGIN - SUCCESS");
                success(operation,responseObject);
            }else{
                NSLog(@"LOGIN - FAILED unnown reason");
                NSError *error = [[NSError alloc] initWithDomain:kRssMobieAppDomain code:777 userInfo:@{@"description":@"LOGGIN sth went wrond despite getting 200"}];
                failure(error);
            }
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error);
        NSLog(@"LOGIN - FAILED %@", error);
        //wrong login or password
    }];
}

-(void)checkFeed:(NSString *)feed withSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(NSError *error))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFXMLParserResponseSerializer *serializer = [[AFXMLParserResponseSerializer alloc] init];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/rss+xml"];
    manager.responseSerializer = serializer;
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:feed parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error);
    }];
}

-(void)getDataForFeed:(NSString *)feed withSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(NSError *error))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [[AFHTTPResponseSerializer alloc] init];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/rss+xml"];
    manager.responseSerializer = serializer;
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:feed parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error);
    }];
}

-(void)syncFeedsWithSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(NSError *error))failure{
    //1
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self getUrlForMethod:kSyncFeed]]];
    //2
    [request setHTTPMethod:kPostMethod];
    [request setValue:kTypeJson forHTTPHeaderField:kContentType];
    [request setValue: [SyncSessionManager getCurrentSessionToken] forHTTPHeaderField:kApiSessionToken];
    [request setHTTPBody:[[self makeStringToSynchronize] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //3
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    operation.securityPolicy = securityPolicy;
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //5
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //6
        failure(error);
    }];
    //4
    [operation start];
}

- (NSString *)makeStringToSynchronize{
    NSMutableDictionary *bodyDict = [[NSMutableDictionary alloc]init];
    [bodyDict setObject: [NSNumber numberWithDouble: [SyncSessionManager getLastSyncTime]] forKey:kApiLasSyncTimestamp]; //
    //make added feeds urls array
    NSArray *addedFeeds = [[CoreDataManager sharedManager] getAllAddedFeedsFromLastSync];
    NSMutableArray *addedFeedsUrls = [[NSMutableArray alloc]init];
    for(Feed *feed in addedFeeds){
        [addedFeedsUrls addObject:feed.url];
    }
    //make deleted feeds urls array
    NSArray *deletedFeeds = [[CoreDataManager sharedManager] getAllDeletedFeedsFromLastSync];
    NSMutableArray *deletedFeedsUrls = [[NSMutableArray alloc]init];
    for(Feed *feed in deletedFeeds){
        [deletedFeedsUrls addObject:feed.url];
    }
    
    [bodyDict setObject: addedFeedsUrls forKey:kApiCreatedUpdated];
    [bodyDict setObject: deletedFeedsUrls forKey:kApiDeleted];
    // Change 'params' dictionary to JSON string to set it into HTTP body. Dictionary type will be not understanding by request.
    NSString *jsonString = [self getJSONStringWithDictionary:bodyDict];
    return jsonString;
}

#pragma mark - checking status methods
-(BOOL)handleStatus:(NSDictionary*)responseObject withfailure:(void (^)(NSError *error))failure{
    if(![responseObject objectForKey:kApiStatus]){ //if response is not a dictionary with "status" key
        return NO;
    }
    if([responseObject[kApiStatus] isEqualToString:@"OK"]){
        return YES;
    }
    else if([responseObject[kApiStatus] isEqualToString:@"FAIL"]){
    }
    return NO;
}

- (NSString *)getJSONStringWithDictionary: (NSDictionary *)contentDictionary{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:contentDictionary // Here you can pass array or dictionary
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString;
    if (jsonData) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //This is my JSON String
        //NSUTF8StringEncoding encodes special characters using an escaping scheme
    } else {
        NSLog(@"Got an error: %@", error);
        jsonString = @"";
    }
    NSLog(@"Your JSON String is %@", jsonString);
    return jsonString;
}

@end
