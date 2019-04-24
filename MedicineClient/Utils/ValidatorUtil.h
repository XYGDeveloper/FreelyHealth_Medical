//
//  AppDelegate.m
//  DirectClientProgect
//
//  Created by L on 2017/7/13.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidatorUtil : NSObject

//判断是否正确的手机号码格式
+ (BOOL)isValidMobile:(NSString *)mobile error:(NSError **)error;


+ (BOOL) validateEmail:(NSString *)email;

//判断是否正确的密码格式
+ (BOOL)isValidPassword:(NSString *)password error:(NSError **)error;

+ (BOOL) isPassword:(NSString *)password;

@end
