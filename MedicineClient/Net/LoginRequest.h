//
//  LoginRequest.h
//  MedicineClient
//
//  Created by L on 2017/8/14.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LoginRequestHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end

@interface LoginRequestBody : NSObject

@property (nonatomic,copy)NSString *phone;

@property (nonatomic,copy)NSString *captcha;

@end


@interface LoginRequest : NSObject

@property (nonatomic,strong)LoginRequestHeader *head;

@property (nonatomic,strong)LoginRequestBody *body;


@end
