//
//  ApiManager.h
//
//  Created by xyg on 2017/3/18.
//  Copyright © 2017年 xyg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiCommand.h"
#import "AFNetworking.h"
#define APIM [ApiManager sharedManager]

@interface ApiManager : NSObject

+ (instancetype)sharedManager;

- (NSURLSessionDataTask *)requestWithCommand:(ApiCommand *)command
                   constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
                                     success:(void(^)(NSURLSessionDataTask *task, ApiCommand *command, id responseObject))success
                                     failure:(void(^)(NSURLSessionDataTask *task, ApiCommand *command, NSError *error))failure;

@end
