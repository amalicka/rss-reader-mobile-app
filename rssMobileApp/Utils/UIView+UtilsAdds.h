//
//  UIView+Utils.h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIView (UIView_UtilsAdds)

-(void)moveY:(float)yValue;
-(void)moveX:(float)xValue;
-(void)setFrameOriginY:(float)yValue;
-(void)setFrameOriginX:(float)xValue;
-(void)setFrameHeightAS:(float)heightX;
-(void)setFrameWidthAS:(float)widthX;
-(void)clearView;
-(void)moveSubviewsByX:(float)offsetX;
-(void)moveSubviewsByY:(float)offsetY;
- (UIView *)findSuperViewWithClass:(Class)superViewClass;

-(CGFloat)getWidth;
-(CGFloat)getHeight;

-(CGFloat)getMinY;
-(CGFloat)getMinX;
-(CGFloat)getMaxY;
-(CGFloat)getMaxX;

-(CGFloat)getMidY;
-(CGFloat)getMidX;

-(CGPoint)getCenter;
-(void)setFrameOriginPoint:(CGPoint)point;
- (CGFloat)xScale;
-(void)setCenterY:(float)centerY;
-(void)setCenterX:(float)centerX;

-(void)textFieldsResigndFirstResponders;
-(void)giveTextFieldsInset:(float)inset;
-(UIView*)getSubviewByName:(NSString*)name;

@end
