//
//  MTGUtilityViews.m
//  MTGLifeCounter
//
//  Created by Orion Edwards on 31/01/14.
//  Copyright (c) 2014 Orion Edwards. All rights reserved.
//

#import "MTGUtilityViews.h"

int unbiasedRandom(int bound) {
    double d = (double)random() / (double)RAND_MAX;
    return d * bound;
}

@implementation MTGDisclosureIndicatorView

-(void)awakeFromNib {
    // the bg color is set to pink or some weird color in interface builder so you can see where the indicator would go
    self.backgroundColor = [UIColor clearColor];
}

-(void)drawRect:(CGRect)rect {
    CGContextRef ctxt  = UIGraphicsGetCurrentContext();
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGContextSaveGState(ctxt);
    
    // TODO draw the alarm priority indicator
    //    self.backgroundColor = _parent.alarmColor;
    
    // Draws a disclosure indicator such that the tip of the arrow is at (x,y)
    // from http://www.benzado.com/blog/post/325/draw-your-own-disclosure-indicator
    static const CGFloat R = 4.7; // "radius" of the arrow head
    static const CGFloat W = 2.3; // line width
    
    CGFloat x = width - 3;
    CGFloat y = height / 2;
    
    CGFloat components[] = { 0.78, 0.78, 0.78, 1.0 }; // the gray color used by the system disclosure indicator in ios7
    CGContextSetStrokeColor(ctxt, components);
    
    CGContextMoveToPoint(ctxt, x-R, y-R);
    CGContextAddLineToPoint(ctxt, x, y);
    CGContextAddLineToPoint(ctxt, x-R, y+R);
    CGContextSetLineCap(ctxt, kCGLineCapSquare);
    CGContextSetLineJoin(ctxt, kCGLineJoinMiter);
    CGContextSetLineWidth(ctxt, W);
    CGContextStrokePath(ctxt);
    
    CGContextRestoreGState(ctxt);
}

@end

@implementation MTGDiceRollView {
    UILabel* _label;
}

const NSUInteger UIViewAutoresizingFlexibleMargins = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        _diceFaceCount = 20; // default to D20
        
        // configurable bits
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        CGFloat labelHeight = 160;
        CGFloat labelWidth = 160;
        
        // derive the center x and y
        CGFloat centerX = frame.size.width / 2;
        CGFloat centerY = frame.size.height / 2;
        
        // create and configure the label
        _label = [[UILabel alloc]initWithFrame:CGRectMake(
                                                         centerX - (labelWidth / 2),
                                                         centerY - (labelHeight / 2) ,
                                                         labelWidth ,
                                                         labelHeight
                                                         )];
        _label.backgroundColor = [UIColor colorWithRed:0.30 green:0.10 blue:0.70 alpha:1];
        _label.alpha = 1.0;
        _label.textColor = [UIColor whiteColor];
        _label.text = nil;
        _label.font = [UIFont fontWithName:@"Futura" size:100];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.autoresizingMask = UIViewAutoresizingFlexibleMargins;
        _label.layer.cornerRadius = 20;
        [self addSubview:_label];
        
        self.userInteractionEnabled = NO;
        _label.userInteractionEnabled = NO;
    }
    return self;
}

-(void)rollWithCompletion:(void (^)(BOOL finished))completion {
    int n = unbiasedRandom((int)self.diceFaceCount) + 1;
    
    _label.text = [NSString stringWithFormat:@"%i", n];
    
    [UIView animateWithDuration:1.7
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _label.alpha = 0.0;
                     }
                     completion:completion];
}

@end