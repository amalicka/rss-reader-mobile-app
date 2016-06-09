//
//  UIImage+Color.h
//  rssMobileApp
//
//  Created by amalicka on 14.02.2016.
//  Copyright © 2016 amalicka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

+ (UIImage*)setBackgroundImageByColor:(UIColor *)backgroundColor withFrame:(CGRect )rect;


+ (UIImage*) replaceColor:(UIColor*)color inImage:(UIImage*)image withTolerance:(float)tolerance;

+(UIImage *)changeWhiteColorTransparent: (UIImage *)image;

+(UIImage *)changeColorTo:(NSMutableArray*) array Transparent: (UIImage *)image;

//resizing Stuff...
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
