//
//  Parser.m
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import "Parser.h"
#import "CoreDataManager.h"
#import "NSAttributedString+HTML.h"
#import "StringConstans.h"

@interface Parser()
@property (nonatomic, strong) NSXMLParser *rssParser;
@property (nonatomic, strong) NSString *currentElement;
@property (nonatomic, strong) Post *post;
@property (nonatomic, strong) NSMutableSet <Post *>  *posts;
@property (nonatomic, strong) Feed *feed;
@end

@implementation Parser{
    NSMutableString *title, *link, *description, *summary, *pubDate, *updated, *guid, *postId;
}

- (id)initWithData:(NSData *)aData andFeed: (Feed*)aFeed{
    self = [super init];
    if (self) {
        self.feed = aFeed;
        self.posts = [[NSMutableSet alloc] init];
    }
    return self;
}

- (id)init {
    return [super init];
}

+ (void)parseData:(NSData *)aData forFeed: (Feed*)aFeed{
    Parser *p = [[Parser alloc] initWithData:aData andFeed:aFeed];
    [p makeParsing:aData];
}
//*****************************************************************************/
#pragma mark - Parsing
//*****************************************************************************/

-(void)makeParsing:(NSData* )data{
    self.rssParser = [[NSXMLParser alloc] initWithData:(NSData *)data];
    [self.rssParser setDelegate: self];
    [self.rssParser parse];
}

//*****************************************************************************/
#pragma mark - Parsing - delegate methods
//*****************************************************************************/

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes: (NSDictionary *)attributeDict {
    
    self.currentElement = elementName;
    if ([self.currentElement isEqualToString:@"channel"]) {
        return;
    }
    if ([self.currentElement isEqualToString:@"item"]) {
        self.post = [[CoreDataManager sharedManager] getPostInstance];
        self.post.is_atom = [NSNumber numberWithBool:NO];
        self.post.is_read = [NSNumber numberWithBool:NO];
        self.post.is_fav = [NSNumber numberWithBool:NO];
        [self nullifyMutableStrings];
        return;
    }
    else if ([self.currentElement isEqualToString:@"entry"]) {
        self.post = [[CoreDataManager sharedManager] getPostInstance];
        self.post.is_atom = [NSNumber numberWithBool:YES];
        self.post.is_read = [NSNumber numberWithBool:NO];
        self.post.is_fav = [NSNumber numberWithBool:NO];
        [self nullifyMutableStrings];
        return;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if(self.post){
        [string stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet nonBaseCharacterSet]];
        if ([_currentElement isEqualToString:@"title"]) {
            [title appendString: string];
        } else if ([_currentElement isEqualToString:@"link"]) {
            [link appendString: string];
        } else if ([_currentElement isEqualToString:@"description"]) {
            [description appendString: string];
        } else if ([_currentElement isEqualToString:@"summary"]) {// Atom
            [summary appendString: string];
        } else if ([_currentElement isEqualToString:@"pubDate"]) {
            [pubDate appendString: string];
        } else if ([_currentElement isEqualToString:@"updated"]) { // Atom
            [updated appendString: string];
        } else if ([_currentElement isEqualToString:@"guid"]) {
            [guid appendString: string];
        } else if ([_currentElement isEqualToString:@"id"]) { //Atom
            [postId appendString: string];
        }
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if(self.post){
        if ([_currentElement isEqualToString:@"title"]) {
            NSData *data = [[title copy] dataUsingEncoding:NSUTF8StringEncoding];
            NSAttributedString *attrStr = [[NSAttributedString alloc] initWithHTMLData:data options:nil documentAttributes:nil];
            self.post.title = [attrStr.string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        else if ([_currentElement isEqualToString:@"link"]) {
            self.post.link = [link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];;
        }
        else if ([_currentElement isEqualToString:@"description"]) {
            NSData *data = [[description copy] dataUsingEncoding:NSUTF8StringEncoding];
            NSAttributedString *attrStr = [[NSAttributedString alloc] initWithHTMLData:data options:nil documentAttributes:nil];
            NSString *str = attrStr.string;
            self.post.post_description = [self cleanFromTags: str];
        }
        else if ([_currentElement isEqualToString:@"summary"]) {// Atom
            NSData *data = [[summary copy] dataUsingEncoding:NSUTF8StringEncoding];
            NSAttributedString *attrStr = [[NSAttributedString alloc] initWithHTMLData:data options:nil documentAttributes:nil];
            NSString *str = attrStr.string;
            self.post.summary = [self cleanFromTags: str];
        }
        else if ([_currentElement isEqualToString:@"pubDate"]) {
            self.post.pub_date = [self makeDataFromString:pubDate];
        }
        else if ([_currentElement isEqualToString:@"updated"]) { // Atom
            self.post.updated = [self makeDataFromString:updated];
        }
        else if ([_currentElement isEqualToString:@"guid"]) {
            self.post.guid = [guid stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];;
        }
        else if ([_currentElement isEqualToString:@"id"]) { //Atom
            self.post.id = [postId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];;
        }
        //ENDING POST
        if ([elementName isEqualToString:@"item"] || [elementName isEqualToString:@"entry"]) {
            [self.posts addObject:self.post];
            self.post = nil;
        }
        //if(currentRssItem.title!=nil) {NSLog(@"PARSING DONE \t%@", currentRssItem.title);}
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"PARSING DOCUMENT ENDED");
    BOOL isPostUpdated = [[CoreDataManager sharedManager] updateFeed:self.feed withPosts:[self.posts allObjects]];
    if(isPostUpdated){
        [[NSNotificationCenter defaultCenter] postNotificationName:notifFeedUpdated object:self.feed];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:notifFeedUpdated object:self.feed];
    }
    
    [self.posts removeAllObjects];
    
}

- (void)nullifyMutableStrings{
        title = [[NSMutableString alloc] init];
        link = [[NSMutableString alloc] init];;
        description = [[NSMutableString alloc] init];;
        summary = [[NSMutableString alloc] init];;
        pubDate = [[NSMutableString alloc] init];;
        updated = [[NSMutableString alloc] init];;
        guid = [[NSMutableString alloc] init];;
        postId = [[NSMutableString alloc] init];;
}

#pragma mark - Text converting helper methods

- (NSDate *)makeDataFromString:(NSString *)dateString{
    //handle rss
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat: @"EEE, dd MMM yyyy HH:mm:ss ZZ"];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormater setLocale:enUSPOSIXLocale];
    NSDate *date = [dateFormater dateFromString:dateString];
    //handle atom
    if(!date){
        date = [self dateFromAtomString:dateString withDateFormatter:dateFormater];
    }
    return date;
}

