//
//  MTGDuelViewController.m
//  MTGLifeCounter
//
//  Created by Orion Edwards on 31/01/14.
//  Copyright (c) 2014 Orion Edwards. All rights reserved.
//

#import "MTGDuelViewController.h"
#import "MTGPlayerViewController.h"

@interface MTGDuelViewController ()

@end

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
    // generate an unbiased random number
    
    double d = (double)rand() / (double)RAND_MAX;
    int n = d * 20 + 1;
    
    NSString* msg = [NSString stringWithFormat:@"You rolled %i", n];
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:msg
                                                   message:nil
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    
    [alert show];
}

- (IBAction)refreshButtonPressed:(id)sender {
    _player1.lifeTotal = 20;
    _player2.lifeTotal = 20;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"player1_embed"]) {
        _player1 = (MTGPlayerViewController *) [segue destinationViewController];
        _player1.playerName = @"P1";
        _player1.lifeTotal = 20;
        _player1.isUpsideDown = YES;
    }
    else if ([segueName isEqualToString: @"player2_embed"]) {
        _player2 = (MTGPlayerViewController *) [segue destinationViewController];
        _player2.playerName = @"P2";
        _player2.lifeTotal = 20;
    }
    
    if(_player1 && _player2) {
        [self setConstraintsFor:self.interfaceOrientation];
    }
}

-(void)setConstraintsFor:(UIInterfaceOrientation)orientation {
    // first, delete all the constraints
//    [self.view removeConstraints:self.view.constraints];
    
    // both are same width and height
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            
            break;
        default:
            NSAssert(false, @"Unexpected UIInterfaceOrientation %i", orientation);
            break;
    }
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self setConstraintsFor:toInterfaceOrientation];
}
@end
