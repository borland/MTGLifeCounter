//
//  MTGPlayerViewController.m
//  MTGLifeCounter
//
//  Created by Orion Edwards on 31/01/14.
//  Copyright (c) 2014 Orion Edwards. All rights reserved.
//

#import "MTGPlayerViewController.h"

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
    
    if(self.isUpsideDown)
        self.view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);;
   
    [self addObserver:self forKeyPath:@"lifeTotal" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"playerName" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    self.lifeTotalLabel.text = [NSString stringWithFormat:@"%i", self.lifeTotal];
    [self.playerNameButton setTitle:self.playerName forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)minusButtonPressed:(id)sender {
    self.lifeTotal -= 1;
    self.lifeTotalLabel.text = [NSString stringWithFormat:@"%i", self.lifeTotal];
}

- (IBAction)plusButtonPressed:(id)sender {
    self.lifeTotal += 1;
    self.lifeTotalLabel.text = [NSString stringWithFormat:@"%i", self.lifeTotal];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"lifeTotal"]) {
        self.lifeTotalLabel.text = [NSString stringWithFormat:@"%i", self.lifeTotal];
    } else if([keyPath isEqualToString:@"playerName"]) {
        [self.playerNameButton setTitle:self.playerName forState:UIControlStateNormal];
    }
}

-(void)dealloc {
    [self removeObserver:self forKeyPath:@"lifeTotal"];
    [self removeObserver:self forKeyPath:@"playerName"];
}

- (IBAction)lifeTotalWasTapped:(UITapGestureRecognizer*)sender {
    CGPoint location = [sender locationInView:self.view];
    
    CGRect reference = self.view.frame;
    double halfX = reference.size.width / 2;
    
    if(location.x < halfX)
        [self minusButtonPressed:sender];
    else
        [self plusButtonPressed:sender];
}


- (IBAction)lifeTotalPanning:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    
    if (translation.y<-5 || translation.y>5) {
        self.lifeTotal -= (translation.y / 5);
        [sender setTranslation:CGPointMake(0, 0) inView:self.view]; // reset the recognizer
    }
}

@end

@implementation MTGPlayerBackgroundView

- (UIColor *)lighterColor:(UIColor *)c
{
    CGFloat h, s, b, a;
    if ([c getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s * 0.5
                          brightness:b
                               alpha:a];
    return nil;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    UIColor* color1 = [self lighterColor:[UIColor redColor]];
    UIColor* color2 = [self lighterColor:[UIColor greenColor]];
    
    const CGFloat* c1 = CGColorGetComponents(color1.CGColor);
    const CGFloat* c2 = CGColorGetComponents(color2.CGColor);
    
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
