//
//  UrlStringFormatter.h
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrlStringFormatter : NSObject

+ (NSString *)makeUrlFormString:(NSString *)url;

+ (NSString *)makePreetyUrlName:(NSString *)baseUrlString;



@end