- (NSString *) cleanFromTags:(NSString *)text{
    if(text==nil){
        return @" ";
    }
    NSString *cleanedText;
    //NSCharacterSet *doNotWant;
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"<img.*\/>"
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    
    cleanedText = [regex stringByReplacingMatchesInString:text
                                                  options:0
                                                    range:NSMakeRange(0, [text length])
                                             withTemplate:@""];
    
    regex = [NSRegularExpression regularExpressionWithPattern:@"<a.*>.*<\/a>"
                                                      options:NSRegularExpressionCaseInsensitive
                                                        error:&error];
    
    cleanedText = [regex stringByReplacingMatchesInString:cleanedText
                                                  options:0
                                                    range:NSMakeRange(0, [cleanedText length])
                                             withTemplate:@""];
    //doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"-=+[]{}:/?.><;,!@#$%^&*\n()\r'"];
    //cleanedText = [[text componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
    return cleanedText;
}


- (NSDate *)dateFromAtomString:(NSString *)dateString withDateFormatter: (NSDateFormatter*)dateFormatter {
    // Keep dateString around a while (for thread-safety)
    NSDate *date = nil;
    if (dateString) {
            // Process date
            NSString *str = [[NSString stringWithString:dateString] uppercaseString];
            str = [str stringByReplacingOccurrencesOfString:@"Z" withString:@"-0000"];
            if (str.length > 20) {
                str = [str stringByReplacingOccurrencesOfString:@":"
                                                     withString:@""
                                                        options:0
                                                          range:NSMakeRange(20, str.length-20)];
            }
            if (!date) { // 2005-12-19T16:39:57-0800
                [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"];
                date = [dateFormatter dateFromString:str];
            }
            if (!date) { // 2005-01-01T12:00:27.87+0020
                [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZZZ"];
                date = [dateFormatter dateFromString:str];
            }
            if (!date) { // 2005-01-01T12:00:27
                [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
                date = [dateFormatter dateFromString:str];
            }
            if (!date) NSLog(@"The Date is still NIL");
    }
    return date;
}

@end
