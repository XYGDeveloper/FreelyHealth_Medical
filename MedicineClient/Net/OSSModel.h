//
//  OSSModel.h
//  FreelyHeath
//
//  Created by xyg on 2017/8/3.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSSModel : NSObject

@property (nonatomic,copy)NSString *accessKeyId;

@property (nonatomic,copy)NSString *accessKeySecret;

@property (nonatomic,copy)NSString *securityToken;

@property (nonatomic,copy)NSString *expiration;

@property (nonatomic,copy)NSString *endpoint;

@property (nonatomic,copy)NSString *bucket;

@property (nonatomic,copy)NSString *uuid;



//accessKeyId	string	是	accessKeyId
//accessKeySecret	string	否	accessKeySecret
//securityToken	string	否	securityToken
//expiration	string	否	expiration
//endpoint	string	否	endpoint
//bucket	string	否	仓库
//uuid	string	否	唯一标识



@end
