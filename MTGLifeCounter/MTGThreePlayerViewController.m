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

@end
