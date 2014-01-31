//
//  MTGUtilityViews.m
//  MTGLifeCounter
//
//  Created by Orion Edwards on 31/01/14.
//  Copyright (c) 2014 Orion Edwards. All rights reserved.
//

#import "MTGUtilityViews.h"


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