//
//  MTGDataStore.h
//  MTGLifeCounter
//
//  Created by Orion Edwards on 26/05/14.
//  Copyright (c) 2014 Orion Edwards. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTGDataStore : NSObject

+(NSDictionary*)getWithKey:(NSString*)key;
+(void)setWithKey:(NSString*)key value:(NSDictionary*)value;

@end
