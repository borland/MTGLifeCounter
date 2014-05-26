//
//  MTGDataStore.m
//  MTGLifeCounter
//
//  Created by Orion Edwards on 26/05/14.
//  Copyright (c) 2014 Orion Edwards. All rights reserved.
//

#import "MTGDataStore.h"

@implementation MTGDataStore

+(NSString*)filePathForKey:(NSString*)key {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [rootPath stringByAppendingPathComponent:key];
}

+(NSDictionary*)getWithKey:(NSString*)key {
    NSString* path = [self filePathForKey:key];

    // read json from the file
    NSFileManager* fileManager = NSFileManager.defaultManager;
    if(![fileManager fileExistsAtPath:path]) {
        return nil;
    }
    
    NSData* data = [fileManager contentsAtPath:path];
    
    // deserialize
    NSError* jsonError = nil;
    NSDictionary* jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
    
    if(jsonError) {
        NSLog(@"json read error %@", jsonError);
        return nil;
    }
    
    return jsonObject;
}

+(void)setWithKey:(NSString*)key value:(NSDictionary*)value {
    NSString* path = [self filePathForKey:key];
    
    // serialize
    NSError* error = nil;
    NSData* data = [NSJSONSerialization dataWithJSONObject:value options:0 error:&error];
    
    if(error) {
        NSLog(@"json write error %@", error);
        return;
    }
    
    // write json to the file
    NSFileManager* fileManager = NSFileManager.defaultManager;
    if([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:&error];
        if(error) {
            NSLog(@"cannot delete file at path %@", error);
        }
    }
    [fileManager createFileAtPath:path contents:data attributes:nil];
}
@end
