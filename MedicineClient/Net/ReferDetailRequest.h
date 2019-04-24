//
//  ReferDetailRequest.h
//  MedicineClient
//
//  Created by L on 2017/10/17.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface referDetailHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end


@interface referDetailBody : NSObject

@property (nonatomic , copy) NSString *taskno;

@property (nonatomic , copy) NSString *status;


@end


@interface ReferDetailRequest : NSObject

@property (nonatomic,strong)referDetailHeader *head;

@property (nonatomic,strong)referDetailBody *body;

@end
