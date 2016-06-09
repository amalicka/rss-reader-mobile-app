
#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)

#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define REGEX_USER_NAME_LIMIT @"^.{3,10}$"
#define REGEX_USER_NAME @"[a-zA-ZąćęłńóśźżĄĘŁŃÓŚŹŻ]{1,20}"
#define REGEX_USER_SURNAME @"[A-Za-ząćęłńóśźżĄĘŁŃÓŚŹŻ\\-]{1,30}"
#define REGEXP_PHONE_PREFIX @"\\+[0-9]{2}"
#define REGEX_EMAIL @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$"
#define REGEX_PHONE_DEFAULT @"[0-9]{9}"

#define LOGOUT_TIME 1800 
#define SYNC_DAILY_PERIOD 86400

@interface Utils : NSObject <MFMailComposeViewControllerDelegate>

+ (UIView*)getSuperviewOfView:(UIView*)viewX WithClassType:(Class)className;

+ (UIView*)clearView:(UIView*)viewX;

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (CGFloat)screenHeight;

+ (CGFloat)screenWidth;

+ (CGFloat)heightForLabelWithWidth:(CGFloat)labelWidth andFont:(UIFont*)fontX andText:(NSString*)textX;

+ (CGFloat)widthForLabelWithHeight:(CGFloat)labelH andFont:(UIFont*)fontX andText:(NSString*)textX;

+ (BOOL)isNumber:(NSString*)string;

+ (BOOL)is_iOS8up;

+ (BOOL)is_iOS9up;

+ (BOOL)isPhoneNumber:(NSString*)string;

+ (BOOL)isIphone5up;

+ (BOOL)isNetConnection;

+ (BOOL)isTestVersion;

+ (BOOL)isEmptyString:(NSString*)testString;

+ (void)replaceTextWithLocalizedTextInSubviewsForView:(UIView*)view;

+ (void)addVerionLabel;

+ (NSDictionary*)loadDataFromPlist:(NSString*)plistName;

+ (NSArray*)loadArrayFromPlist:(NSString*)plistName;

+(void)setInsetsToCell:(UITableViewCell*)cell;

+(void)printOutFonts;

+ (NSString *)getCurrentDateString;


@end
