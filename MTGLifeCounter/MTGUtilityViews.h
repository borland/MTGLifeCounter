//
//  MTGUtilityViews.h
//  MTGLifeCounter
//
//  Created by Orion Edwards on 31/01/14.
//  Copyright (c) 2014 Orion Edwards. All rights reserved.
//

#import <Foundation/Foundation.h>

int unbiasedRandom(int bound);

@interface MTGDisclosureIndicatorView : UIView
@end

@interface MTGDiceRollView : UIView

@property(nonatomic) NSUInteger diceFaceCount;

-(void)rollWithCompletion:(void (^)(BOOL finished))completion;
@end
