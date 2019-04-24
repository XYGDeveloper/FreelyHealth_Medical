//
//  AppDelegate.m
//  DirectClientProgect
//
//  Created by L on 2017/7/13.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ValidatorUtil.h"
//自定义错误提供给NSError使用
#define kCustomErrorDomain @"com.ygcr.ios"
#define PASSWORD @"[A-Za-z0-9]{6,20}"
typedef enum {
    eCustomErrorCodeFailure = 0
} eCustomErrorCode;
@implementation ValidatorUtil

//判断是否正确的手机号码
+ (BOOL)isValidMobile:(NSString *)mobile error:(NSError **)error;
{
    if (mobile.length == 11) {
        return true;
    }else{
        return false;
    }
}


+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex =@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//判断是否正确的密码格式
+ (BOOL)isValidPassword:(NSString *)password error:(NSError **)error
{
    NSDictionary *errorUserInfo;
    
    if (password.length < 6) {
        errorUserInfo = [NSDictionary dictionaryWithObject:@"密码长度必须六位以上" forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:kCustomErrorDomain code:eCustomErrorCodeFailure userInfo:errorUserInfo];
        return NO;
    }
    return YES;
}

+ (BOOL) isPassword:(NSString *)password{
    NSString *pwd = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
    NSPredicate *regextestPwd = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pwd];
    
    if ([regextestPwd evaluateWithObject:password]) {
        
        return YES;
    }
    return NO;
}

@end
