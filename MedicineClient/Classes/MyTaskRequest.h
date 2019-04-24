//
//  MyTaskRequest.h
//  MedicineClient
//
//  Created by L on 2017/8/18.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTaskHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;


@end


@interface MyTaskBody : NSObject

@property (nonatomic , copy) NSString *status;

@end


@interface MyTaskRequest : NSObject

@property (nonatomic,strong)MyTaskHeader *head;

@property (nonatomic,strong)MyTaskBody *body;


@end
