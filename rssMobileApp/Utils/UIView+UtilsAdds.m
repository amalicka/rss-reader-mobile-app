#import "UIView+UtilsAdds.h"

@implementation UIView (UIView_UtilsAdds)


-(void)moveY:(float)yValue{
    CGRect rectX = self.frame;
    rectX.origin.y+=yValue;
    [self setFrame:rectX];
}

-(void)moveX:(float)xValue{
    CGRect rectX = self.frame;
    rectX.origin.x += xValue;
    [self setFrame:rectX];
}

-(void)setFrameOriginX:(float)xValue{
    CGRect rectX = self.frame;
    rectX.origin.x = xValue;
    [self setFrame:rectX];
}

-(void)setFrameOriginPoint:(CGPoint)point{
    [self setFrameOriginX:point.x];
    [self setFrameOriginY:point.y];
}

-(void)setFrameOriginY:(float)yValue{
    CGRect rectX = self.frame;
    rectX.origin.y = yValue;
    [self setFrame:rectX];
}

-(void)setFrameHeightAS:(float)heightX{
    CGRect rectX = self.frame;
    rectX.size.height = heightX;
    [self setFrame:rectX];
}

-(void)setFrameWidthAS:(float)widthX{
    CGRect rectX = self.frame;
    rectX.size.width = widthX;
    [self setFrame:rectX];
}

-(void)setCenterY:(float)centerY{
    CGRect rectX = self.frame;
    [self setCenter:CGPointMake(0, centerY)];
    [self setFrameOriginX:rectX.origin.x];
}

-(void)setCenterX:(float)centerX{
    CGRect rectX = self.frame;
    [self setCenter:CGPointMake(centerX,0)];
    [self setFrameOriginY:rectX.origin.y];
}

-(CGPoint)getCenter{
    CGPoint retPoint = self.center;
    return retPoint;
}

-(CGFloat)getWidth{
    return self.frame.size.width;
}

-(CGFloat)getHeight{
    return self.frame.size.height;
}

-(CGFloat)getMinY{
    return  self.frame.origin.y;
}

-(CGFloat)getMidY{
    return  CGRectGetMidY(self.frame);
}

-(CGFloat)getMidX{
    return  CGRectGetMidX(self.frame);
}

-(CGFloat)getMinX{
    return  self.frame.origin.x;
}


-(CGFloat)getMaxY{
    return  CGRectGetMaxY(self.frame);
}

-(CGFloat)getMaxX{
    return  CGRectGetMaxX(self.frame);
}


-(void)clearView{
    while(self.subviews.count>0){
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
}

-(void)moveSubviewsByX:(float)offsetX{
    UIView* viewX;
    for (viewX in self.subviews){
        [viewX moveX:offsetX];
    }
}

-(void)moveSubviewsByY:(float)offsetY{
    UIView* viewX;
    for (viewX in self.subviews){
        [viewX moveY:offsetY];
    }
}

- (UIView *)findSuperViewWithClass:(Class)superViewClass {
    
    UIView *superView = self.superview;
    UIView *foundSuperView = nil;
    
    while (nil != superView && nil == foundSuperView) {
        if ([superView isKindOfClass:superViewClass]) {
            foundSuperView = superView;
        } else {
            superView = superView.superview;
        }
    }
    return foundSuperView;
}


-(void)textFieldsResigndFirstResponders{

    for(UIView *subX in self.subviews){
        if([subX isKindOfClass:[UITextField class]] || [subX isKindOfClass:[UITextView class]]){
            [(UITextField*)subX resignFirstResponder];
        }
        if([[subX subviews] count]>0){
            [subX textFieldsResigndFirstResponders];
        }
    }
}


-(void)giveTextFieldsInset:(float)inset{

    for(UIView *viewX in self.subviews){
        if([viewX isKindOfClass:[UITextField class]]){
            viewX.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        }else{
            [viewX giveTextFieldsInset:inset];
        }
    }
}

-(UIView*)getSubviewByName:(NSString*)name {
        
        if ([[[self class] description] rangeOfString:name options:NSCaseInsensitiveSearch].location != NSNotFound) {
            return self;
        }
    
        for (UIView *v in self.subviews) {
            UIView *child = [v getSubviewByName:name];
            if (child != nil) {
                return child;
            }
        }
    return nil;
}

- (CGFloat)xScale {
    CGAffineTransform t = self.transform;
    return sqrt(t.a * t.a + t.c * t.c);
}

@end
