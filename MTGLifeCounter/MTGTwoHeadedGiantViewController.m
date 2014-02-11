//
//  MTGTwoHeadedGiantViewController.m
//  MTGLifeCounter
//
//  Created by Orion Edwards on 11/02/14.
//  Copyright (c) 2014 Orion Edwards. All rights reserved.
//

#import "MTGTwoHeadedGiantViewController.h"

@interface MTGTwoHeadedGiantViewController ()

@end

@implementation MTGTwoHeadedGiantViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSInteger)initialLifeTotal {
    return 30;
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

@end
