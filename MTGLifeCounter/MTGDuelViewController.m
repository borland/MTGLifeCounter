//
//  MTGDuelViewController.m
//  MTGLifeCounter
//
//  Created by Orion Edwards on 31/01/14.
//  Copyright (c) 2014 Orion Edwards. All rights reserved.
//

#import "MTGDuelViewController.h"
#import "MTGPlayerViewController.h"
#import "MTGUtilityViews.h"

@interface MTGDuelViewController ()
@property(nonatomic, weak)MTGPlayerViewController* player1;
@property(nonatomic, weak)MTGPlayerViewController* player2;
@end

@implementation MTGDuelViewController

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
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)d20ButtonPressed:(id)sender {
    CGRect frame = UIScreen.mainScreen.bounds;
    frame.size.height -= UIApplication.sharedApplication.statusBarFrame.size.height;
    
    MTGDiceRollView* diceRollView = [[MTGDiceRollView alloc] initWithFrame:frame];
    diceRollView.diceFaceCount = 20;
    [self.view addSubview:diceRollView];
    
    [diceRollView rollWithCompletion:^(BOOL finished) {
        [diceRollView removeFromSuperview];
    }];}

- (IBAction)refreshButtonPressed:(id)sender {
    self.player1.lifeTotal = 20;
    [self.player1 selectRandomColor];
    self.player2.lifeTotal = 20;
    [self.player2 selectRandomColor];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"player1_embed"]) {
        self.player1 = (MTGPlayerViewController *) [segue destinationViewController];
        self.player1.playerName = @"P1";
        self.player1.lifeTotal = 20;

        switch (self.interfaceOrientation) {
            case UIInterfaceOrientationPortrait:
            case UIInterfaceOrientationPortraitUpsideDown:
                self.player1.isUpsideDown = YES;
                break;
                
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
                self.player1.isUpsideDown = NO;
                break;
        }
        
    }
    else if ([segueName isEqualToString: @"player2_embed"]) {
        self.player2 = (MTGPlayerViewController *) [segue destinationViewController];
        self.player2.playerName = @"P2";
        self.player2.lifeTotal = 20;
    }
    
    if(self.player1 && self.player2) {
        [self setConstraintsFor:self.interfaceOrientation];
    }
}

-(void)setConstraintsFor:(UIInterfaceOrientation)orientation {
    [self.view removeConstraints:self.view.constraints];
    
    UIView* c1 = self.container1;
    UIView* c2 = self.container2;
    UIView* toolbar = self.toolbar;
    
    NSDictionary* views = NSDictionaryOfVariableBindings(c1, c2, toolbar);
    
    void(^addConstraints)(NSArray*) = ^(NSArray* constraints) {
        [self.view addConstraints:constraints];
    };
    
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"V:|[c1(==c2)][c2(==c1)][toolbar(44)]|"
                                                                   options:0 metrics:nil views:views]);
            
            addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"|[c1]|"options:0 metrics:nil views:views]);
            
            addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"|[c2]|"options:0 metrics:nil views:views]);
            addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"|[toolbar]|"options:0 metrics:nil views:views]);
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"|[c1(==c2)][c2(==c1)]|"
                                                                   options:0 metrics:nil views:views]);

            addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"|[toolbar]|"options:0 metrics:nil views:views]);
            
            addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[c1][toolbar(44)]|"options:0 metrics:nil views:views]);
            
            addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[c2][toolbar(44)]|"options:0 metrics:nil views:views]);

            break;
        default:
            break;
    }
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self setConstraintsFor:toInterfaceOrientation];
    
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            self.player1.isUpsideDown = YES;
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            self.player1.isUpsideDown = NO;
            break;
    }
}

@end
