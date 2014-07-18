//
//  UserData.m
//  Yo From
//
//  Created by Aakash on 7/15/14.
//  Copyright (c) 2014 Aakash. All rights reserved.
//

#import "UserData.h"

@implementation UserData
@synthesize history;
+ (id)sharedManager {
    static UserData *data = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        data = [[self alloc] init];
    });
    return data;
}

- (id)init {
    if (self = [super init]) {
        history = [[NSMutableArray alloc]init];
    }
    return self;
}

@end