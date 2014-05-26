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
#import "MTGDataStore.h"

@implementation MTGDuelViewController {
    __weak MTGPlayerViewController* _player1;
    __weak MTGPlayerViewController* _player2;
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
    [self setNeedsStatusBarAppearanceUpdate];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(NSInteger)initialLifeTotal {
    return 20;
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    
    NSDictionary* settings = [MTGDataStore getWithKey:NSStringFromClass(self.class)];
    if(settings) {
        _player1.lifeTotal = [[settings objectForKey:@"player1"] integerValue];
        _player2.lifeTotal = [[settings objectForKey:@"player2"] integerValue];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    
    NSDictionary* settings = @{ @"player1": @(_player1.lifeTotal),
                                @"player2": @(_player2.lifeTotal) };
    
    [MTGDataStore setWithKey:NSStringFromClass(self.class) value:settings];
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
    CGRect frame = self.view.frame;
    MTGDiceRollView* diceRollView = [[MTGDiceRollView alloc] initWithFrame:frame];
    diceRollView.diceFaceCount = 20;
    [self.view addSubview:diceRollView];
    
    [diceRollView rollWithCompletion:^(BOOL finished) {
        [diceRollView removeFromSuperview];
    }];
}

- (IBAction)refreshButtonPressed:(id)sender {
    _player1.lifeTotal = self.initialLifeTotal;
    [_player1 selectRandomColor];
    _player2.lifeTotal = self.initialLifeTotal;
    [_player2 selectRandomColor];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"player1_embed"]) {
        _player1 = (MTGPlayerViewController *) [segue destinationViewController];
        _player1.playerName = @"P1";
        _player1.lifeTotal = self.initialLifeTotal;

        switch (self.interfaceOrientation) {
            case UIInterfaceOrientationPortrait:
            case UIInterfaceOrientationPortraitUpsideDown:
                _player1.isUpsideDown = YES;
                break;
                
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
                _player1.isUpsideDown = NO;
                break;
        }
        
    }
    else if ([segueName isEqualToString: @"player2_embed"]) {
        _player2 = (MTGPlayerViewController *) [segue destinationViewController];
        _player2.playerName = @"P2";
        _player2.lifeTotal = self.initialLifeTotal;
    }
    
    if(_player1 && _player2) {
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
    
    addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"|[toolbar]|"options:0 metrics:nil views:views]);
    
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"V:|[c1(==c2)][toolbar(44)][c2(==c1)]|" options:0 metrics:nil views:views]);
            
            addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"|[c1]|"options:0 metrics:nil views:views]);
            addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"|[c2]|"options:0 metrics:nil views:views]);
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"|[c1(==c2)][c2(==c1)]|" options:0 metrics:nil views:views]);
           
            addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"V:|[c1][toolbar(44)]|"options:0 metrics:nil views:views]);
            addConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"V:|[c2][toolbar(44)]|"options:0 metrics:nil views:views]);

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
            _player1.isUpsideDown = YES;
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            _player1.isUpsideDown = NO;
            break;
    }
}

@end
