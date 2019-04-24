//
//  ApiCommand.m
//
//  Created by xyg on 2017/3/18.
//  Copyright © 2017年 xyg. All rights reserved.

#import "ApiCommand.h"
#import "Url.h"
@implementation ApiCommand

+ (instancetype)defaultApiCommand {
    ApiCommand *command = [[ApiCommand alloc] init];
    command.method = QQWRequestMethodPost;
    command.timeoutInterval = 30;
    return command;
}

+ (instancetype)getApiCommand {
    ApiCommand *command = [[ApiCommand alloc] init];
    command.method = QQWRequestMethodGet;
    command.timeoutInterval = 30;
    return command;
}

+ (NSString *)requestURLWithRelativePath:(NSString *)relativePath {
    if ([relativePath hasPrefix:@"/"]) {
        return [NSString stringWithFormat:@"%@",kApiDomin];
    } else {
        return [NSString stringWithFormat:@"%@",kApiDomin];
    }
}

@end
