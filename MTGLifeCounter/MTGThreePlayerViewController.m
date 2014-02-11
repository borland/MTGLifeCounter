//
//  MTGThreePlayerViewController.m
//  MTGLifeCounter
//
//  Created by Orion Edwards on 31/01/14.
//  Copyright (c) 2014 Orion Edwards. All rights reserved.
//

#import "MTGThreePlayerViewController.h"
#import "MTGPlayerViewController.h"
#import "MTGUtilityViews.h"

@interface MTGThreePlayerViewController ()

@end

@implementation MTGThreePlayerViewController {
    MTGPlayerViewController* _player1;
    MTGPlayerViewController* _player2;
    MTGPlayerViewController* _player3;
}

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
    [self setNeedsStatusBarAppearanceUpdate];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"player1_embed"]) {
        _player1 = (MTGPlayerViewController *) [segue destinationViewController];
        _player1.playerName = @"P1";
        _player1.lifeTotal = 20;
    }
    else if ([segueName isEqualToString: @"player2_embed"]) {
        _player2 = (MTGPlayerViewController *) [segue destinationViewController];
        _player2.playerName = @"P2";
        _player2.lifeTotal = 20;
    }
    else if ([segueName isEqualToString: @"player3_embed"]) {
        _player3 = (MTGPlayerViewController *) [segue destinationViewController];
        _player3.playerName = @"P3";
        _player3.lifeTotal = 20;
    }
    
    if(_player1 && _player2 && _player3) {
        [self setConstraintsFor:self.interfaceOrientation];
    }
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)d20ButtonPressed:(id)sender {
    CGRect frame = self.view.frame;
    MTGDiceRollView* diceRollView = [[MTGDiceRollView alloc] initWithFrame:frame];
    diceRollView.diceFaceCount = 20;
    [self.view addSubview:diceRollView];
    
    [diceRollView rollWithCompletion:^(BOOL finished) {
        [diceRollView removeFromSuperview];
    }];
}

- (IBAction)refreshButtonPressed:(id)sender {
    _player1.lifeTotal = 20;
    [_player1 selectRandomColor];
    
    _player2.lifeTotal = 20;
    [_player2 selectRandomColor];
    
    _player3.lifeTotal = 20;
    [_player3 selectRandomColor];
}


-(void)setConstraintsFor:(UIInterfaceOrientation)orientation {
    [self.view removeConstraints:self.view.constraints];
    
    UIView* c1 = self.c1;
    UIView* c2 = self.c2;
    UIView* c3 = self.c3;
    UIView* toolbar = self.toolbar;
    
    NSDictionary* views = NSDictionaryOfVariableBindings(c1, c2, c3, toolbar);
    
    void(^addConstraints)(NSArray*) = ^(NSArray* constraints) {
        [self.view addConstraints:constraints];
    };
    
    addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"|[toolbar]|"options:0 metrics:nil views:views]);
    
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"V:|[c1(==c2)][c2(==c3)][c3(==c1)][toolbar(40)]|"
                                                                   options:0 metrics:nil views:views]);
            
            addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"|[c1]|"options:0 metrics:nil views:views]);
            addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"|[c2]|"options:0 metrics:nil views:views]);
            addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"|[c3]|"options:0 metrics:nil views:views]);
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"|[c1(==c2)][c2(==c3)][c3(==c1)]|"
                                                                   options:0 metrics:nil views:views]);
            
            addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"V:|[c1][toolbar(40)]|"options:0 metrics:nil views:views]);
            addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"V:|[c2][toolbar(40)]|"options:0 metrics:nil views:views]);
            addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"V:|[c3][toolbar(40)]|"options:0 metrics:nil views:views]);
            
            break;
        default:
            break;
    }
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self setConstraintsFor:toInterfaceOrientation];
    [_player1.view setNeedsDisplay];
    [_player2.view setNeedsDisplay];
    [_player3.view setNeedsDisplay];
}


@end
