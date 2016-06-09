//
//  UIColor+rss.m
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import "UIColor+rss.h"

@implementation UIColor (rss)


+(UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

//GRAY
+(UIColor*)appBaseColor{
    return [self colorFromHexString:@"#286FBE"];
    //return [self colorFromHexString:@"#4A90E2"];
    //return [self colorFromHexString:@"#175b8f"];
}

+(UIColor*)appLightBackgroundColor{
    return [self colorFromHexString:@"#F0F0F0"];
}

+(UIColor*)appNavbarColor{
    return [self colorFromHexString:@"#FAFAFA"];
}

+(UIColor*)appNavbarBottomLine{
    return [self colorFromHexString:@"#DEDEDE"];
}


- (UIColor *)setAlpha:(float)alpha
{
    CGFloat r, g, b, a;
    if ([self getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:r green:g blue:b alpha:alpha/255];
    return nil;
}


@end

