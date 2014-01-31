//
//  MTGPlayerViewController.h
//  MTGLifeCounter
//
//  Created by Orion Edwards on 31/01/14.
//  Copyright (c) 2014 Orion Edwards. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTGPlayerViewController : UIViewController
- (IBAction)minusButtonPressed:(id)sender;
- (IBAction)plusButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lifeTotalLabel;
@property (weak, nonatomic) IBOutlet UIButton *playerNameButton;

@property (nonatomic)BOOL isUpsideDown;

@property (nonatomic, copy)NSString* playerName;
@property (nonatomic)NSInteger lifeTotal;

- (IBAction)lifeTotalWasTapped:(UITapGestureRecognizer*)sender;
- (IBAction)lifeTotalPanning:(UIPanGestureRecognizer *)sender;
@end

@interface MTGPlayerBackgroundView : UIView
@end
