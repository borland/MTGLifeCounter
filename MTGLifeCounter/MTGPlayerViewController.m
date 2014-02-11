//
//  MTGPlayerViewController.m
//  MTGLifeCounter
//
//  Created by Orion Edwards on 31/01/14.
//  Copyright (c) 2014 Orion Edwards. All rights reserved.
//

#import "MTGPlayerViewController.h"
#import "MTGUtilityViews.h"

@interface MTGPlayerViewController ()

@end

@implementation MTGPlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setConstraintsFor:self.interfaceOrientation];
    if(self.isUpsideDown)
        self.view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
    
    [self addObserver:self forKeyPath:@"lifeTotal" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"playerName" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"isUpsideDown" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    self.lifeTotalLabel.text = [NSString stringWithFormat:@"%li", (long)self.lifeTotal];
    [self.playerNameButton setTitle:self.playerName forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)minusButtonPressed:(id)sender {
    self.lifeTotal -= 1;
    self.lifeTotalLabel.text = [NSString stringWithFormat:@"%li", (long)self.lifeTotal];
}

- (IBAction)plusButtonPressed:(id)sender {
    self.lifeTotal += 1;
    self.lifeTotalLabel.text = [NSString stringWithFormat:@"%li", (long)self.lifeTotal];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"lifeTotal"]) {
        self.lifeTotalLabel.text = [NSString stringWithFormat:@"%li", (long)self.lifeTotal];
    } else if([keyPath isEqualToString:@"playerName"]) {
        [self.playerNameButton setTitle:self.playerName forState:UIControlStateNormal];
    } else if([keyPath isEqualToString:@"isUpsideDown"]) {
        if(self.isUpsideDown)
            self.view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
        else
            self.view.transform = CGAffineTransformIdentity;
    }
}

-(void)dealloc {
    [self removeObserver:self forKeyPath:@"lifeTotal"];
    [self removeObserver:self forKeyPath:@"playerName"];
    [self removeObserver:self forKeyPath:@"isUpsideDown"];
}

- (IBAction)lifeTotalWasTapped:(UITapGestureRecognizer*)sender {
    CGPoint location = [sender locationInView:self.view];
    
    CGRect reference = self.view.frame;

    
    int n = 1;
    if([sender numberOfTouches] == 2) {
        n = 5;
    }
    
    BOOL up = YES;
    switch(self.interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            up = location.x > (reference.size.width / 2);
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            up = location.y < (reference.size.height / 2);
            break;
    }
    
    if(up) {
        [self plusButtonPressed:sender];
    } else {
        [self minusButtonPressed:sender];
    }

}

- (IBAction)lifeTotalPanning:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    
    const CGFloat m = 7.0;
    
    if (translation.y<-m || translation.y>m) {
        self.lifeTotal -= (translation.y / m);
        [sender setTranslation:CGPointMake(0, 0) inView:self.view]; // reset the recognizer
    }
}

-(void)selectRandomColor {
    [self.backgroundView selectRandomColor];
}


-(void)setConstraintsFor:(UIInterfaceOrientation)orientation {
    [self.view removeConstraints:self.view.constraints];
    
    UIView* view = self.view;
    UIView* plus = self.plusButton;
    UIView* minus = self.minusButton;
    UIView* lifeTotal = self.lifeTotalLabel;
    UIView* playerName = self.playerNameButton;
    
    NSDictionary* views = NSDictionaryOfVariableBindings(view, plus, minus, lifeTotal, playerName);
    
    void(^addConstraints)(NSArray*) = ^(NSArray* constraints) {
        [self.view addConstraints:constraints];
    };
   
    addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"H:[view]-(<=1)-[lifeTotal]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]);
    addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]-(<=1)-[lifeTotal]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]);
    
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown: // +/- on the sides
            addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"H:|-6-[playerName]" options:0 metrics:nil views:views]);
            addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[playerName]" options:0 metrics:nil views:views]);
            
            addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"H:[plus(44)]-|" options:0 metrics:nil views:views]);
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:plus attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
            
            addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[minus(44)]" options:0 metrics:nil views:views]);
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:minus attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
            break;
            
        case UIInterfaceOrientationLandscapeLeft: // +/- on the top/bottom
        case UIInterfaceOrientationLandscapeRight:
            addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"H:|-6-[playerName]" options:0 metrics:nil views:views]);
            addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[playerName]" options:0 metrics:nil views:views]);
            
            addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[plus(44)]" options:0 metrics:nil views:views]);
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:plus attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
            
            addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"V:[minus(44)]-|" options:0 metrics:nil views:views]);
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:minus attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
            break;
        default:
            break;
    }
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self setConstraintsFor:toInterfaceOrientation];
    [self.view setNeedsDisplay];
}

