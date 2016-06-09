//
//  UserData.h
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic,strong) NSString *password;

//global

+(UserData*)sharedUser;

+(void)setSharedUserDataWithUserData:(UserData*)userData;

+(BOOL)isSharedUserDataSet;

/*
 * If user data object is filled it is saved to keychain
 * BOOL - if saving is success returns YES
 */
-(BOOL)saveUserToKeychain;

+(NSString *)getCurrentLoggedUserMail;

+ (void)deleteCurrentlyLoggedUserFromKeychain;

+(UserData *)getUserDataForEmail:(NSString *)email;

@end
