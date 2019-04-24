//
//  ApiResponse.m
//
//  Created by xyg on 2017/3/18.
//  Copyright © 2017年 xyg. All rights reserved.
//

#import "ApiResponse.h"
#import "User.h"
#import "LoginViewController.h"
#import "RootManager.h"
@interface ApiResponse ()
/**
 *  api请求返回的状态码
 */
@property (nonatomic, copy, readwrite) NSString *code;

/**
 *  api请求返回的http状态码
 */
@property (nonatomic, assign, readwrite) NSInteger httpCode;

/**
 *  api请求返回的说明信息，如“请求成功”、“登陆失败等”
 */
@property (nonatomic, copy, readwrite) NSString *msg;

@end

@implementation ApiResponse

+ (instancetype)responseWithTask:(NSURLSessionTask *)task response:(id)responseObject error:(NSError *)error {
    ApiResponse *response = [[ApiResponse alloc] init];
    
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        response.code = responseObject[@"returncode"];
        response.msg = responseObject[@"msg"];
        if ([response.code isEqualToString:@"30001"]) {
            [User clearLocalUser];
        }
    }
    
    if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        response.httpCode = httpResponse.statusCode;
    }
    return response;
    
}

- (NSString *)msg {
    if (!_msg || _msg.length <= 0) {
        
        return NSLocalizedString(@"net_error", nil);
        
    }else if ([_msg isEqualToString:@"token失效"])
    {
        return nil;
    }else{
        return _msg;
    }
    
}

@end
