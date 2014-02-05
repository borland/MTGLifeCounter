//
//  MTGPlayerViewController.h
//  MTGLifeCounter
//
//  Created by Orion Edwards on 31/01/14.
//  Copyright (c) 2014 Orion Edwards. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTGPlayerBackgroundView;

@interface MTGPlayerViewController : UIViewController
- (IBAction)minusButtonPressed:(id)sender;
- (IBAction)plusButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet MTGPlayerBackgroundView *backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *lifeTotalLabel;
@property (weak, nonatomic) IBOutlet UIButton *playerNameButton;

- (IBAction)lifeTotalWasTapped:(UITapGestureRecognizer*)sender;
- (IBAction)lifeTotalPanning:(UIPanGestureRecognizer *)sender;


@property (nonatomic)BOOL isUpsideDown;

@property (nonatomic, copy)NSString* playerName;
@property (nonatomic)NSInteger lifeTotal;

-(void)selectRandomColor;
@end

@interface MTGPlayerBackgroundView : UIView
-(void)selectRandomColor;
@end
