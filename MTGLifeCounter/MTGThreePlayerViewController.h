//
//  MTGThreePlayerViewController.h
//  MTGLifeCounter
//
//  Created by Orion Edwards on 31/01/14.
//  Copyright (c) 2014 Orion Edwards. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTGThreePlayerViewController : UIViewController
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)d20ButtonPressed:(id)sender;
- (IBAction)refreshButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIView *c1;
@property (weak, nonatomic) IBOutlet UIView *c2;
@property (weak, nonatomic) IBOutlet UIView *c3;
@end
