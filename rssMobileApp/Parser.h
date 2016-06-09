//
//  Parser.h
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post+CoreDataProperties.h"
#import "Feed+CoreDataProperties.h"

@interface Parser : NSObject <NSXMLParserDelegate>

+ (void)parseData:(NSData *)aData forFeed: (Feed*)aFeed;

@end
