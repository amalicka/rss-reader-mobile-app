//
//  UrlStringFormatter.m
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import "UrlStringFormatter.h"

@implementation UrlStringFormatter

+ (NSString *)makeUrlFormString:(NSString *)url{
    if ([[url lowercaseString] rangeOfString:@"www."].location != NSNotFound) {
        NSLog(@"string contain wwww");
        url = [url stringByReplacingOccurrencesOfString:@"www."
                                             withString:@""];
    }
    
    if ([[url lowercaseString] rangeOfString:@"http://"].location == NSNotFound) {
        NSLog(@"string does not contain http");
        url = [@"http://" stringByAppendingString:url];
    }
    
    return url;
}

+ (NSString *)makePreetyUrlName:(NSString *)url{
    NSString *str =[url stringByReplacingOccurrencesOfString:@"http://"
                                                        withString:@""];
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"\\/.*"
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    
    NSString *modifiedString = [regex
                                stringByReplacingMatchesInString:str
                                options:0
                                range:NSMakeRange(0, [str length])
                                withTemplate:@""];
    return modifiedString;
    
//    NSString *someRegexp = ...;
//    NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", someRegexp];
//    
//    if ([myTest evaluateWithObject: testString]){
//        //Matches
//    }
}

@end