@end

@implementation MTGPlayerBackgroundView {
    UIColor* _color1;
    UIColor* _color2;
}

+ (UIColor *)lighterColor:(UIColor *)c
{
    CGFloat h, s, b, a;
    if ([c getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s * 0.5
                          brightness:b
                               alpha:a];
    return nil;
}

-(void)awakeFromNib {
    [self selectRandomColor];
}

-(void)selectRandomColor {
    switch(unbiasedRandom(5)) {
        case 0: // WHITE
            _color1 = [UIColor colorWithRed:0.70 green:0.68 blue:0.66 alpha:1];
            _color2 = [UIColor colorWithRed:0.80 green:0.77 blue:0.73 alpha:1];
            break;
        case 1: // BLUE
            _color1 = [UIColor colorWithRed:0.00 green:0.22 blue:0.42 alpha:1];
            _color2 = [UIColor colorWithRed:0.60 green:0.80 blue:1 alpha:1];
            break;
        case 2: // BLACK
            _color1 = [UIColor colorWithRed:0.12 green:0.19 blue:0.25 alpha:1];
            _color2 = [UIColor colorWithRed:0.25 green:0.29 blue:0.28 alpha:1];
            break;
        case 3: // RED
            _color1 = [UIColor colorWithRed:0.34 green:0.04 blue:0.07 alpha:1];
            _color2 = [UIColor colorWithRed:0.88 green:0.44 blue:0.34 alpha:1];
            break;
        case 4: // GREEN
            _color1 = [UIColor colorWithRed:0.15 green:0.38 blue:0.27 alpha:1];
            _color2 = [UIColor colorWithRed:0.39 green:0.66 blue:0.40 alpha:1];
            break;
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    const CGFloat* c1 = CGColorGetComponents(_color1.CGColor);
    const CGFloat* c2 = CGColorGetComponents(_color2.CGColor);
    
    // draw a flat background rectangle as the gradient doesn't "keep going"
    CGContextSetFillColor(context, c2);
    CGContextFillRect(context, rect);
    
    //Define the gradient ----------------------
    CGGradientRef gradient;
    CGColorSpaceRef colorSpace;
    size_t locations_num = 2;
    
    CGFloat locations[2] = {0.0,1.0};
    
    CGFloat components[8] = {};
    memcpy(components, c1, 4 * sizeof(CGFloat));
    memcpy(components + 4, c2, 4 * sizeof(CGFloat));
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    gradient = CGGradientCreateWithColorComponents (colorSpace, components,
                                                    locations, locations_num);
    
    //Define Gradient Positions ---------------
    
    //We want these exactly at the center of the view
    CGPoint startPoint, endPoint;
    
    //Start point
    const CGFloat w = self.frame.size.width;
    
    startPoint.x = w * -0.33;
    startPoint.y = w * -0.33;
    
    //End point
    endPoint.x = 0;
    endPoint.y = 0;
    
    //Generate the Image -----------------------
    CGContextDrawRadialGradient(context, gradient, startPoint, 0, endPoint, w *0.8, 0);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRestoreGState(context);
}

@end
