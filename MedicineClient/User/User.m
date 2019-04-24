//
//  User.m
//  FreelyHealth
//
//  Created by L on 2017/7/15.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "User.h"

static User *_localUser = nil;
static NSString *const kLocalUserSaveKey = @"kLocalMedicalUserSaveKey";

@implementation User

MJExtensionCodingImplementation

+ (instancetype)LocalUser {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _localUser = [[TMCache sharedCache] objectForKey:kLocalUserSaveKey];
        if (!_localUser) {
            _localUser = [[User alloc] init];
        }
    });
    return _localUser;
    
}

+ (void)setLocalUser:(User *)user {
    if (user) {
        _localUser = nil;
        _localUser = user;
    } else {
        _localUser = [[User alloc] init];
    }
    
    [self saveToDisk];
    
}


+ (void)saveToDisk {
    
    [[TMCache sharedCache] setObject:[User LocalUser] forKey:kLocalUserSaveKey];
    
}


+ (void)clearLocalUser {
    [self setLocalUser:nil];
}


+ (BOOL)hasLogin {
        
    return [User LocalUser].token.length > 0;
}


@end
