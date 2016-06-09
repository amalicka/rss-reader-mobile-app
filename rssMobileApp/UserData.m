//
//  UserData.m
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import "UserData.h"
#import "SSKeychain.h"
#import "SSKeychainQuery.h"
#import "AppDelegate.h"

static NSString *hName = @"name";
static NSString *hPassword = @"password";
NSString *const hServiceName = @"rssMobileApp";

@implementation UserData

+(instancetype)sharedUser{
    static UserData *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UserData alloc] init];
    });
    return instance;
}

+(void)setSharedUserDataWithUserData:(UserData*)userData{
    UserData *sharedUserData = [UserData sharedUser];
    [sharedUserData setDataWithName:userData.name andPassword:userData.password];
}

-(BOOL)saveUserToKeychain{
    
    if([self isAllDataSet]){
        NSMutableDictionary *userDict = [NSMutableDictionary new];
        [userDict setObject:self.name forKey:hName];
        [userDict setObject:self.password forKey:hPassword];
        NSError *error = nil;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userDict options:0 error:&error];
        if(!error){
            [SSKeychain setPasswordData:userData forService:hServiceName account:self.name];
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

+(BOOL)isSharedUserDataSet{
    if([[UserData sharedUser] isAllDataSet]){
        return YES;
    }
    return NO;
}

-(void)setDataWithName:(NSString *)name andPassword:(NSString *)password{
    [self setName:name];
    [self setPassword:password];
}

-(BOOL)isAllDataSet{
    if(self.name && self.password){
        return YES;
    }
    return NO;
}

+(NSString *)getCurrentLoggedUserMail{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    return appDelegate.lastLoggeduserMail;
}

+ (void)deleteCurrentlyLoggedUserFromKeychain{
    NSLog(@"%@",[SSKeychain accountsForService:hServiceName]);
    SSKeychainQuery *query = [[SSKeychainQuery alloc] init];
    query.service = hServiceName;
    NSString *mail = [UserData getCurrentLoggedUserMail];
    if(mail){
        query.account = mail;
        query.passwordObject = nil;
        [query deleteItem:nil];
    }
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.lastLoggeduserMail = nil;
}

+(UserData *)getUserDataForEmail:(NSString *)email{
    
    NSData *userData = [SSKeychain passwordDataForService:hServiceName account:email];
    if(userData){
        NSError *error = nil;
        NSDictionary *retUserDict = [NSJSONSerialization JSONObjectWithData:userData options:NSJSONReadingAllowFragments error:&error];
        if(!error){
            UserData *userDataObject = [UserData userDataFromDictionary:retUserDict];
            return userDataObject;
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

+(UserData*)userDataFromDictionary:(NSDictionary*)dictionary{
    UserData *newUserData = [UserData new];
    [newUserData setValuesForKeysWithDictionary:dictionary];
    return newUserData;
}


@end
