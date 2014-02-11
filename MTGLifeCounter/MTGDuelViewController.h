//
//  MTGDuelViewController.h
//  MTGLifeCounter
//
//  Created by Orion Edwards on 31/01/14.
//  Copyright (c) 2014 Orion Edwards. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTGDuelViewController : UIViewController
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)d20ButtonPressed:(id)sender;
- (IBAction)refreshButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *container1;
@property (weak, nonatomic) IBOutlet UIView *container2;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@end
