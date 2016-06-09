

#import "Utils.h"
#import "AFNetworkReachabilityManager.h"

@implementation Utils

static NSDictionary *utilsDictionary;
static NSArray *menuArray;
#define ARC4RANDOM_MAX      0x100000000

static BOOL TESTVERSION = YES;

static Utils *selfUtils;

+(UIView*)getSuperviewOfView:(UIView*)viewX WithClassType:(Class)className{
    
    if([viewX superview]!=nil){
        
        if([[viewX superview] isKindOfClass:className]){
            return [viewX superview];
        }else{
            
            return [Utils getSuperviewOfView:[viewX superview] WithClassType:className];
        }
    }else{
        return nil;
    }
}

+(UIView*)clearView:(UIView*)viewX{
    
    while([[viewX subviews] count]>0){
        [[[viewX subviews]objectAtIndex:0] removeFromSuperview];
    }
    return viewX;
}

+(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(CGFloat)screenHeight{
    
    return [[UIScreen mainScreen] bounds].size.height;
    
}

+(CGFloat)screenWidth{
    
    return [[UIScreen mainScreen] bounds].size.width;
    
}

+(CGFloat)heightForLabelWithWidth:(CGFloat)labelWidth andFont:(UIFont*)fontX andText:(NSString*)textX{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:fontX.fontName size:fontX.pointSize]};
    CGSize sizeX = [textX boundingRectWithSize:CGSizeMake(labelWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return sizeX.height;
}

+(CGFloat)widthForLabelWithHeight:(CGFloat)labelH andFont:(UIFont*)fontX andText:(NSString*)textX{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:fontX.fontName size:fontX.pointSize]};
    CGSize sizeX = [textX boundingRectWithSize:CGSizeMake(MAXFLOAT, labelH) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return sizeX.width;
}

+(BOOL)isTestVersion{
    return TESTVERSION;
}

+(BOOL)isNumber:(NSString*)string{
    
    NSString *emailRegex = @"[0-9]*";
    NSPredicate *numtest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isNum = [numtest evaluateWithObject:string];

    if(string.length == 0){
        isNum = NO;
    }
    if(isNum == NO){
        return NO;
    }else{
        return YES;
    }
}

+(BOOL)isPhoneNumber:(NSString*)string{
    NSString *emailRegex = @"[0-9]{0,9}";
    NSPredicate *numtest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isNum = [numtest evaluateWithObject:string];
    if(isNum==NO){
        return NO;
    }else{
        return YES;
    }
}

+(BOOL)isEmptyString:(NSString*)testString{
    testString = [testString stringByReplacingOccurrencesOfString:@" " withString:@""];
    testString = [testString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if(testString.length>0){
        return NO;
    }else{
        return YES;
    }
}

+(BOOL)is_iOS8up{
    NSString *version = [[UIDevice currentDevice] systemVersion];
    BOOL isAtLeast8 =  [version floatValue] >= 8.0;
    return isAtLeast8;
}

+(BOOL)is_iOS9up{
    NSString *version = [[UIDevice currentDevice] systemVersion];
    BOOL isAtLeast9 =  [version floatValue] >= 9.0;
    return isAtLeast9;
}

+(BOOL)isIphone5up{
    if([[UIScreen mainScreen] bounds].size.height>470){
        return YES;
    }else{
        return NO;
    }
}

+(void)replaceTextWithLocalizedTextInSubviewsForView:(UIView*)view{
    for (UIView* v in view.subviews)
    {
        if (v.subviews.count > 0)
        {
            [self replaceTextWithLocalizedTextInSubviewsForView:v];
        }
        
        if ([v isKindOfClass:[UILabel class]])
        {
            UILabel* l = (UILabel*)v;
            l.text = NSLocalizedString(l.text, nil);
            //[l sizeToFit];
        }
        
        if ([v isKindOfClass:[UIButton class]])
        {
            UIButton* b = (UIButton*)v;
            [b setTitle:NSLocalizedString(b.titleLabel.text, nil) forState:UIControlStateNormal];
        }
    }
}

+(void)addVerionLabel{
    if(TESTVERSION){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 40, 12)];
        [label setBackgroundColor:[UIColor whiteColor]];
        [label.layer setCornerRadius:3];
        [label setClipsToBounds:YES];
        [label setFont:[UIFont systemFontOfSize:10]];
        [label setTextColor:[UIColor blackColor]];
        [label.layer setBorderColor:[UIColor blackColor].CGColor];
        [label.layer setBorderWidth:1];
        NSString * build = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
        [label setText:build];
        [label setBackgroundColor:[UIColor whiteColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [[[[UIApplication sharedApplication] delegate] window] addSubview:label];
    }
}

+(BOOL)isNetConnection{
    if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
        return YES;
    } else {
        return NO;
    }
}

+(NSDictionary*)loadDataFromPlist:(NSString *)plistName{
    return [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"]];
}

+(NSArray*)loadArrayFromPlist:(NSString *)plistName{
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"]]];
    for(int i = 0 ; i < array.count ; i++){
        [array replaceObjectAtIndex:i withObject:[array[i] mutableCopy]];
    }
    return [NSArray arrayWithArray:array];
}

+(void)setInsetsToCell:(UITableViewCell*)cell{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}


+(void)printOutFonts{

    NSArray *fontFamilies = [UIFont familyNames];
    
    for (int i = 0; i < [fontFamilies count]; i++)
    {
        NSString *fontFamily = [fontFamilies objectAtIndex:i];
        NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
        NSLog (@"%@: %@", fontFamily, fontNames);
    }

}

+ (NSString *)getCurrentDateString{
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate: currDate];
}


@end
